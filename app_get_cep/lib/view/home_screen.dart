import 'package:app_get_cep/view/cep_input_field.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(32),
      child: Form(
        child: Column(
          children: [
            CepInputField(),
          ],
        ),
      ),
    ));
  }
}
