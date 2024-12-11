import 'package:flutter/material.dart';
import 'package:medicine/constants.dart';
import 'package:medicine/main.dart';
import 'package:medicine/pages/new_entry/new_entry_page.dart';
import 'package:sizer/sizer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(2.h),
        child: Column(
          children: [
            const TopContainer(),
            SizedBox(
              height: 2.h,
            ),
            //the widget take space as per need
            Flexible(child: BottomContainer()),
          ],
        ),
      ),
      floatingActionButton: InkResponse(
        onTap: () {
          //go to new entry page
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const NewEntryPage(),
              ),
          );
        },
        child: SizedBox(
          width: 20.w,
          height: 10.h,
          child: Card(
            color: kPrimaryColor,
            shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.circular(3.h)),
            child: Icon(
              Icons.add_outlined,
              color: kScaffoldColor,
              size: 35.sp,
            ),
          ),
        ),
      ),
    );
  }
}

class TopContainer extends StatelessWidget {
  const TopContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.only(
            bottom: 1.h,
          ),
          child: Text("Worry less.\nLive healthier.",
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.headlineLarge),
        ),
        Container(
          alignment: Alignment.topLeft,
          padding: EdgeInsets.only(bottom: 1.h),
          child: Text(
            "Welcome to Daily Dose",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        SizedBox(
          height: 2.h,
        ),
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(bottom: 1.h),
          child: Text(
            '0',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
        )
      ],
    );
  }
}

class BottomContainer extends StatelessWidget {
  const BottomContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "No Medicine",
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}
