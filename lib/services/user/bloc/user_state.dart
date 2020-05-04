
import 'package:flutter_app/utils/bloc_helpers/bloc_event_state.dart';

class UserState extends BlocState {
  UserState({
    this.initialized: true,
    this.loading: false,
    this.loaded: false,
    this.modified: false,
    this.saving: false,
    this.saved: false,
  });

  final bool initialized;
  final bool loading;
  final bool loaded;
  final bool modified;
  final bool saving;
  final bool saved;

  @override
  List<Object> get props => [
    initialized,
    loading,
    loaded,
    modified,
    saving,
    saved
  ];

  factory UserState.starting() {
    return UserState(initialized: false);
  }

  factory UserState.ready() {
    return UserState();
  }

  factory UserState.loading(){
    return UserState(loading: true);
  }

  factory UserState.loaded(){
    return UserState(loaded: true);
  }

  factory UserState.modified(){
    return UserState(modified: true);
  }

  factory UserState.saving(){
    return UserState(saving: true);
  }

  factory UserState.saved(){
    return UserState(saved: true);
  }

}