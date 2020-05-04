
import 'package:flutter_app/services/user/model/user.dart';
import 'firestore_provider.dart';

class FireStoreRepository {
  FireStoreProvider fireStoreProvider;

  FireStoreRepository(String userId) {
    fireStoreProvider = FireStoreProvider(userId);
  }

  Stream<User> fetchUser() => fireStoreProvider.fetchUser();

  Future<bool> saveUser(User user) => fireStoreProvider.saveUser(user);
}