
class Pong {
  final String jsonrpc;
  final String id;
  final String result;
  final String error;

  Pong({this.jsonrpc, this.id, this.result, this.error});

  factory Pong.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return Pong(
        jsonrpc: '2.0',
        id: '1',
        result: null,
        error: null,
      );
    }

    return Pong(
      jsonrpc: json['jsonrpc'],
      id: json['id'],
      result: json['result'],
      error: json['error'],
    );
  }
}