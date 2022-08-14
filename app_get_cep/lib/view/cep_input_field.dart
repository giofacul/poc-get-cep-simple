import 'package:app_get_cep/model/address.dart';
import 'package:app_get_cep/model/address_manager.dart';
import 'package:app_get_cep/view/address_input_field.dart';
import 'package:app_get_cep/view_model/via_cep_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

class CepInputField extends StatefulWidget {
  CepInputField({Key? key}) : super(key: key);

  @override
  State<CepInputField> createState() => _CepInputFieldState();
}

//TELA DE TODOS OS CAMPOS
class _CepInputFieldState extends State<CepInputField> {
  final textEditingController = TextEditingController();
  var maskFormatter = MaskTextInputFormatter(
      mask: '#####-####', filter: {"#": RegExp(r'[0-9]')});

  //TEXTOS FIXOS
  String? validateReturnField = 'none';
  final returnedInvalidData = 'none';
  final returnedValidData = 'returnedOk';
  final returnedNoValidData = 'noReturnedValid';
  final returnedDifferentData = 'differentData';

  @override
  Widget build(BuildContext context) {
    return Consumer<AddressManager>(
      builder: (_, addressManager, __) {
        final address = addressManager.address ?? Address();
        return Column(
          children: [
            TextFormField(
              controller: textEditingController,
              maxLength: 9,
              decoration: const InputDecoration(
                  isDense: true,
                  labelText: 'CEP',
                  hintText: '12345-789',
                  counterText: ''),
              inputFormatters: [maskFormatter],
              keyboardType: TextInputType.number,
              validator: (cep) {
                if (cep!.isEmpty) {
                  return 'Campo obrigatório';
                } else if (cep.length != 9) {
                  return 'CEP inválido';
                } else
                  null;
              },
            ),
            ElevatedButton(
              onPressed: () async {
                //BUSCA A CLASSE VIACEP (AQUI VC TEM Q ENTRA NA CLASSE VIA CEP SERVICE E CRIAR ELA)
                final ViaCepService viaCepAddress = ViaCepService();

                //VALUDA O FORMULARIO
                if (Form.of(context)!.validate()) {
                  //MUDA O TEXTO FIXO DO RETORNO PARA O CONTAINER, QUE SÓ TRANSITA OS RETORNOS
                  validateReturnField = returnedDifferentData;
                  //ENVIA PRA FUNCAO GETADDRESS O TEXTO Q FOI DIFITADO NO INPUT
                  context
                      .read<AddressManager>()
                      .getAddress(textEditingController.text)
                      .toString();

                  try {
                    //VERIFICA SE O TEXTE TEM UM ENDERECO RETORNADO
                    final addressViaCep = await viaCepAddress
                        .getAddressFromCEP(textEditingController.text);
                    if (addressViaCep != null) {
                      //ATUALIZA QUE O DADO RETORNADO DEU CERTO
                      setState(() {
                        validateReturnField = returnedValidData;
                      });
                    }
                    //AQUI É CASO ALGO DE ERRADO/N ENCONTRE UM CEP, OU INVALIDO
                  } catch (e) {
                    //ATUALIZA Q O CEP DEU ERRADO
                    setState(() {
                      validateReturnField = returnedNoValidData;
                    });
                    rethrow;
                  }
                }
              },
              //É O TEXTO DO BOAO
              child: const Text(
                'GET CEP',
                style: TextStyle(color: Colors.white),
              ),
            ),

            //TODO ESSE ANTES
            //ESSA ABRE O COLUMN COM O CEP / RETORNO CERTO
            if (validateReturnField == returnedValidData)
              AddressInputField(
                address: address,
              ),
            //ESSA ABRE O TEXTO QUE N ENCONTROU O CEP / RETORNO ERRADO
            if (validateReturnField == returnedNoValidData)
              const Text(
                  'Não conseguimos localizar seu endereço, verifique se as informações passadas estão corretas'),
            //ABRE SÓ A PRIMMEIRA VEZ, IMAGEM
            if (validateReturnField == returnedInvalidData)
              Image.network(
                  'https://store-images.s-microsoft.com/image/apps.6607.13510798887520085.'
                  '3b5999bd-0689-4a5d-b1fa-378e87bb83a5.ee076621-7430-46f1-a4ac-a0c442d69e58'),
            //ESSE N ABRE, SÓ TRANSITA ENTRE AS TELAS QUE VAO ABRIR
            if (validateReturnField == returnedDifferentData) Container(),
          ],
        );
      },
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
