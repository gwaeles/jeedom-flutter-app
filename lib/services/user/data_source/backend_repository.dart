
import 'package:flutter_app/services/user/model/user.dart';
import 'package:flutter_app/services/user/data_source/backend_api_provider.dart';

class BackendRepository {
  BackendApiProvider backendApiProvider;

  BackendRepository(String accessToken) {
    backendApiProvider = BackendApiProvider(accessToken);
  }

  BackendRepository.local(String accessToken) {
    backendApiProvider = BackendApiProvider.local(accessToken);
  }

  Future<User> fetchUser() => backendApiProvider.fetchUser();

  Future<bool> saveUser(User user) => backendApiProvider.saveUser(user);
}