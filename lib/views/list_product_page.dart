import 'package:flutter/material.dart';
import 'package:vendas_flutter/models/product.model.dart';
import 'package:vendas_flutter/repository/product.repository.dart';
import 'package:vendas_flutter/routes/routes.dart';
import 'package:vendas_flutter/utils/error_handler.dart';
import 'package:vendas_flutter/widgets/drawer.dart';

class ListProductPage extends StatefulWidget {
  const ListProductPage({Key? key}) : super(key: key);
  static const String routeName = "/list-products";

  @override
  State<StatefulWidget> createState() => _ListProductPage();
}

class _ListProductPage extends State<ListProductPage> {
  List<Product> _productList = [];
  ProductRepository repository = ProductRepository();

  @override
  void initState() {
    super.initState();
    _refreshList();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _refreshList() async {
    List<Product> tempList = await _findAll();
    setState(() {
      _productList = tempList;
    });
  }

  Future<List<Product>> _findAll() async {
    List<Product> productList = <Product>[];
    try {
      productList = await repository.findAll();
    } catch (exception) {
      ErrorHandler()
          .showError(context, "Erro ao listar produtos", exception.toString());
    }
    return productList;
  }

  Future<Product> _removeProduct(Product product) async {
    try {
      await repository.remove(product);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produto removido com suecsso')));
    } catch (exception) {
      ErrorHandler()
          .showError(context, "Erro ao remover produto", exception.toString());
    }
    return product;
  }

  void _showProduct(BuildContext context, int index) {
    Product product = _productList[index];
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(product.description),
              content: Column(
                children: [
                  Text("Id: ${product.id}"),
                  Text("Descrição: ${product.description}")
                ],
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("Fechar"))
              ]);
        });
  }

  void _updateProduct(BuildContext context, int index) {
    Product product = _productList[index];

    Navigator.pushNamed(context, Routes.updateProduct,
        arguments: <String, int>{"id": product.id!});
  }

  void _removeItem(BuildContext context, int index) {
    Product product = _productList[index];
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text("Remover produto"),
              content: Text("Remover o produto ${product.description}?"),
              actions: [
                TextButton(
                    onPressed: () => {Navigator.of(context).pop()},
                    child: const Text("Não")),
                TextButton(
                    onPressed: () async {
                      await _removeProduct(product);
                      _refreshList();
                      Navigator.of(context).pop();
                    },
                    child: const Text("Sim"))
              ],
            ));
  }

  ListTile _buildItem(BuildContext context, int index) {
    Product product = _productList[index];

    return ListTile(
        leading: const Icon(Icons.new_label_outlined),
        title: Text(product.description),
        onTap: () {
          _showProduct(context, index);
        },
        trailing: PopupMenuButton(itemBuilder: (context) {
          return [
            const PopupMenuItem(value: "edit", child: Text("Editar")),
            const PopupMenuItem(value: "delete", child: Text("Remover")),
          ];
        }, onSelected: (String option) {
          option == "edit"
              ? _updateProduct(context, index)
              : _removeItem(context, index);
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Produtos")),
        body: ListView.builder(
            itemCount: _productList.length, itemBuilder: _buildItem),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, Routes.newProduct);
          },
          tooltip: "Adicionar produto",
          backgroundColor: Colors.green,
          child: const Icon(Icons.add),
        ));
  }
}
