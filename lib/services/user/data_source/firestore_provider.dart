
import 'package:flutter_app/services/user/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreProvider {
  final database = Firestore.instance;
  final String userId;

  Stream<User> _userStream;

  FireStoreProvider(this.userId);

  Stream<User> fetchUser() {

    if (_userStream != null) {
      return _userStream;
    }

    _userStream =  database
        .collection("members")
        .document(userId)
        .snapshots()
        .map((document) => User.fromJson(document.data));

    return _userStream;
  }

  Future<bool> saveUser(User user) async {
    try {
      await database
          .collection("members")
          .document(userId)
          .updateData(user.toJson());
    }
    catch (e) {
      return false;
    }

    return true;
  }
}