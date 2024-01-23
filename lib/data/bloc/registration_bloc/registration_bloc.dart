import 'package:bloc/bloc.dart';
import 'package:carbon_emission_app/data/bloc/registration_bloc/registration_event.dart';
import 'package:carbon_emission_app/data/bloc/registration_bloc/registration_state.dart';
import 'package:carbon_emission_app/data/bloc/registration_bloc/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'database_provider.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  RegistrationBloc() : super(RegistrationInitial()) {
    on<RegisterUserEvent>((event, emit) async {
      // Handle the RegisterUserEvent here
      if (event is RegisterUserEvent) {
        try {
          // Insert user data into the SQLite database
          final User user = User(
            id: 0, // SQLite will auto-generate the ID
            name: event.name,
            email: event.email,
            age: event.age,
            password: event.password,
            country: event.country,
          );
          await DatabaseProvider.insertUser(user);
          // Store the selected country using flutter_secure_storage
          const secureStorage = FlutterSecureStorage();
          await secureStorage.write(key: 'selectedCountry', value: event.country);
          // Simulate a successful registration for now
          emit(RegistrationSuccess());
        } catch (e) {
          emit(RegistrationFailure());
        }
      }
    });
  }

  @override
  Stream<RegistrationState> mapEventToState(RegistrationEvent event) async* {
    if (event is RegisterUserEvent) {
      try {
        // Insert user data into the SQLite database
        final User user = User(
          id: 0, // SQLite will auto-generate the ID
          name: event.name,
          email: event.email,
          age: event.age,
          password: event.password,
          country: event.country,
        );
        await DatabaseProvider.insertUser(user);

        // Simulate a successful registration for now
        yield RegistrationSuccess();
      } catch (e) {
        yield RegistrationFailure();
      }
    }
  }
}
