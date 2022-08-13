import 'package:app_get_cep/model/address_manager.dart';
import 'package:app_get_cep/model/db_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoadDatas extends StatefulWidget {
  const LoadDatas({Key? key}) : super(key: key);

  @override
  State<LoadDatas> createState() => _LoadDatasState();
}

class _LoadDatasState extends State<LoadDatas> {
  @override
  Widget build(BuildContext context) {
    print('entrou no load');
    DbUtil dbUtil = DbUtil();
    final loaf =
        Provider.of<AddressManager>(context, listen: false).loadPlaces();
    print('looad retonnado provider $loaf');

    return FutureBuilder(
      future: loaf,
      builder: (ctx, snapshot) => snapshot.connectionState ==
              ConnectionState.waiting
          ? Text('nao retornou')
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
                        itemBuilder: (ctx, i) => ListTile(
                          title: Text(greatPlaces.getItemByIndex(i).zipCode!),
                          subtitle: Text(
                              '${greatPlaces.getItemByIndex(i).street} '
                              '- ${greatPlaces.getItemByIndex(i).complement} '
                              '- ${greatPlaces.getItemByIndex(i).city} '
                              '- CEP ${greatPlaces.getItemByIndex(i).zipCode}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              setState(() {
                                dbUtil.deletePlace(int.parse(
                                    greatPlaces.getItemByIndex(i).id!));
                              });
                            },
                          ),
                        ),
                      ),
              ),
            ),
    );
  }
}
