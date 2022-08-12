import 'package:app_get_cep/model/address.dart';
import 'package:app_get_cep/model/address_manager.dart';
import 'package:app_get_cep/view/address_input_field.dart';
import 'package:app_get_cep/view_model/via_cep_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class CepInputField extends StatefulWidget {
  CepInputField({Key? key}) : super(key: key);

  @override
  State<CepInputField> createState() => _CepInputFieldState();
}

class _CepInputFieldState extends State<CepInputField> {
  final textEditingController = TextEditingController();

  String? eai = 'nada';

  @override
  Widget build(BuildContext context) {
    return Consumer<AddressManager>(
      builder: (_, addressManager, __) {
        final address = addressManager.address ?? Address();
        print('ADDRESSSSSSS $address');
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
              onPressed: () async {
                final ViaCepService viaCepAddress = ViaCepService();

                print('numero digitado cep ${textEditingController.text}');
                if (Form.of(context)!.validate()) {
                  context
                      .read<AddressManager>()
                      .getAddress(textEditingController.text)
                      .toString();

                  try {
                    final addressViaCep = await viaCepAddress
                        .getAddressFromCEP(textEditingController.text);
                    if (addressViaCep != null) {
                      setState(() {
                        eai = 'tudo';
                        print('CERTO $eai');
                      });
                    }
                  } catch (e) {
                    setState(() {
                      eai = 'quase';
                      print('CATCH $eai');
                    });
                    rethrow;
                  }
                }
              },
              child: const Text(
                'GET CEP',
                style: TextStyle(color: Colors.white),
              ),
            ),
            if (eai == 'tudo') AddressInputField(address: address),
            if (eai == 'quase')
              Text(
                  'Não conseguimos localizar seu endereço, verifique se as informações passadas estão corretas'),
            if (eai == 'nada')
              Image.network(
                  'https://store-images.s-microsoft.com/image/apps.6607.13510798887520085.'
                  '3b5999bd-0689-4a5d-b1fa-378e87bb83a5.ee076621-7430-46f1-a4ac-a0c442d69e58'),
          ],
        );
      },
    );
  }

  func(Address address) async {
    final ViaCepService viaCepAddress = ViaCepService();

    try {
      final addressViaCep =
          await viaCepAddress.getAddressFromCEP(address.zipCode!);
      if (addressViaCep != null) {
        AddressInputField(address: address);
      }
    } catch (e) {
      rethrow;
    }
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
