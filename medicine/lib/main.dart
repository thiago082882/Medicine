import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medicine/constants.dart';
import 'package:medicine/pages/home_page.dart';
import 'package:sizer/sizer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        title: 'Control medication',
        //theme customization
        theme: ThemeData.dark().copyWith(
          primaryColor: kPrimaryColor,
          scaffoldBackgroundColor: kScaffoldColor,
          //appbar theme
          appBarTheme: AppBarTheme(
            toolbarHeight: 7.h,
            backgroundColor: kScaffoldColor,
            elevation: 0,
            iconTheme: IconThemeData(
              color: kSecondaryColor,
              size: 20.sp,
            ),
            titleTextStyle: GoogleFonts.mulish(
              color: kTextColor,
              fontWeight: FontWeight.w800,
              fontStyle: FontStyle.normal,
              fontSize: 18.sp,
            ),
            centerTitle: true,
        ),
          textTheme: TextTheme(
            headlineMedium:TextStyle(
              fontSize: 26.sp,
              color: kSecondaryColor,
              fontWeight: FontWeight.w500
            ) ,
            headlineLarge: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w800,
                color: kTextColor),
            bodyMedium: GoogleFonts.poppins(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: kTextColor,
            ),
            labelMedium: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
              color: kTextColor
            )
          ),
          inputDecorationTheme: const InputDecorationTheme(
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: kTextLightColor,
                width: 0.7
              )
            ) ,
           border: UnderlineInputBorder(
             borderSide: BorderSide(
               color: kTextLightColor,
             )
           ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: kPrimaryColor,

              )
            )
          ),
            timePickerTheme: TimePickerThemeData(
              backgroundColor: kScaffoldColor,
              hourMinuteColor: kTextColor,
              hourMinuteTextColor: kScaffoldColor,
              dayPeriodColor: kTextColor,
              dayPeriodTextColor: kScaffoldColor,
              dialBackgroundColor: kTextColor,
              dialHandColor: kPrimaryColor,
              dialTextColor: kScaffoldColor,
              entryModeIconColor: kOtherColor,
              dayPeriodTextStyle: GoogleFonts.aBeeZee(
                fontSize: 8.sp,
              ),
            ),
        ),
        home: const HomePage(),
      );
    });
  }
}
