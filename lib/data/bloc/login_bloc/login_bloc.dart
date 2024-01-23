import 'package:bloc/bloc.dart';
import 'package:carbon_emission_app/data/bloc/login_bloc/login_event.dart';
import 'package:carbon_emission_app/data/bloc/login_bloc/login_state.dart';
import 'package:carbon_emission_app/data/bloc/registration_bloc/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../database/user_provider.dart';
import '../registration_bloc/database_provider.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitialState()) {
    on<LoginUserEvent>((event, emit) async {
      // Handle the RegisterUserEvent here
      if (event is LoginUserEvent) {
        try {
          // Retrieve user from the SQLite database based on the provided email
          final List<User> users = await DatabaseProvider.getUsersByEmail(
              event.email);

          if (users.isEmpty) {
            emit(LoginErrorState("User not found"));
          } else {
            final User user = users.first;

            if (user.password == event.password) {
              // Set the logged-in user using UserProvider
              UserProvider.setLoggedInUser(user);
              // Successful login
              emit(LoginSuccessState(user));
            } else {
              // Incorrect password
              emit(LoginErrorState("Incorrect password"));
            }
          }
        } catch (e) {
          emit(LoginErrorState("Login failed: $e"));
        }
      }
    });
  }
}

