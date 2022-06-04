import 'package:flutter/material.dart';
import 'package:vendas_flutter/models/product.model.dart';
import 'package:vendas_flutter/routes/routes.dart';
import 'package:vendas_flutter/utils/error_handler.dart';
import 'package:vendas_flutter/widgets/drawer.dart';

import '../repository/product.repository.dart';

class UpdateProductPage extends StatefulWidget {
  static const String routeName = "/update-product";

  const UpdateProductPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _UpdateProductState();
}

class _UpdateProductState extends State<UpdateProductPage> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();

  ProductRepository repository = ProductRepository();

  int _id = 0;
  Product? _product;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _findProduct() async {
    try {
      _product = await repository.findById(_id);
      _descriptionController.text = _product!.description;
    } catch (exception) {
      ErrorHandler()
          .showError(context, "Erro ao abrir produto", exception.toString());
    }
  }

  Future<Product?> _saveProduct() async {
    _product!.description = _descriptionController.text;
    try {
      await repository.update(_product!);
    } catch (exception) {
      ErrorHandler().showError(
          context, "Erro ao salvar a edição do produto", exception.toString());
    }

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produto editado com sucesso')));
  }

  Widget _buildForm(BuildContext context) {
    return Column(
      children: [
        Form(
            key: _formKey,
            child: ListView(shrinkWrap: true, children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
                ],
              ),
              Row(children: [
                ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await _saveProduct();
                        Navigator.pushNamed(context, Routes.listProducts);
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
    final Map map = ModalRoute.of(context)!.settings.arguments as Map;
    _id = map["id"];
    _findProduct();

    return Scaffold(
        appBar: AppBar(
          title: const Text("Editar produto"),
        ),
        drawer: const AppDrawer(),
        body: _buildForm(context));
  }
}
