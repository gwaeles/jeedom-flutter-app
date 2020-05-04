
import 'dart:convert';

import 'package:flutter_app/services/jeedom/model/container_object.dart';
import 'package:flutter_app/services/jeedom/model/scenario.dart';

import 'jeedom_entity.dart';

class JsonrpcResponse {
  final String jsonrpc;
  final String id;
  final dynamic result;
  final String error;

  JsonrpcResponse({this.jsonrpc, this.id, this.result, this.error});

  factory JsonrpcResponse.fromJson(ResponseBody responseBody) {

    final parsed = json.decode(responseBody.body);

    if (parsed == null || parsed['result'] == null) {
      return JsonrpcResponse(
        jsonrpc: '2.0',
        id: '1',
        result: null,
        error: null,
      );
    }

    var data;
    if (parsed['result'] is String) {
      data = parsed['result'] as String;
    }
    else if (parsed['result'] is Iterable) {
      if (responseBody.type == ContainerObject) {
        data = parsed['result'].map<ContainerObject>((json) => ContainerObject.fromJson(json)).toList();
      }
      else if (responseBody.type == Scenario) {
        data = parsed['result'].map<Scenario>((json) => Scenario.fromJson(json)).toList();
      }
    }
    else {
      data = JeedomEntity.fromJson(responseBody.type, parsed['result']);
    }

    return JsonrpcResponse(
      jsonrpc: parsed['jsonrpc'],
      id: parsed['id'],
      result: data,
      error: parsed['error'],
    );
  }
}

class ResponseBody<U> {
  final Type type;
  final bool isList;
  final String body;

  ResponseBody(this.type, this.body, [this.isList = false]);
}