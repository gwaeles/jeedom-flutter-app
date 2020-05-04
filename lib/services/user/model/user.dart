
class User {
  final String name;
  final String role;
  final Server server;

  User({this.name, this.role, this.server});

  factory User.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return User(server: Server.fromJson(null));
    }

    return User(
      name: json['name'],
      role: json['role'],
      server: Server.fromJson(json['server']),
    );
  }

  Map<String, dynamic> toJson() =>
      {
        'name': name,
        'role': role,
        'server': server?.toJson(),
      };
}


class Server {
  String localHostAddress;
  String remoteHostAddress;
  String jeedomUser;
  String apiKey;

  Server({this.localHostAddress, this.remoteHostAddress, this.jeedomUser, this.apiKey});

  factory Server.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return Server();
    }

    return Server(
      localHostAddress: json['localHostAddress'],
      remoteHostAddress: json['remoteHostAddress'],
      jeedomUser: json['jeedomUser'],
      apiKey: json['apiKey'],
    );
  }

  Map<String, dynamic> toJson() =>
      {
        'localHostAddress': localHostAddress,
        'remoteHostAddress': remoteHostAddress,
        'jeedomUser': jeedomUser,
        'apiKey': apiKey,
      };
}