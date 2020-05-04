import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/services/jeedom/model/container_object.dart';
import 'package:flutter_app/services/jeedom/model/jsonrpc_response.dart';
import 'package:flutter_app/services/jeedom/model/scenario.dart';
import 'package:http/http.dart' show Client, Response;

class JeedomApiProvider {

  JeedomApiProvider({
    @required this.url,
    this.apiKey: "",
  });

  Client client = Client();
  final String apiKey;
  final String url;


  Future<String> ping() async {
    return _computeRequest<String, String>('ping');
  }

  Future<String> getApiKey(String login, String password) async {
    try {
      Response response = await client.post(
        "$url/core/api/jeeApi.php",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'jsonrpc': '2.0',
          'id': '1',
          'method': 'user::getHash',
          "params": jsonEncode(<String, String>{
            "login": login,
            "password": password
          })
        }),
      );

      if (response.statusCode == 200) {
        return compute(_computeParsing, ResponseBody(String, response.body));
      }
    } catch (err) {
      print(err);
    }

    Future.error(Exception('Failed to make request'));
  }

  Future<List<ContainerObject>> getObjects() async {
    return _computeRequest<ContainerObject, List<ContainerObject>>('object::all');
  }

  Future<List<Scenario>> getScenarios() async {
    return _computeRequest<Scenario, List<Scenario>>('scenario::all');
  }

  Future<R> _computeRequest<U, R>(String method) async {
    try {
      Response response = await client.post(
        "$url/core/api/jeeApi.php",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'jsonrpc': '2.0',
          'id': '1',
          'method': method,
          "params": jsonEncode(<String, String>{"apikey": apiKey})
        }),
      );

      if (response.statusCode == 200) {
        return compute(_computeParsing, ResponseBody(U, response.body));
      }
    } catch (err) {
      print(err);
    }

    Future.error(Exception('Failed to make request'));
  }
}

FutureOr<R> _computeParsing<R>(ResponseBody responseBody) {
  return JsonrpcResponse.fromJson(responseBody).result;
}
