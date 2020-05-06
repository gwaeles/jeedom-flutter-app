
import 'dart:async';

import 'package:flutter_app/utils/bloc_helpers/bloc_event_state.dart';
import 'package:flutter_app/services/authentication/model/auth_info.dart';
import 'package:flutter_app/services/user/model/user.dart';
import 'package:flutter_app/services/user/data_source/firestore_repository.dart';
import 'package:rxdart/rxdart.dart';

import 'user_event.dart';
import 'user_state.dart';

///
/// Responsibility :
/// - Gateway to Firebase firestore service
///
class UserBloc extends BlocEventStateBase<UserEvent, UserState> {

  BehaviorSubject<User> _userController = BehaviorSubject<User>();
  Stream<User> get user => _userController;

  FireStoreRepository fireStoreRepository;
  StreamSubscription firestoreSubscription;

  UserBloc()
      : super(
    initialState: UserState.starting(),
  );

  @override
  Stream<UserState> eventHandler(UserEvent event, UserState currentState) async* {

    assert(fireStoreRepository != null);

    if (event.type == UserEventType.load){
      yield UserState.loading();

      firestoreSubscription = fireStoreRepository.fetchUser().listen((onData) {
        _userController.add(onData);
      });

      yield UserState.loaded();
    }

    if (event.type == UserEventType.save){
      yield UserState.saving();

      await fireStoreRepository.saveUser(_userController.value);

      yield UserState.saved();
    }

    if (event.type == UserEventType.updateServerProperty){
      if (event.parameters is UpdateServerPropertyParameters) {
        var params = event.parameters as UpdateServerPropertyParameters;
        var user = _userController.value;

        if (params.value != null && user != null) {

          switch (params.propertyName) {
            case ServerPropertyName.localHostAddress:
              {
                if (user.server.localHostAddress != params.value) {
                  user.server.localHostAddress = params.value;
                  _userController.add(user);
                  emitEvent(UserEvent.save());
                }
              }
              break;

            case ServerPropertyName.remoteHostAddress:
              {
                if (user.server.remoteHostAddress != params.value) {
                  user.server.remoteHostAddress = params.value;
                  _userController.add(user);
                  emitEvent(UserEvent.save());
                }
              }
              break;

            case ServerPropertyName.jeedomUser:
              {
                if (user.server.jeedomUser != params.value) {
                  user.server.jeedomUser = params.value;
                  _userController.add(user);
                  emitEvent(UserEvent.save());
                }
              }
              break;

            case ServerPropertyName.apiKey:
              {
                if (user.server.apiKey != params.value) {
                  user.server.apiKey = params.value;
                  _userController.add(user);
                  emitEvent(UserEvent.save());
                }
              }
              break;
          }
        }
      }
    }
  }

  Function(AuthInfo) get authInfoResult => (data) {
    if (data != null) {
      if (fireStoreRepository == null ||
          fireStoreRepository.fireStoreProvider.userId != data.userId) {
        fireStoreRepository = FireStoreRepository(data.userId);

        //emitEvent(UserEvent.init());
        emitEvent(UserEvent.load());
      }
    }
  };

  @override
  void dispose() {
    _userController?.close();
    firestoreSubscription.cancel();
  }
}
