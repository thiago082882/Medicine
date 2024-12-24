import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:medicine/constants.dart';
import 'package:medicine/global_bloc.dart';
import 'package:medicine/pages/home_page.dart';
import 'package:medicine/pages/new_entry/new_entry_bloc.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  GlobalBloc? globalBloc;

  @override
  void initState() {
    globalBloc = GlobalBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Provider<GlobalBloc>.value(
      value: globalBloc!,
      child: Sizer(builder: (context, orientation, deviceType) {
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
            ),
              titleLarge: TextStyle(
              fontSize: 19.sp,
              fontWeight: FontWeight.w400,
              color: kTextColor
            ),
              headlineSmall: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w400,
              color: kSecondaryColor,
            ),
              titleMedium: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.w400,
              color: kSecondaryColor,
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
        debugShowCheckedModeBanner: false,
        home: const HomePage(),
      );
    }
    ),

    );
  }
}
