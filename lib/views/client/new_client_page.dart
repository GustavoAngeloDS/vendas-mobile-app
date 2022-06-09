import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vendas_flutter/models/client.model.dart';
import 'package:vendas_flutter/repository/client.repository.dart';
import 'package:vendas_flutter/routes/routes.dart';
import 'package:vendas_flutter/utils/error_handler.dart';
import 'package:vendas_flutter/widgets/drawer.dart';

class NewClientPage extends StatefulWidget {
  const NewClientPage({Key? key}) : super(key: key);
  static const String routeName = "/new-client";

  @override
  State<StatefulWidget> createState() => _NewClientPageState();
}

class _NewClientPageState extends State<NewClientPage> {
  final _formKey = GlobalKey<FormState>();
  final _cpfController = TextEditingController();
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();

  ClientRepository repository = ClientRepository();

  @override
  void dispose() {
    _cpfController.dispose();
    _nameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  Future<Client?> _saveProduct() async {
    Client? newClient;
    try {
      newClient = await repository.save(Client.create(_cpfController.text, _nameController.text, _lastNameController.text));
      _cpfController.clear();
      _nameController.clear();
      _lastNameController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Cliente salvo com sucesso.")));

      return newClient;
    } catch(exception) {
      ErrorHandler().showError(context, "Erro ao salvar o cliente.", exception.toString());
      return null;
    }
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const Text("CPF"),
          TextFormField(
            controller: _cpfController,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              CpfInputFormatter(),
            ],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Campo não pode ser vazio";
              }
              return null;
            },
          ),
          const Text("Nome"),
          TextFormField(
            controller: _nameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Campo não pode ser vazio";
              }
              return null;
            },
          ),
          const Text("Sobrenome"),
          TextFormField(
            controller: _lastNameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Campo não pode ser vazio";
              }
              return null;
            },
          ),
          ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  Client? client = await _saveProduct();
                  if (client != null) {
                    Navigator.pushNamed(context, Routes.listClients);
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
        ],
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Cadastrar novo cliente"),
        ),
        body: _buildForm(context)
    );
  }
}
