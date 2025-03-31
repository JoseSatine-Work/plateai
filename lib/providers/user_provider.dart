import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/app/Models/user.dart';

class UserProvider extends ChangeNotifier {
  User? _user;

  User? get user => _user;

  // Set a new user instance
  void setUser(User newUser) {
    _user = newUser;
    notifyListeners();
  }

  // Clear the user instance
  void clearUser() {
    _user = null;
    notifyListeners();
  }
}
