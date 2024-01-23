import '../bloc/registration_bloc/user_model.dart';

class UserProvider {
  static User? _loggedInUser; // Store the logged-in user

  static void setLoggedInUser(User user) {
    _loggedInUser = user;
  }

  static User? getLoggedInUser() {
    return _loggedInUser;
  }
}