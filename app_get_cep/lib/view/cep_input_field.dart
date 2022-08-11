import 'package:app_get_cep/model/address_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class CepInputField extends StatelessWidget {
  CepInputField({Key? key}) : super(key: key);
  final textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // return Consumer<AddressManager>(
    //   builder: (_, addressManager, __) {
    //     final address = addressManager.address;
    //     print('ADDRESS $address');
    return Column(
      children: [
        TextFormField(
          controller: textEditingController,
          maxLength: 8,
          decoration: const InputDecoration(
            isDense: true,
            labelText: 'CEP',
            hintText: '12345-789',
          ),
          inputFormatters: [MyFilter()],
          keyboardType: TextInputType.number,
          validator: (cep) {
            if (cep!.isEmpty) {
              return 'Campo obrigatório';
            } else if (cep.length != 8) {
              return 'CEP inválido';
            } else
              null;
          },
        ),
        ElevatedButton(
          onPressed: () {
            if (Form.of(context)!.validate()) {
              context
                  .read<AddressManager>()
                  .getAddress(textEditingController.text)
                  .toString();
            }
          },
          child: const Text(
            'GET CEP',
            style: TextStyle(color: Colors.white),
          ),
        )
      ],
    );
  }
}

class MyFilter extends TextInputFormatter {
  static final _reg = RegExp(r'^\d+$');

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return _reg.hasMatch(newValue.text) ? newValue : oldValue;
  }
}
