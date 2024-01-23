import 'dart:convert';

import 'package:carbon_emission_app/presentation/general_information_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constant/app_color.dart';
import '../constant/app_textstyle.dart';
import '../data/bloc/carbon_emissions_bloc/carbon_emissions_bloc.dart';
import '../data/database/emissions_database_helper.dart';
import 'app_data.dart';

class ProfileScreen extends StatefulWidget {
  final DateTime? selectedDate;
  const ProfileScreen({Key? key, required this.selectedDate}) : super(key: key);

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  late Future<List<double>> emissionsHistory;
  DateTime? selectedDateFromBloc; // Add selectedDateFromBloc property
  String selectedCountry = '';


  Future<void> _loadSelectedCountry() async {
    const secureStorage = FlutterSecureStorage();
    String? storedCountry = await secureStorage.read(key: 'selectedCountry');
    setState(() {
      selectedCountry = storedCountry ?? '';
    });
  }

  Future<Map<String, String>> _loadCountryRegulations(String countryName) async {
    try {
      // Load JSON file content
      String jsonString = await rootBundle.loadString('assets/countries_regulations.json');
      Map<String, dynamic> jsonMap = json.decode(jsonString);

      // Extract the list of countries from the JSON
      List<dynamic> countriesData = jsonMap['countries'];

      // Find the regulations for the selected country
      Map<String, String> countryRegulations = {};
      for (var countryData in countriesData) {
        if (countryData['name'] == countryName) {
          countryRegulations['emissionsRegulations'] = countryData['emissions_regulations'];
          break;
        }
      }

      return countryRegulations;
    } catch (e) {
      print('Error loading country regulations: $e');
      return {};
    }
  }


  @override
  void initState() {
    super.initState();
    emissionsHistory = _displayEmissionsHistory();
    _loadSelectedCountry();
    selectedDateFromBloc = context.read<CarbonEmissionsBloc>().selectedDate;
    print('Init State - Selected Country: $selectedCountry');
  }


  Future<List<double>> _displayEmissionsHistory() async {
    EmissionsDatabaseHelper emissionsDatabase = await EmissionsDatabaseHelper.getInstance();

    List<Map<String, dynamic>> history = await emissionsDatabase.getEmissionsHistory();

    return history.map((e) => e['emissions_value'] as double).toList();
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
          'Your Profile',
          style: AppTextStyles.heading(color: AppColors.textColorDark),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.file_present,
              color: AppColors.textColorDark,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GeneralInformationScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.primaryVeryLighter,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Emissions History',
                      style: AppTextStyles.heading(color: AppColors.textColorLight),
                    ),
                    SizedBox(height: height / 30),
                    _buildEmissionsHistoryList(),
                  ],
                ),
              ),
              SizedBox(height: height / 40),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.primaryLighter.shade50,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'General Emissions for Your Country',
                      style: AppTextStyles.heading(color: AppColors.textColorLight),
                    ),
                    SizedBox(height: height / 30),
                    _buildGeneralEmissions(),
                  ],
                ),
              ),

            ],
          ),
        ),
      )
    );
  }

  Widget _buildEmissionsHistoryList() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: EmissionsDatabaseHelper.getInstance().then((helper) => helper.getEmissionsHistory()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('No emissions history available.');
        } else {
          List<Map<String, dynamic>> emissionsHistory = snapshot.data!;
          return ListView.builder(
            shrinkWrap: true,
            itemCount: emissionsHistory.length,
            itemBuilder: (context, index) {
              double emissionsValue = emissionsHistory[index]['emissions_value'];
              String? dateString = emissionsHistory[index]['selected_date'];

              // Perform null check before parsing the date
              DateTime selectedDate = dateString != null
                  ? DateTime.parse(dateString)
                  : DateTime.now();

              return ListTile(
                title: Text(
                  '${DateFormat('yyyy-MM-dd').format(selectedDate)}: ${emissionsValue} kg CO2',
                  style: AppTextStyles.subtitle(color: AppColors.textColorLight),
                ),
              );
            },
          );
        }
      },
    );
  }



  Widget _buildGeneralEmissions() {
    return FutureBuilder<Map<String, String>>(
      future: _loadCountryRegulations(selectedCountry),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('Regulations for $selectedCountry:\n historically, did not have modern carbon emissions regulations. Please note that this entry refers to a historical entity.');
        } else {
          String emissionsRegulations = snapshot.data!['emissionsRegulations'] ?? 'No specific regulations.';
          return Text('Regulations for $selectedCountry:\n$emissionsRegulations');
        }
      },
    );
  }

  Widget _buildSelectedDate() {
    return Text(
      selectedDateFromBloc != null
          ? ' ${DateFormat('yyyy-MM-dd').format(selectedDateFromBloc!)}'
          : 'No date selected',
      style: AppTextStyles.subtitle(color: AppColors.textColorLight),
    );
  }
}
