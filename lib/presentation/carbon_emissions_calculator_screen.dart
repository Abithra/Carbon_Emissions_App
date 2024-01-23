import 'package:carbon_emission_app/presentation/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../constant/app_color.dart';
import '../constant/app_textstyle.dart';
import '../data/bloc/carbon_emissions_bloc/carbon_emissions_bloc.dart';
import '../data/bloc/carbon_emissions_bloc/carbon_emissions_event.dart';
import '../data/database/emissions_database_helper.dart';

class CarbonEmissionsCalculator extends StatefulWidget {
  const CarbonEmissionsCalculator({super.key});

  @override
  CarbonEmissionsCalculatorState createState() => CarbonEmissionsCalculatorState();
}

class CarbonEmissionsCalculatorState extends State<CarbonEmissionsCalculator> {
  double electricityUsage = 0.0;
  double transportationEmissions = 0.0;
  double wasteEmissions = 0.0;
  double totalEmissions = 0.0;
  List<double> emissionsHistory = [];
  DateTime selectedDate = DateTime.now();


  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000), // Set the start date for your date picker
      lastDate: DateTime(2101),  // Set the end date for your date picker
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });

      // Dispatch the event to update the selected date in the bloc
      context.read<CarbonEmissionsBloc>().add(UpdateEmissionsEvent(
        electricityUsage: electricityUsage,
        transportationEmissions: transportationEmissions,
        wasteEmissions: wasteEmissions,
        selectedDate: picked, // Pass the selected date to the event
      ));

    }
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
          'Carbon Emissions Calculator',
          style: AppTextStyles.heading(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.person,
              color: AppColors.textColorDark,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(selectedDate: selectedDate),
                ),
              );
            },
          ),

        ],
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: height / 25),
                Container(
                  alignment: Alignment.center,
                  width: width,
                  height: height / 5,
                  child: const Image(image: AssetImage('assets/images/green.png')),
                ),
                SizedBox(height: height / 25),
                _buildInputField(
                  label: 'Electricity Usage (kWh)',
                  onChanged: (value) {
                    setState(() {
                      electricityUsage = double.tryParse(value) ?? 0.0;
                      _updateTotalEmissions();
                    });
                  },
                ),
                SizedBox(height: height / 35),
                _buildInputField(
                  label: 'Transportation Emissions (kg CO2)',
                  onChanged: (value) {
                    setState(() {
                      transportationEmissions = double.tryParse(value) ?? 0.0;
                      _updateTotalEmissions();
                    });
                  },
                ),
                SizedBox(height: height / 35),
                _buildInputField(
                  label: 'Waste Emissions (kg CO2)',
                  onChanged: (value) {
                    setState(() {
                      wasteEmissions = double.tryParse(value) ?? 0.0;
                      _updateTotalEmissions();
                    });
                  },
                ),
                SizedBox(height: height / 35),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(30.0),
                    border: Border.all(color: AppColors.primaryLight),
                  ),
                  child: TextButton(
                    onPressed: () => _selectDate(context),
                    child: Text(
                      selectedDate != null
                          ? 'Select the Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}'
                          : 'Select Date',
                      style: AppTextStyles.bodyLarge(color: AppColors.textColorDark),
                    ),
                  ),
                ),



                SizedBox(height: height / 45),

                Text(
                  'Total Emissions: $totalEmissions kg CO2',
                  style: AppTextStyles.heading(color: AppColors.primaryLight.shade100),
                ),
                SizedBox(height: height / 25),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(width * 2 / 3, height * 1 / 12),
                    foregroundColor: AppColors.textColorDark,
                    backgroundColor: AppColors.primary,
                  ),
                  onPressed: () {
                    _trackEmissions(context);
                    _resetInputs();
                  },
                  child: const Text('Track Emissions'),
                ),
                SizedBox(height: height / 25),
               // _buildEmissionsHistory(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({required String label, required ValueChanged<String> onChanged}) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTextStyles.bodyLarge(color: AppColors.primaryDark),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
        ),
        filled: true,
        fillColor: AppColors.primaryVeryLighter.shade50,
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onChanged: onChanged,
    );
  }

  void _updateTotalEmissions() {
    setState(() {
      totalEmissions = electricityUsage + transportationEmissions + wasteEmissions;
    });
  }

  void _trackEmissions(BuildContext context) async {
    // Calculate emissions
    double calculatedEmissions = electricityUsage + transportationEmissions + wasteEmissions;

    EmissionsDatabaseHelper emissionsDatabase = await EmissionsDatabaseHelper.getInstance();
    await emissionsDatabase.insertEmissionsHistory(emissionsValue: calculatedEmissions, selectedDate: selectedDate.toString());

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Emissions history successfully updated'),
        duration: Duration(seconds: 5),
      ),
    );
  }






  void _resetInputs() {
    formKey.currentState?.reset(); // Reset the form
    setState(() {
      electricityUsage = 0.0;
      transportationEmissions = 0.0;
      wasteEmissions = 0.0;
      totalEmissions = 0.0;
    });
  }

  Widget _buildEmissionsHistory() {
    if (emissionsHistory.isEmpty) {
      return SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Emissions History:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          itemCount: emissionsHistory.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('Entry ${index + 1}: ${emissionsHistory[index]} kg CO2'),
            );
          },
        ),
      ],
    );
  }
}
