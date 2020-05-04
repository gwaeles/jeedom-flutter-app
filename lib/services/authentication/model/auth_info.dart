
import 'package:equatable/equatable.dart';

class AuthInfo extends Equatable {
  final String userId;
  final String userName;
  final String userEmail;
  final String idToken;
  final DateTime expirationTime;

  AuthInfo({this.userId, this.userName, this.userEmail, this.idToken, this.expirationTime});

  @override
  List<Object> get props => [userId];

  factory AuthInfo.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return AuthInfo(
        userId: null,
        userName: null,
        userEmail: null,
        idToken: null,
        expirationTime: null,
      );
    }

    return AuthInfo(
      userId: json['userId'],
      userName: json['userName'],
      userEmail: json['userEmail'],
      idToken: json['idToken'],
      expirationTime: DateTime.parse(json['expirationTime']),
    );
  }

  Map<String, dynamic> toJson() =>
      {
        'userId': userId,
        'userName': userName,
        'userEmail': userEmail,
        'idToken': idToken,
        'expirationTime': expirationTime.toIso8601String(),
      };
}