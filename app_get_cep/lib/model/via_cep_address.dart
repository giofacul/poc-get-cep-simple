class ViaCepAddress {
  double? altitude;
  String? cep;
  String? logradouro;
  String? bairro;
  String? localidade;
  String? complemento;
  String? uf;

  //PEGANDO OS DADOS DA API, ESPECIFICANDO CADA DADO DO MAP
  ViaCepAddress.fromMap(Map<String, dynamic>? map){
    altitude = map!['altitude'];
    cep = map['cep'];
    logradouro = map['logradouro'];
    bairro = map['bairro'];
    localidade = map['localidade'];
    complemento = map['complemento'];
    uf = map['uf'];
  }

}