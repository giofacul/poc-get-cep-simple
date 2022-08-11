import 'package:app_get_cep/model/via_cep_address.dart';
import 'package:dio/dio.dart';

class ViaCepService {
  Future<ViaCepAddress> getAddressFromCEP(String cep) async {
    final cleanCep = cep.replaceAll('.', '').replaceAll('-', '');
    final endPoint = 'https://viacep.com.br/ws/$cleanCep/json/';

    print('ENDPOINT $endPoint');

    final Dio dio = Dio();

    var response = await dio.get(endPoint);

    try {
      if (response.data?.isEmpty ?? true) {
        print('CEP RETORNADO INVÁLIDO = ${response.data}');
        return Future.error('CEP INVÁLIDO');
      }
      print('CEP RETORNADO CERTO = ${response.data}');
      final ViaCepAddress address = ViaCepAddress.fromMap(response.data);
      return address;
    } on DioError catch (e) {
      print('CEP RETORNADO ERRADO = ${response.data}');
      return Future.error('ERRO AO BUSCAR CEP');
    }
  }
}
