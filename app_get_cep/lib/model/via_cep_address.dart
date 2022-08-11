class ViaCepAddress {
  double? altitude;
  String? cep;
  String? logradouro;
  String? bairro;
  String? localidade;
  String? uf;

  ViaCepAddress.fromMap(Map<String, dynamic>? map){
    altitude = map!['altitude'];
    cep = map['cep'];
    logradouro = map['logradouro'];
    bairro = map['bairro'];
    localidade = map['localidade'];
    uf = map['uf'];
  }

}