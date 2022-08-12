import 'dart:developer';

import 'package:app_get_cep/model/address.dart';
import 'package:app_get_cep/view_model/via_cep_service.dart';
import 'package:flutter/material.dart';

class AddressManager extends ChangeNotifier {
  Address? address;

  Future<void> getAddress(String cep) async {
    final ViaCepService viaCepAddress = ViaCepService();

    try {
      final addressViaCep = await viaCepAddress.getAddressFromCEP(cep);
      if (addressViaCep != null) {
        address = Address(
          street: addressViaCep.logradouro,
          district: addressViaCep.bairro,
          zipCode: addressViaCep.cep,
          city: addressViaCep.localidade,
          state: addressViaCep.uf,
        );
        notifyListeners();
      }
    } catch (e) {
      rethrow;
    }
  }
}
