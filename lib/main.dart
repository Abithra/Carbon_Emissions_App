import 'package:carbon_emission_app/data/bloc/login_bloc/login_bloc.dart';
import 'package:carbon_emission_app/presentation/login_screen.dart';
import 'package:carbon_emission_app/presentation/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carbon_emission_app/data/bloc/registration_bloc/registration_bloc.dart';

import 'data/bloc/carbon_emissions_bloc/carbon_emissions_bloc.dart';


void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(),
        ),
        BlocProvider<RegistrationBloc>(
          create: (context) => RegistrationBloc(),
        ),

        BlocProvider<CarbonEmissionsBloc>(
          create: (context) => CarbonEmissionsBloc(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carbon Emissions App',
      theme: ThemeData(
        // Your theme configuration
      ),
      home: SplashScreen(),
    );
  }
}
