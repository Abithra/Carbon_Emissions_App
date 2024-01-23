import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carbon_emission_app/constant/app_color.dart';
import 'package:carbon_emission_app/constant/app_textstyle.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/bloc/registration_bloc/registration_bloc.dart';
import '../data/bloc/registration_bloc/registration_event.dart';
import '../data/bloc/registration_bloc/registration_state.dart';
import 'app_data.dart';
import 'login_screen.dart';
import 'package:country_pickers/countries.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  RegistrationScreenState createState() => RegistrationScreenState();
}

class RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  late RegistrationBloc _registrationBloc;
  late FlutterSecureStorage _secureStorage;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _registrationBloc = context.read<RegistrationBloc>();
    _secureStorage = const FlutterSecureStorage();
  }

  List<Map<String, dynamic>> _getCountriesList() {
    List<Map<String, dynamic>> countries = countryList
        .map((country) => {'key': country.name, 'value': country.name})
        .toList();

    // Print the list of countries
    print("List of Countries: $countries");

    return countries;
  }



  List<DropdownMenuItem<String>> _convertToDropdownItems(List<Map<String, dynamic>> items) {
    return items
        .map((item) => DropdownMenuItem<String>(
      value: item['key'],
      child: Text(item['value']),
    ))
        .toList();
  }

  Future<void> _saveCountryCode(String countryCode) async {
    // Use flutter_secure_storage to save the selected country code
    await _secureStorage.write(key: 'selectedCountryCode', value: countryCode);
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
          'User Registration',
          style: AppTextStyles.heading(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: BlocListener<RegistrationBloc, RegistrationState>(
              listener: (context, state) {
                if (state is RegistrationSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Registration successful!"),
                      duration: Duration(seconds: 3),
                    ),
                  );
                  // Store the selected country in AppData
                 // AppData.selectedCountry = countryController.text;
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>  LoginScreen(),
                    ),
                  );
                } else if (state is RegistrationFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Registration Unsuccessful'),
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
                    height: height / 5,
                    child: const Image(image: AssetImage('assets/images/green.png')),
                  ),
                  SizedBox(height: height / 30),
                  _buildTextField("Name", nameController, Icons.person, validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  }),
                  SizedBox(height: height / 30),
                  _buildTextField("Email", emailController, Icons.email, validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    // Add email format validation if needed
                    return null;
                  }),
                  SizedBox(height: height / 30),
                  _buildTextField("Age", ageController, Icons.date_range, validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your age';
                    }
                    // Add age validation if needed
                    return null;
                  }),
                  SizedBox(height: height / 30),
                  _buildTextField("Password", passwordController, Icons.lock, isPassword: true, validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    // Add password strength validation if needed
                    return null;
                  }),
                  SizedBox(height: height / 30),
                  _buildTextField("Country", countryController, Icons.home, validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select your country';
                    }
                    return null;
                  }),
                  SizedBox(height: height / 30),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        _registrationBloc.add(
                          RegisterUserEvent(
                            name: nameController.text,
                            email: emailController.text,
                            age: ageController.text,
                            password: passwordController.text,
                            country: countryController.text,
                          ),
                        );

                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(width * 2 / 3, height * 1 / 12),
                      foregroundColor: AppColors.textColorDark,
                      backgroundColor: AppColors.primary,
                    ),
                    child: Text(
                      'Register',
                      style: AppTextStyles.subtitle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon,
      {bool isPassword = false, String? Function(String?)? validator}) {
    double textFieldHeight = 60.0;
    if (label.toLowerCase() == "country") {
      List<Map<String, dynamic>> countriesList = _getCountriesList();
      String initialValue = countriesList.isNotEmpty ? countriesList[0]['key'] : 'Select a country';
      return Container(
        height: textFieldHeight,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primaryLight, AppColors.primaryVeryLighter],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        child: DropdownButton2<String>(
          items: _convertToDropdownItemsWithIcons(countriesList),
          value: controller.text.isNotEmpty ? controller.text : initialValue,
          onChanged: (value) async {
            print('Selected Country Changed: $value');
            setState(() {
              controller.text = value ?? '';
            });
          },

          style: AppTextStyles.bodyLarge(color: AppColors.textColorDark),
          isExpanded: true,
          dropdownStyleData: DropdownStyleData(
            padding: EdgeInsets.all(10),
            maxHeight: 400,
            width: 400,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primaryLight, AppColors.primaryVeryLighter],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            offset: const Offset(-20, 0),
            scrollbarTheme: ScrollbarThemeData(
              radius: const Radius.circular(40),
              thickness: MaterialStateProperty.all<double>(6),
              thumbVisibility: MaterialStateProperty.all<bool>(true),
            ),
          ),
        ),
      );
    } else {
      return Container(
        height: textFieldHeight,
        padding: const EdgeInsets.symmetric(vertical: 18.0),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primaryLight, AppColors.primaryVeryLighter],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Icon(icon, color: AppColors.textColorDark, size: 20),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextFormField(
                  controller: controller,
                  obscureText: isPassword,
                  validator: validator,
                  style: AppTextStyles.bodyLarge(color: AppColors.textColorDark),
                  decoration: InputDecoration(
                    labelText: label,
                    labelStyle: AppTextStyles.bodyLarge(color: AppColors.textColorDark),
                    border: InputBorder.none,
                    floatingLabelStyle: AppTextStyles.bodyLarge(color: AppColors.textColorDark),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  List<DropdownMenuItem<String>> _convertToDropdownItemsWithIcons(List<Map<String, dynamic>> items) {
    return items
        .map((item) => DropdownMenuItem<String>(
      value: item['key'],
      child: Row(
        children: [
          const Icon(Icons.flag, color: AppColors.textColorDark),
          const SizedBox(width: 20),
          Text(item['value']),
        ],
      ),
    ))
        .toList();
  }
}
