import 'dart:math';

import 'package:app_get_cep/model/address.dart';
import 'package:app_get_cep/model/db_util.dart';
import 'package:app_get_cep/view_model/via_cep_service.dart';
import 'package:flutter/material.dart';

class AddressManager extends ChangeNotifier {
  Address? address;
  List<Address> _items = [];

  Future<void> getAddress(String cep) async {
    final ViaCepService viaCepAddress = ViaCepService();

    try {
      final addressViaCep = await viaCepAddress.getAddressFromCEP(cep);
      if (addressViaCep != null) {
        print('ENDERECO $address');
        address = Address(
          street: addressViaCep.logradouro,
          district: addressViaCep.bairro,
          complement: addressViaCep.complemento!.contains('-')
              ? addressViaCep.complemento
                  ?.substring(0, addressViaCep.complemento?.indexOf('-'))
              : addressViaCep.complemento,
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

  Future<void> loadPlaces() async {
    final dataList = await DbUtil.getData('places');
    _items = dataList
        .map(
          (item) => Address(
            id: item['id'],
            zipCode: item['titlecep'],
            street: item['address'],
            number: item['number'],
            complement: item['complement'],
            district: item['district'],
            city: item['city'],
            state: item['state'],
          ),
        )
        .toList();
    notifyListeners();
  }

  List<Address> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  Address getItemByIndex(int index) {
    return _items[index];
  }

  Future<void> addPlace(String? title, String? address, String? number,
      String? complement, String? district, String? city, String? state) async {
    final newPlace = Address(
      id: Random().nextInt(99999).toString(),
      zipCode: title,
      street: address,
      number: number,
      complement: complement,
      district: district,
      city: city,
      state: state,
    );

    _items.add(newPlace);
    DbUtil.insert('places', {
      'id': newPlace.id!,
      'titlecep': newPlace.zipCode ?? '',
      'address': newPlace.street ?? '',
      'number': newPlace.number ?? '',
      'complement': newPlace.complement ?? '',
      'district': newPlace.district ?? '',
      'city': newPlace.city ?? '',
      'state': newPlace.state ?? ''
    });
    notifyListeners();
  }
}
