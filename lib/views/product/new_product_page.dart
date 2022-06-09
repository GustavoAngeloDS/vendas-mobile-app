import 'package:flutter/material.dart';
import 'package:vendas_flutter/models/product.model.dart';
import 'package:vendas_flutter/routes/routes.dart';
import 'package:vendas_flutter/utils/error_handler.dart';

import 'package:vendas_flutter/repository/product.repository.dart';

class NewProductPage extends StatefulWidget {
  const NewProductPage({Key? key}) : super(key: key);
  static const String routeName = "/new-product";

  @override
  State<StatefulWidget> createState() => _NewProductPageState();
}

class _NewProductPageState extends State<NewProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();

  ProductRepository repository = ProductRepository();

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<Product?> _saveProduct() async {
    Product? newProduct;
    try {
      newProduct =
          await repository.save(Product.create(_descriptionController.text));

      _descriptionController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Produto salvo com sucesso")));
    } catch (exception) {
      ErrorHandler()
          .showError(context, "Erro ao salvar produto", exception.toString());
    }

    return newProduct;
  }

  Widget _buildForm(BuildContext context) {
    return Column(
      children: [
        Form(
            key: _formKey,
            child: ListView(shrinkWrap: true, children: [
              Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                const Text("Descrição: "),
                Expanded(
                    child: TextFormField(
                  controller: _descriptionController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Campo não pode ser vazio";
                    }
                    return null;
                  },
                ))
              ]),
              Row(children: [
                ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        Product? product = await _saveProduct();
                        if (product != null) {
                          Navigator.pushNamed(context, Routes.listProducts);
                        }
                      }
                    },
                    child: const Text("Salvar")),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancelar'),
                ),
              ])
            ]))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Cadastrar novo produto"),
        ),
        body: _buildForm(context));
  }
}
