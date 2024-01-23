import 'package:flutter/material.dart';

import '../constant/app_color.dart';
import '../constant/app_textstyle.dart';

class GeneralInformationScreen  extends StatefulWidget {
  const GeneralInformationScreen({super.key});

  @override
  GeneralInformationScreenState createState() => GeneralInformationScreenState();
}

class GeneralInformationScreenState extends State<GeneralInformationScreen> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        title: Center(
          child: Text(
            'Carbon Emissions and the Environment',
            style: AppTextStyles.subtitle(color: AppColors.textColorDark),
          ),
        )
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
             Container(
               decoration: BoxDecoration(
                 color: AppColors.textColorLight,
                 border: Border.all(
                   color: AppColors.primaryDark, // Set the border color
                   width: 2.0, // Set the border width
                 ),
               ),
               child:  Row(
                 children: [
                   Expanded(
                     child: Container(
                       alignment: Alignment.center,
                       // width: width/15,
                       height: height / 5,
                       child: const Image(image: AssetImage('assets/images/green.png')),
                     ),
                   ),
                   Expanded(
                     child: Container(
                       padding: const EdgeInsets.all(16.0), // Adjust padding as needed
                       child: const Text(
                         'Carbon emissions refer to the release of carbon compounds into the atmosphere, primarily in the form of carbon dioxide (CO2).\n\nThese emissions are a major contributor to the greenhouse effect, leading to global warming and climate change.',
                         style: TextStyle(color: AppColors.textColorDark), // Text color
                       ),
                     ),

                   ),
                 ],
               ),
             ),
              SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryVeryLighter,
              ),
              child: Column(
              children: [
                Text(
                  'Effects on the Environment',
                  style: AppTextStyles.heading(color: AppColors.textColorLight),
                ),
                SizedBox(height: 16),
                Text(
                  '1. Global Warming: Carbon emissions trap heat in the Earth\'s atmosphere, leading to an increase in global temperatures.',
                  style: AppTextStyles.subtitle(color: AppColors.textColorLight),
                ),
                Text(
                  '2. Climate Change: Changes in climate patterns, extreme weather events, and disruptions to ecosystems are consequences of carbon emissions.',
                  style: AppTextStyles.subtitle(color: AppColors.textColorLight),
                ),
                Text(
                  '3. Air Quality: High levels of carbon emissions contribute to poor air quality, affecting human health and the environment.',
                  style: AppTextStyles.subtitle(color: AppColors.textColorLight),
                ),
              ],
            ),)
              // Add more information as needed
            ],
          ),
        ),
      )
    );
  }
}
