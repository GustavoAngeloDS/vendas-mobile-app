import 'package:flutter/material.dart';
import 'package:vendas_flutter/models/client.model.dart';
import 'package:vendas_flutter/repository/client.repository.dart';
import 'package:vendas_flutter/routes/routes.dart';
import 'package:vendas_flutter/utils/error_handler.dart';
import 'package:vendas_flutter/views/client/update_client_page.dart';
import 'package:vendas_flutter/widgets/drawer.dart';

class ListClientPage extends StatefulWidget {
  const ListClientPage({Key? key}) : super(key: key);
  static const String routeName = "/list-clients";

  @override
  State<StatefulWidget> createState() => _ListClientPage();
}

class _ListClientPage extends State<ListClientPage> {
  List<Client> _clientList = [];
  ClientRepository repository = ClientRepository();

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
    List<Client> list = await _findAll();
    setState(() {
      _clientList = list;
    });
  }

  Future<List<Client>> _findAll() async {
    List<Client> clientList = <Client>[];
    try {
      clientList = await repository.findAll();
    } catch (exception) {
      ErrorHandler()
          .showError(context, "Erro ao listar os clientes.", exception.toString());
    }
    return clientList;
  }

  Future<Client> _removeClient(Client client) async {
    try {
      await repository.remove(client);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cliente removido com sucesso!')));
    } catch (exception) {
      ErrorHandler()
          .showError(context, "Erro ao remover o cliente.", exception.toString());
    }
    return client;
  }

  void _showClient(BuildContext context, int index) {
    Client client = _clientList[index];
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(client.name),
              content: Column(
                children: [
                  Text("Id: ${client.id}"),
                  Text("CPF: ${client.cpf}"),
                  Text("Nome: ${client.name}"),
                  Text("Sobrenome: ${client.lastname}"),
                ],
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("Fechar"))
              ]);
        });
  }

  void _updateProdut(BuildContext context, int index) {
    Client client = _clientList[index];

    Navigator.pushNamed(context, UpdateClientPage.routeName,
        arguments: <String, int>{"id": client.id!});
  }

  void _removeItem(BuildContext context, int index) {
    Client client = _clientList[index];
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text("Remover o cliente"),
          content: Text("Remover o cliente ${client.name}?"),
          actions: [
            TextButton(
                onPressed: () => {Navigator.of(context).pop()},
                child: const Text("Não")),
            TextButton(
                onPressed: () async {
                  await _removeClient(client);
                  _refreshList();
                  Navigator.of(context).pop();
                },
                child: const Text("Sim"))
          ],
        ));
  }

  ListTile _buildItem(BuildContext context, int index) {
    Client client = _clientList[index];

    return ListTile(
        leading: const Icon(Icons.new_label_outlined),
        title: Text(client.name),
        onTap: () {
          _showClient(context, index);
        },
        trailing: PopupMenuButton(itemBuilder: (context) {
          return [
            const PopupMenuItem(value: "edit", child: Text("Editar")),
            const PopupMenuItem(value: "delete", child: Text("Remover")),
          ];
        }, onSelected: (String option) {
          option == "edit"
              ? _updateProdut(context, index)
              : _removeItem(context, index);
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Lista de clientes")),
        body: ListView.builder(
            itemCount: _clientList.length, itemBuilder: _buildItem),
        floatingActionButton: FloatingActionButton(
        onPressed: () {
        Navigator.pushNamed(context, Routes.newClient);
        },
        tooltip: "Adicionar cliente",
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
        ));
  }
}
