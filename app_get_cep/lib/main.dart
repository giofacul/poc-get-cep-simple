import 'package:app_get_cep/view/address_input_field.dart';
import 'package:app_get_cep/view/cep_input_field.dart';
import 'package:app_get_cep/model/address_manager.dart';
import 'package:app_get_cep/view/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AddressManager(),
          lazy: false,
        ),
      ],
    child: MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:  HomeScreen()
      ),
    );
  }
}
