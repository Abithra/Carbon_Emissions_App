
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carbon_emission_app/constant/app_color.dart';
import 'package:carbon_emission_app/constant/app_textstyle.dart';
import '../data/bloc/login_bloc/login_bloc.dart';
import '../data/bloc/login_bloc/login_event.dart';
import '../data/bloc/login_bloc/login_state.dart';
import 'carbon_emissions_calculator_screen.dart';
import 'registration_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late LoginBloc _loginBloc;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();


  @override
  void initState() {
    super.initState();
    _loginBloc = context.read<LoginBloc>();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.textColorDark,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'User Login',
          style: AppTextStyles.heading(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocListener<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state is LoginSuccessState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Login successful!"),
                    duration: Duration(seconds: 3),
                  ),
                );
                // Navigate to the home screen or the desired screen after login
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>  CarbonEmissionsCalculator(),
                  ),
                );
              } else if (state is LoginErrorState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.errorMessage),
                    duration: Duration(seconds: 3),
                  ),
                );
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  alignment: Alignment.center,

                  height: height / 3,
                  child: const Image(image: AssetImage('assets/images/green.png')),
                ),
                // Email Field
              _buildTextField("Email", emailController, Icons.email),

              // Password Field
            _buildTextField("Password", passwordController, Icons.lock, isPassword: true),
            SizedBox(
                  height: height / 30,
                ),
                // Login Button
                ElevatedButton(
                  onPressed: () {
                    print("Login button pressed");
                    _loginBloc.add(
                      LoginUserEvent(
                        email: emailController.text,
                        password: passwordController.text,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(width * 2 / 3, height * 1 / 12),
                    foregroundColor: AppColors.textColorDark,
                    backgroundColor: AppColors.primary,
                  ),
                  child: Text(
                    'Login',
                    style: AppTextStyles.subtitle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: height / 30,
                ),
                // TextButton for registration
                TextButton(
                  onPressed: () {
                    // Navigate to the registration screen
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => RegistrationScreen()),
                    );
                  },
                  child: Text(
                    'Not registered? Register here',
                    style: AppTextStyles.bodyMedium(color: AppColors.primaryDark),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18.0),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primaryLight, AppColors.primaryVeryLighter],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(38.0),
        ),
        child: TextField(
          controller: controller,
          obscureText: isPassword,
          style: AppTextStyles.bodyLarge(color: AppColors.textColorDark),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: AppTextStyles.bodyLarge(color: AppColors.textColorDark),
            prefixIcon: Icon(icon, color: AppColors.textColorDark), // Use the provided icon
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15),
          ),
        ),
      ),
    );
  }

}
