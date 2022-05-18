import 'package:flutter/material.dart';

class NewProductPage extends StatefulWidget {
  const NewProductPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _NewProductPageState();
}

class _NewProductPageState extends State<NewProductPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cadastrar novo produto"),
      ),
      body: Center(
          child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Row(
                    children: [
                      const Text("Descrição"),
                      Expanded(child: TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Campo não pode ser vazio";
                          }
                          return null;
                        },
                      )),
                    ],
                  ),
                  ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Salvando dados")));
                        }
                      },
                      child: const Text("Salvar")),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Retornar"))
                ],
              ))),
    );
  }
}
