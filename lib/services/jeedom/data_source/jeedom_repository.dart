
import 'package:flutter_app/services/jeedom/model/container_object.dart';
import 'package:flutter_app/services/jeedom/model/scenario.dart';
import 'package:flutter_app/services/jeedom/data_source/jeedom_api_provider.dart';

class JeedomRepository {

  JeedomRepository({this.jeedomApiProvider});

  factory JeedomRepository.newInstance({String url, String apiKey = ""}) {
    return JeedomRepository(
      jeedomApiProvider: JeedomApiProvider(url: url, apiKey: apiKey)
    );
  }

  final JeedomApiProvider jeedomApiProvider;

  Future<String> ping() => jeedomApiProvider.ping();

  Future<String> getApiKey(String login, String password) => jeedomApiProvider.getApiKey(login, password);

  Future<List<ContainerObject>> getObjects() => jeedomApiProvider.getObjects();

  Future<List<Scenario>> getScenarios() => jeedomApiProvider.getScenarios();
}