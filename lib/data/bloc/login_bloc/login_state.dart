// login_state.dart
import 'package:carbon_emission_app/data/bloc/registration_bloc/user_model.dart';
import 'package:equatable/equatable.dart';



abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}


class LoginInitialState extends LoginState {}

class LoginSuccessState extends LoginState {
  final User user;

  LoginSuccessState(this.user);
}

class LoginErrorState extends LoginState {
  final String errorMessage;

  LoginErrorState(this.errorMessage);
}