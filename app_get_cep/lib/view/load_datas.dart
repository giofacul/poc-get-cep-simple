import 'package:app_get_cep/model/address_manager.dart';
import 'package:app_get_cep/model/db_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoadDatas extends StatefulWidget {
  const LoadDatas({Key? key}) : super(key: key);

  @override
  State<LoadDatas> createState() => _LoadDatasState();
}

//RETORNANDO TODA LISTA DE ITENS SALVOS NO SQFLITE
class _LoadDatasState extends State<LoadDatas> {
  int? numberGet;

  @override
  void initState() {
    func();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DbUtil dbUtil = DbUtil();
    final loaf =
        Provider.of<AddressManager>(context, listen: false).loadPlaces();

    return FutureBuilder(
        future: loaf,
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Container(
                color: Colors.white,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Scaffold(
                appBar: AppBar(
                  title: const Text('Meus Lugares'),
                ),
                body: Consumer<AddressManager>(
                  child: const Center(
                    child: Text('Nenhum local cadastrado!'),
                  ),
                  builder: (ctx, greatPlaces, ch) => greatPlaces.itemsCount == 0
                      ? ch!
                      : ListView.builder(
                          itemCount: greatPlaces.itemsCount,
                          itemBuilder: (ctx, i) {
                            final pathItem = greatPlaces.getItemByIndex(i);
                            return ListTile(
                              title: Text(pathItem.zipCode!),
                              subtitle: pathItem.complement!.isNotEmpty
                                  ? Text('${pathItem.street} '
                                      '- ${pathItem.complement} '
                                      '- ${pathItem.city} '
                              //TODO AQUI Q RETORNEI O NUMERO DO SHARED
                                      '- ${numberGet} '
                                      '- CEP ${pathItem.zipCode}')
                                  : Text('${pathItem.street} '
                                      '- ${pathItem.city} '
                                      '- ${numberGet} '
                                      '- CEP ${pathItem.zipCode}'),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  setState(() {
                                    dbUtil.deletePlace(int.parse(pathItem.id!));
                                  });
                                },
                              ),
                            );
                          }),
                )));
  }

  func() async {
    final prefs = await SharedPreferences.getInstance();
    var returnCounter = await prefs.getInt('counter');
    numberGet = returnCounter;
  }
}
