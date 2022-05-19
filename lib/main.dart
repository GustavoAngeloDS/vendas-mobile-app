import 'package:flutter/material.dart';
import 'package:vendas_flutter/routes/routes.dart';
import 'package:vendas_flutter/view/list_product_page.dart';
import 'package:vendas_flutter/view/new_product_page.dart';
import 'package:vendas_flutter/view/update_product.dart';
import 'package:vendas_flutter/widgets/drawer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "VenDAS",
      theme: ThemeData(
        primarySwatch: Colors.grey
      ),
      home: const MyHomePage(title: "VenDAS"),
      routes: {
        Routes.listProducts: (context) => const ListProductPage(),
        Routes.newProduct: (context) => const NewProductPage(),
        Routes.updateProduct: (context) => const UpdateProductPage(),
      }
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title)
      ),
      drawer: AppDrawer(),
    );
  }
}

/*
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp (
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //initialRoute: '/main-menu',
      routes: {
        '/main-menu': (context) => const MainMenuPage(),
        '/new-product': (context) => const NewProductPage(),
        '/list-products': (context) => const ListProductPage(),
      },
      home: const MeuDrawer());
  }
}

class MeuDrawer extends StatelessWidget {
    const MeuDrawer({Key? key}) : super(key: key);
    
      @override
      Widget build(BuildContext context) {
        return Scaffold(
        appBar: AppBar(
          title: const Text("Página inicial VenDAS"),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text('Menu principal'),
              ),
              ListTile(
                title: const Text("Cadastrar produto"),
                onTap: () {
                  Navigator.pushNamed(context, "/new-product");
                },
              ),
              ListTile(
                title: const Text("Visualizar produtos"),
                onTap: () {
                  Navigator.pushNamed(context, "/list-products");
                },
              ),
            ],
          ),
        ));
      }
      }*/
