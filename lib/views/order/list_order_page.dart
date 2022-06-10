import 'package:flutter/material.dart';
import 'package:vendas_flutter/models/client.model.dart';
import 'package:vendas_flutter/models/order.model.dart';
import 'package:vendas_flutter/repository/order.repository.dart';
import 'package:vendas_flutter/routes/routes.dart';
import 'package:vendas_flutter/utils/error_handler.dart';
import 'package:vendas_flutter/views/order/update_order_page.dart';
import 'package:vendas_flutter/widgets/drawer.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../models/order_item.model.dart';
import '../../utils/model_builder.dart';

class ListOrderPage extends StatefulWidget {
  const ListOrderPage({Key? key}) : super(key: key);
  static const String routeName = "/list-orders";

  @override
  State<StatefulWidget> createState() => _ListOrderPage();
}

class _ListOrderPage extends State<ListOrderPage> {
  List<Order> _orderList = [];
  OrderRepository repository = OrderRepository();

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
    List<Order> tempList = await _findAll();
    setState(() {
      _orderList = tempList;
    });
  }

  void _clientOrders(String cpf) async {
    List<Order> tempList = await _findByCpf(cpf);
    setState(() {
      _orderList = tempList;
    });
  }

  Future<List<Order>> _findAll() async {
    List<Order> orderList = <Order>[];
    try {
      orderList = await repository.findAll();
    } catch (exception) {
      ErrorHandler()
          .showError(context, "Erro ao listar pedidos", exception.toString());
    }
    return orderList;
  }

  Future<List<Order>> _findByCpf(String cpf) async {
    List<Order> orderList = <Order>[];
    try {
      orderList = await repository.findByCpf(cpf);
    } catch (exception) {
      ErrorHandler()
          .showError(context, "Erro ao listar pedidos", exception.toString());
    }
    return orderList;
  }

  Widget buildDataTable(Order order) {
    final columns = ["Id", "Nome", "Qtdade"];

    return Expanded(
      child: DataTable(
        columns: getColumns(columns),
        rows: getRows(order.items!),
      ),
    );
  }

  List<DataColumn> getColumns(List<String> columns) {
    return columns.map((column) {
      return DataColumn(
        label: Text(column),
      );
    }).toList();
  }

  List<DataRow> getRows(List<OrderItem> item) => item.map((OrderItem i) {
        final cells = [i.product.id, i.product.description, i.qtdade];
        return DataRow(
            cells: Utils.modelBuilder(cells, (index, cell) {
          return DataCell(
            Text('$cell'),
          );
        }));
      }).toList();

  void _showOrder(BuildContext context, int index) {
    Order order = _orderList[index];
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("Pedido #${order.id}"),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Cliente: ${order.client.name!}"),
                  Text("Data: ${order.date!}"),
                  buildDataTable(order),
                ],
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("Fechar"))
              ]);
        });
  }

  void _updateOrder(BuildContext context, int index) {
    Order order = _orderList[index];

    Navigator.pushNamed(context, UpdateOrderPage.routeName,
        arguments: <String, int>{"id": order.id!});
  }

  ListTile _buildItem(BuildContext context, int index) {
    Order order = _orderList[index];

    return ListTile(
        leading: const Icon(Icons.shopping_cart),
        title: Text(order.client.name),
        subtitle: Text(order.date?.toString() ?? ""),
        onTap: () {
          _showOrder(context, index);
        },
        trailing: PopupMenuButton(itemBuilder: (context) {
          return [
            const PopupMenuItem(value: "edit", child: Text("Editar")),
            // const PopupMenuItem(value: "delete", child: Text("Remover")),
          ];
        }, onSelected: (String option) {
          _updateOrder(context, index);
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            // elevation: 0,
            title: TypeAheadField<Client?>(
              textFieldConfiguration: const TextFieldConfiguration(
                decoration: InputDecoration(
                  labelText: "Buscar pedido",
                  suffixIcon: Icon(Icons.search_sharp),
                ),
              ),
              suggestionsCallback: ((pattern) async {
                if (pattern.isEmpty) {
                  return <Client>[];
                }
                return await repository.findClientByText(pattern);
              }),
              itemBuilder: (context, suggestion) {
                return ListTile(
                    title: Text(suggestion!.name),
                    subtitle: Text(suggestion.cpf));
              },
              onSuggestionSelected: (suggestion) {
                print(suggestion!.cpf);
                _clientOrders(suggestion.cpf);
              },
              noItemsFoundBuilder: (context) {
                return const Text("Nenhum pedido encontrado");
              },
            )),
        drawer: const AppDrawer(),
        body: ListView.builder(
            itemCount: _orderList.length, itemBuilder: _buildItem),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, Routes.newOrder);
          },
          tooltip: "Adicionar pedido",
          backgroundColor: Colors.green,
          child: const Icon(Icons.add),
        ));
  }
}
