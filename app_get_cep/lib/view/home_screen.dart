import 'package:app_get_cep/model/address.dart';
import 'package:app_get_cep/model/address_manager.dart';
import 'package:app_get_cep/view/address_input_field.dart';
import 'package:app_get_cep/view/cep_input_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AddressManager>(builder: (_, addressManager, __) {
      final address = addressManager.address ?? Address();
      return Scaffold(
          body: Padding(
        padding: const EdgeInsets.all(32),
        child: Form(
          child: Column(
            children: [
              CepInputField(),
              if(address.zipCode != null)
                AddressInputField(address: address),
            ],
          ),
        ),
      ));
    });
  }
}
