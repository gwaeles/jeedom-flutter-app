

import 'dart:async';
import 'dart:convert';

import 'package:flutter_app/utils/bloc_helpers/bloc_event_state.dart';
import 'package:flutter_app/services/jeedom/model/pong.dart';
import 'package:flutter_app/utils/validators/validator_network_ip.dart';
import 'package:rxdart/rxdart.dart';
import 'package:get_ip/get_ip.dart';
import 'package:http/http.dart' as http;

import 'scanner_event.dart';
import 'scanner_state.dart';

///
/// Responsibility :
/// - Scanner service to find Jeedom server on local network
///
class ScannerBloc extends BlocEventStateBase<ScannerEvent, ScannerState> with NetworkIpValidator {

  BehaviorSubject<ScanResult> _scanController = BehaviorSubject<ScanResult>();
  Stream<ScanResult> get scanner => _scanController;

  ScannerBloc()
      : super(
    initialState: ScannerState.idle(),
  );

  @override
  Stream<ScannerState> eventHandler(ScannerEvent event, ScannerState currentState) async* {
    if (event.type == ScannerEventType.start){
      yield ScannerState.running();

      fetchServer(event.ip);
    }

    if (event.type == ScannerEventType.complete){
      yield ScannerState.success();
    }

    if (event.type == ScannerEventType.stop){
      yield ScannerState.failure();
    }
  }

  @override
  void dispose() {
    _scanController?.close();
  }

  fetchServer(String ip) {

    if (ip != null && ip.length > 6) {
      scanIp(ip)
          .then((it) {
        if (it.success) {
          _scanController.add(it);
          emitEvent(ScannerEvent(type: ScannerEventType.complete));
        }
        else {
          emitEvent(ScannerEvent(type: ScannerEventType.stop));
        }
      });
    }
    else {
      try {
        GetIp.ipAddress.asStream()
            .transform(validateNetworkIp)
            .where((it) => it != null)
            .map((it) => it.substring(0, it.lastIndexOf('.')+1))
            .listen((prefixIp) {
          for (int cpt = 1; cpt <= 255; cpt++) {
            scanIp("$prefixIp$cpt")
                .then((it) {
              if (it.success) {
                _scanController.add(it);
                emitEvent(ScannerEvent(type: ScannerEventType.complete));
              }
            });
          }
        });
      }
      catch (err) {}
    }
  }

  Future<ScanResult> scanIp(String ip) async {

    try {
      final http.Response response = await http.post(
        'http://$ip/core/api/jeeApi.php',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'jsonrpc': '2.0',
          'id': '1',
          'method': 'ping',
        }),
      );

      if (response.statusCode == 200) {

        final Pong pong = Pong.fromJson(json.decode(response.body));

        if (pong.result != "pong") {
          return ScanResult(ip, false, 'Failed to parse response from ip=$ip');
        }

        return ScanResult(ip, true, null);
      } else {

        return ScanResult(ip, false, 'Failed to reach ip=$ip');
      }
    } catch (err) {
      return ScanResult(ip, false, err.toString());
    }

  }
}

class ScanResult {
  final String ip;
  final bool success;
  final String error;

  ScanResult(this.ip, this.success, this.error);
}