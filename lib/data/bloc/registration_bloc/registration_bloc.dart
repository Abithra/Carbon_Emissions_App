import 'package:bloc/bloc.dart';
import 'package:carbon_emission_app/data/bloc/registration_bloc/registration_event.dart';
import 'package:carbon_emission_app/data/bloc/registration_bloc/registration_state.dart';
import 'package:carbon_emission_app/data/bloc/registration_bloc/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../database/emissions_database_helper.dart';
import '../../database/user_provider.dart';
import 'database_provider.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  RegistrationBloc() : super(RegistrationInitial());

  @override
  Stream<RegistrationState> mapEventToState(RegistrationEvent event) async* {
    if (event is RegisterUserEvent) {
      try {
        // Insert user data into the SQLite database
        final User user = User(
          id: 0,
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

        // Get the logged-in user
        User loggedInUser = await _getLoggedInUser();

        // Initialize emissions history database for the logged-in user
        EmissionsDatabaseHelper emissionsDatabase = await EmissionsDatabaseHelper
            .getInstance();

        // Simulate a successful registration for now
        yield RegistrationSuccess();
      } catch (e) {
        yield RegistrationFailure();
      }
    }
  }
  Future<User> _getLoggedInUser() async {
    // Retrieve the logged-in user from the UserProvider
    User? loggedInUser = UserProvider.getLoggedInUser();

    // If the logged-in user is null, you may want to throw an error or return a default user
    if (loggedInUser == null) {
      throw Exception('No logged-in user found');
    }

    return loggedInUser;
  }

}