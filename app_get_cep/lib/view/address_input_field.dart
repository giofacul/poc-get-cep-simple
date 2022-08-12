import 'package:app_get_cep/model/address.dart';
import 'package:flutter/material.dart';

class AddressInputField extends StatelessWidget {
  final Address? address;

  const AddressInputField({Key? key, this.address}) : super(key: key);

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
          onSaved: (text) => address!.street = text,
        ),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: address?.number,
                decoration: const InputDecoration(
                    isDense: true, labelText: 'Número', hintText: '123'),
                // validator: emptyValidator,
                onSaved: (text) => address!.number = text,
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: TextFormField(
                initialValue: address?.complement,
                decoration: const InputDecoration(
                    isDense: true,
                    labelText: 'Complemento',
                    hintText: 'Opcional'),
                // validator: emptyValidator,
                onSaved: (text) => address!.complement = text,
              ),
            ),
          ],
        ),
        TextFormField(
          initialValue: address?.district,
          decoration: const InputDecoration(
              isDense: true, labelText: 'Bairro', hintText: 'Centro'),
          validator: emptyValidator,
          onSaved: (text) => address!.district = text,
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
                onSaved: (text) => address!.city = text,
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
                onSaved: (text) => address!.state = text,
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
            if (Form.of(context)!.validate()) {}
          },
          child: const Text(
            'SALVAR',
            style: TextStyle(color: Colors.white),
          ),
        )
      ],
    );
  }
}
