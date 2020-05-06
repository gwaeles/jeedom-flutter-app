
import 'package:flutter/foundation.dart';

///
/// Responsibility :
/// - Params available from app scope
///
class SharedState with ChangeNotifier {
  bool _fromAuth = true;
  int _serverFormIndex = 0;

  bool get fromAuth => _fromAuth;
  int get serverFormIndex => _serverFormIndex;

  set fromAuth(bool value) {
    if (_fromAuth != value) {
      _fromAuth = value;
      notifyListeners();
    }
  }

  set serverFormIndex(int value) {
    if (_serverFormIndex != value) {
      _serverFormIndex = value;
      notifyListeners();
    }
  }
}