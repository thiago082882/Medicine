import 'dart:async';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:medicine/utils/constants.dart';


class SuccessScreen extends StatefulWidget {
  const SuccessScreen({Key? key}) : super(key: key);

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 2500), () {
      Navigator.popUntil(context, ModalRoute.withName('/'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Material(
      color: kDialogBackground,
      child: Center(
        child: FlareActor(
          'assets/animations/Success Check.flr',
          alignment: Alignment.center,
          fit: BoxFit.contain,
          animation: 'Untitled',
        ),
      ),
    );
  }
}
