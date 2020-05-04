import 'dart:async';

const String _kNetworkIpRule = r"^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$";

class NetworkIpValidator {
  final StreamTransformer<String,String> validateNetworkIp = StreamTransformer<String,String>.fromHandlers(handleData: (networkIp, sink){
    final RegExp networkIpExp =
        new RegExp(_kNetworkIpRule);

    if (!networkIpExp.hasMatch(networkIp)){
      sink.addError('Enter a valid network Ip');
    } else {
      sink.add(networkIp);
    }
  });
}
