import 'package:app_get_cep/model/address.dart';
import 'package:app_get_cep/model/address_manager.dart';
import 'package:app_get_cep/view/load_datas.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddressInputField extends StatelessWidget {
  final Address? address;
  AddressInputField({Key? key, this.address}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? emptyValidator(String? text) =>
        text!.isEmpty ? 'Campo Obrigatório' : null;

    return Column(
      children: [
        TextFormField(

          initialValue: address?.street,
          decoration: const InputDecoration(
              isDense: true,
              labelText: 'Rua/Avenida',
              hintText: 'Avenida Brasil'),
          validator: emptyValidator,
          onChanged: (text) => address!.street = text,
        ),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: address?.number,
                decoration: const InputDecoration(
                    isDense: true, labelText: 'Número', hintText: '123'),
                onChanged: (text) => address!.number = text,
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: TextFormField(
                initialValue: address!.complement,
                decoration: const InputDecoration(
                    isDense: true,
                    labelText: 'Complemento',
                    hintText: 'Opcional'),
                // validator: emptyValidator,
                onChanged: (text) => address!.complement = text,
              ),
            ),
          ],
        ),
        TextFormField(
          initialValue: address?.district,
          decoration: const InputDecoration(
              isDense: true, labelText: 'Bairro', hintText: 'Centro'),
          validator: emptyValidator,
          onChanged: (text) => address!.district = text,
        ),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: TextFormField(
                enabled: false,
                initialValue: address?.city,
                decoration: const InputDecoration(
                    isDense: true, labelText: 'Cidade', hintText: 'São Paulo'),
                validator: emptyValidator,
                onChanged: (text) => address!.city = text,
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              flex: 1,
              child: TextFormField(
                enabled: false,
                autocorrect: false,
                initialValue: address?.state,
                decoration: const InputDecoration(
                    isDense: true,
                    labelText: 'Estado',
                    hintText: 'SP',
                    counterText: ''),
                onChanged: (text) => address!.state = text,
                maxLength: 2,
                validator: (cep) {
                  if (cep!.isEmpty) {
                    return 'Campo obrigatório';
                  } else if (cep.length != 2) {
                    return 'Inválido';
                  } else
                    null;
                },
              ),
            ),
          ],
        ),
        ElevatedButton(
          onPressed: () {
            if (Form.of(context)!.validate()) {
              func(context);
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => LoadDatas()));
            }
          },
          child: const Text(
            'SALVAR',
            style: TextStyle(color: Colors.white),
          ),
        )
      ],
    );
  }

  func(BuildContext context) {
    context.read<AddressManager>().addPlace(
        address?.zipCode,
        address?.street,
        address?.number,
        address?.complement,
        address?.district,
        address?.city,
        address?.state);
  }
}
