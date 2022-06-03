import 'package:flutter/material.dart';
import 'package:vendas_flutter/routes/routes.dart';

import 'package:vendas_flutter/views/product_page.dart';
import 'package:vendas_flutter/views/new_product_page.dart';
import 'package:vendas_flutter/views/update_product.dart';

// import 'package:vendas_flutter/views/ClientPage.dart';
// import 'package:vendas_flutter/views/OrderPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "VenDAS",
        theme: ThemeData(primarySwatch: Colors.grey),
        home: const MyHomePage(title: "VenDAS"),
        routes: {
          Routes.listProducts: (context) => const ProductPage(),
          Routes.newProduct: (context) => const NewProductPage(),
          Routes.updateProduct: (context) => const UpdateProductPage(),
        });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    // ClientPage(),
    const ProductPage(),
    const ProductPage(),
    const ProductPage(),
    //OrderPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Clientes',
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.storefront),
            label: 'Produtos',
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_basket),
            label: 'Pedidos',
            backgroundColor: Colors.red,
          ),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
