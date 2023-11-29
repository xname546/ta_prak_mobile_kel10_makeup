import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ta_prak_mobile_final/Model/account_model.dart';
import 'package:ta_prak_mobile_final/Model/cosmetic_model.dart';
import 'package:ta_prak_mobile_final/login_page.dart';


void main() async {
    await Hive.initFlutter();
    Hive.registerAdapter(CosmeticModelAdapter());
    // Buka kotak Hive yang sesuai dengan model data
    Hive.registerAdapter(AccountModelAdapter()); // Mendaftarkan adaptor
    await Hive.openBox<AccountModel>('accounts');
    await Hive.openBox<CosmeticModel>('cosmeticBox');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: LoginPage(),
      ),
    );
  }
}


