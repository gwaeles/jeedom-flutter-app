
import 'dart:async';

import 'package:flutter_app/utils/bloc_helpers/bloc_event_state.dart';
import 'package:flutter_app/services/jeedom/model/container_object.dart';
import 'package:flutter_app/services/jeedom/model/scenario.dart';
import 'package:flutter_app/services/user/model/user.dart';
import 'package:flutter_app/services/jeedom/data_source/jeedom_repository.dart';
import 'package:rxdart/rxdart.dart';

import 'jeedom_event.dart';
import 'jeedom_state.dart';

///
/// Responsibility :
/// - Gateway to Jeedom services
///
class JeedomBloc extends BlocEventStateBase<JeedomEvent, JeedomState> {

  // --- Config --- //

  BehaviorSubject<JeedomRequestStatus> _pingLocalController = BehaviorSubject<JeedomRequestStatus>();
  Stream<JeedomRequestStatus> get pingLocal => _pingLocalController;

  BehaviorSubject<JeedomRequestStatus> _pingRemoteController = BehaviorSubject<JeedomRequestStatus>();
  Stream<JeedomRequestStatus> get pingRemote => _pingRemoteController;

  BehaviorSubject<JeedomGetHashResult> _getApiKeyController = BehaviorSubject<JeedomGetHashResult>();
  Stream<JeedomGetHashResult> get getApiKey => _getApiKeyController;

  // --- Dashboard --- //

  BehaviorSubject<JeedomConnectionType> _connectionTypeController = BehaviorSubject<JeedomConnectionType>();
  Stream<JeedomConnectionType> get connectionType => _connectionTypeController;

  BehaviorSubject<List<Scenario>> _scenariosController = BehaviorSubject<List<Scenario>>();
  Stream<List<Scenario>> get scenarios => _scenariosController;

  BehaviorSubject<List<ContainerObject>> _containersController = BehaviorSubject<List<ContainerObject>>();
  Stream<List<ContainerObject>> get containers => _containersController;

  JeedomRepository jeedomLocalRepository;
  JeedomRepository jeedomRemoteRepository;

  @override
  Stream<JeedomState> eventHandler(JeedomEvent event, JeedomState currentState) async* {

    // --- Config --- //

    if (event.type == JeedomEventType.pingLocal){
      if (event.parameters is String) {
        var params = event.parameters as String;

        _initLocal(params, '');
        _pingLocal();
      }
    }

    if (event.type == JeedomEventType.pingRemote){
      if (event.parameters is String) {
        var params = event.parameters as String;

        _initRemote(params, '');
        _pingRemote();
      }
    }

    if (event.type == JeedomEventType.resetPingLocal){
      _pingLocalController.add(JeedomRequestStatus.idle);
    }

    if (event.type == JeedomEventType.resetPingRemote){
      _pingRemoteController.add(JeedomRequestStatus.idle);
    }

    if (event.type == JeedomEventType.getApiKey){
      if (event.parameters is Credentials) {
        var params = event.parameters as Credentials;

        _getApiKey(params.login, params.password);
      }
    }

    // --- Dashboard --- //

    if (event.type == JeedomEventType.init){
      yield JeedomState.initializing();

      try {
        var user = event.parameters as User;

        _connectionTypeController.add(JeedomConnectionType.idle);

        // --- Implementation --- //

        if (user.server.localHostAddress != null) {
          _initLocal('http://${user.server.localHostAddress}',
              user.server.apiKey);
        }

        if (user.server.remoteHostAddress != null) {
          _initRemote(
              user.server.remoteHostAddress,
              user.server.apiKey
          );
        }

        // --- Identify connection type --- //

        _connectionTypeController.add(await _identifyConnectionType());

        yield JeedomState.ready();

        // --- load Objects --- //

        //_loadContainerObjects();

        // --- load Scenarios --- //

        //_loadScenarios();
      }
      catch (e) {

        _connectionTypeController.add(JeedomConnectionType.error);

        yield JeedomState.error();
      }
    }

    if (event.type == JeedomEventType.loadContainerObjects){
      _loadContainerObjects();
    }

    if (event.type == JeedomEventType.loadScenarios){
      _loadScenarios();
    }
  }

  bool _initLocal(String url, String apiKey) {

    bool isSame = jeedomLocalRepository?.jeedomApiProvider?.url == url &&
        jeedomLocalRepository?.jeedomApiProvider?.apiKey == apiKey;

    if (!isSame) {
      jeedomLocalRepository = JeedomRepository.newInstance(url: url, apiKey: apiKey);
    }

    return !isSame;
  }

  bool _initRemote(String url, String apiKey) {
    bool isSame = jeedomRemoteRepository?.jeedomApiProvider?.url == url &&
        jeedomRemoteRepository?.jeedomApiProvider?.apiKey == apiKey;

    if (!isSame) {
      jeedomRemoteRepository = JeedomRepository.newInstance(url: url, apiKey: apiKey);
    }

    return !isSame;
  }

  // --- Config --- //

  _pingLocal() async {
    _pingLocalController.add(JeedomRequestStatus.idle);

    var pong = await jeedomLocalRepository.ping();

    _pingLocalController.add(pong == 'pong' ? JeedomRequestStatus.ok : JeedomRequestStatus.ko);
  }

  _pingRemote() async {
    _pingRemoteController.add(JeedomRequestStatus.idle);

    var pong = await jeedomRemoteRepository.ping();

    _pingRemoteController.add(pong == 'pong' ? JeedomRequestStatus.ok : JeedomRequestStatus.ko);
  }

  _getApiKey(String login, String password) async {
    _getApiKeyController.add(JeedomGetHashResult(login , '', JeedomRequestStatus.idle));

    JeedomRepository repository = _currentRepositoriy();

    String hash = await repository?.getApiKey(login, password);

    if (hash != null) {
      _getApiKeyController.add(JeedomGetHashResult(login, hash, JeedomRequestStatus.ok));
    }
    else {
      _getApiKeyController.add(JeedomGetHashResult(login, hash, JeedomRequestStatus.ko));
    }
  }

  // --- Dashboard --- //

  Future<JeedomConnectionType> _identifyConnectionType() async {

    if (jeedomLocalRepository == null &&
        jeedomRemoteRepository == null) {
      return JeedomConnectionType.error;
    }

    var controller = StreamController<JeedomConnectionType>();

    if (jeedomLocalRepository != null) {
      jeedomLocalRepository.ping()
          .then((pong) {
        if (pong == 'pong' && !controller.isClosed) {
          controller.sink.add(JeedomConnectionType.local);
        }
      });
    }

    if (jeedomRemoteRepository != null) {
      jeedomRemoteRepository.ping()
          .then((pong) {
        if (pong == 'pong' && !controller.isClosed) {
          controller.sink.add(JeedomConnectionType.remote);
        }
      });
    }

    // Timeout
    Future.delayed(Duration(seconds: 4), () {
      print('[GWA] Timeout of duration 4 sec');
      if (!controller.isClosed) {
        controller.sink.add(JeedomConnectionType.error);
      }
    });

    var result = await controller.stream.first;
    controller.close();

    return result;
  }

  JeedomRepository _currentRepositoriy() {
    if (_connectionTypeController.value == JeedomConnectionType.local) {
      return jeedomLocalRepository;
    }
    else if (_connectionTypeController.value == JeedomConnectionType.remote) {
      return jeedomRemoteRepository;
    }

    return null;
  }

  _loadContainerObjects() async {

    JeedomRepository repository = _currentRepositoriy();

    if (repository != null) {
      _containersController.add(await repository.getObjects());
    }
  }

  _loadScenarios() async {

    JeedomRepository repository = _currentRepositoriy();

    if (repository != null) {
      _scenariosController.add(await repository.getScenarios());
    }
  }
}

enum JeedomConnectionType {
  idle,
  local,
  remote,
  error,
}

enum JeedomRequestStatus {
  idle,
  ok,
  ko,
}

class JeedomGetHashResult {
  final String jeedomUser;
  final String apiKey;
  final JeedomRequestStatus state;

  JeedomGetHashResult(this.jeedomUser, this.apiKey, this.state);
}