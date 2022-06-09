import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vendas_flutter/models/client.model.dart';
import 'package:vendas_flutter/repository/client.repository.dart';
import 'package:vendas_flutter/routes/routes.dart';
import 'package:vendas_flutter/utils/error_handler.dart';
import 'package:vendas_flutter/widgets/drawer.dart';

class UpdateClientPage extends StatefulWidget {
  static const String routeName = "/update-client";

  const UpdateClientPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _UpdateClientState();
}

class _UpdateClientState extends State<UpdateClientPage> {
  final _formKey = GlobalKey<FormState>();
  final _cpfController = TextEditingController();
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();

  ClientRepository repository = ClientRepository();

  int _id = 0;
  Client? _client;

  @override
  void dispose() {
    _cpfController.dispose();
    _nameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  void _findClient() async {
    try {
      _client = await repository.findById(_id);
      _cpfController.text = _client!.cpf;
      _nameController.text = _client!.name;
      _lastNameController.text = _client!.lastname;
    } catch (exception) {
      ErrorHandler()
          .showError(context, "Erro ao abrir o cliente.", exception.toString());
    }
  }

  Future<Client?> _saveClient() async {
    Client? client;
    _client!.cpf = _cpfController.text;
    _client!.name = _nameController.text;
    _client!.lastname = _lastNameController.text;

    try {
      client = await repository.update(_client!);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cliente editado com sucesso!')));
    } catch (exception) {
      ErrorHandler().showError(
          context, "Erro ao salvar a edição do cliente.", exception.toString());
    }
    return client;
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
                    Client? client = await _saveClient();
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
        ));
  }

  @override
  Widget build(BuildContext context) {
    final Map map = ModalRoute.of(context)!.settings.arguments as Map;
    _id = map["id"];
    _findClient();

    return Scaffold(
        appBar: AppBar(
          title: const Text("Editar cliente"),
        ),
        body: _buildForm(context));
  }
}
