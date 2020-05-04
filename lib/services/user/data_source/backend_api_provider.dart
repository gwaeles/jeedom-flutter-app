import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_app/services/user/model/user.dart';
import 'package:http/http.dart' show Client, Response;

class BackendApiProvider {
  Client client = Client();
  final _urlStaging = 'https://disco-newbie.herokuapp.com';
  final _urlLocal = 'http://localhost:8080';
  String url;
  final accessToken;

  BackendApiProvider(this.accessToken) {
    this.url = _urlStaging;
  }

  BackendApiProvider.local(this.accessToken) {
    this.url = _urlLocal;
  }

  Future<User> fetchUser() async {
    var headers = {
      "grant_type": "google",
      HttpHeaders.authorizationHeader: "Bearer $accessToken"
    };
    final response = await client
        .get('$url/members/me', headers: headers);

    if (response?.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    }

    throw Exception('Failed to fetch User');
  }

  Future<bool> saveUser(User user) async {

    var headers = {
      "grant_type": "google",
      HttpHeaders.authorizationHeader: "Bearer $accessToken",
      HttpHeaders.contentTypeHeader: "application/json"
    };

    var body = json.encode(user);
    final response = await client
        .put(
        '$url/members/me',
        headers: headers,
        body: body
    );

    return response?.statusCode == 200;
  }
}