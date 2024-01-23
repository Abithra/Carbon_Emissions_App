import 'package:equatable/equatable.dart';

abstract class RegistrationEvent extends Equatable {
  const RegistrationEvent();

  @override
  List<Object> get props => [];
}

class RegisterUserEvent extends RegistrationEvent {
  final String name;
  final String email;
  final String age;
  final String password;
  final String country;

  RegisterUserEvent({
    required this.name,
    required this.email,
    required this.age,
    required this.password,
    required this.country,
  });
}
