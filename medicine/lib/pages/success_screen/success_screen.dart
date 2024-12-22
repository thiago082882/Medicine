import 'dart:async';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';


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
    return const Material( // Remova o `const` aqui
      color: Colors.white,
      child: Center(
        child: FlareActor( // Ou RiveAnimation se usar o pacote Rive
          'assets/animations/Success Check.flr', // Certifique-se de que o caminho está correto
          alignment: Alignment.center,
          fit: BoxFit.contain,
          animation: 'Untitled', // Certifique-se de que esta animação existe
        ),
      ),
    );
  }
}
