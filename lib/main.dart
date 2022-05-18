import 'package:flutter/material.dart';
import 'package:vendas_flutter/pages/main.menu.page.dart';
import 'package:vendas_flutter/pages/new.product.page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/main-menu',
      routes: {
        '/main-menu': (context) => const MainMenuPage(),
        '/new-product': (context) => const NewProductPage(),
  },
      home: const NewProductPage(),
    );
  }
}