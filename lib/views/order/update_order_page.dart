import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:vendas_flutter/models/client.model.dart';
import 'package:vendas_flutter/models/order.model.dart';
import 'package:vendas_flutter/models/order_item.model.dart';
import 'package:vendas_flutter/models/product.model.dart';
import 'package:vendas_flutter/repository/client.repository.dart';
import 'package:vendas_flutter/repository/order.repository.dart';
import 'package:vendas_flutter/repository/product.repository.dart';
import 'package:vendas_flutter/routes/routes.dart';
import 'package:vendas_flutter/utils/error_handler.dart';
import 'package:vendas_flutter/utils/model_builder.dart';

import '../../widgets/text_dialog.dart';

class UpdateOrderPage extends StatefulWidget {
  const UpdateOrderPage({Key? key}) : super(key: key);
  static const String routeName = "/update-order";

  @override
  State<StatefulWidget> createState() => _UpdateOrderPageState();
}

class _UpdateOrderPageState extends State<UpdateOrderPage> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _nameController = TextEditingController();
  final _cpfController = TextEditingController();
  List<OrderItem> orderitemlist = [];
  late Client client;
  late int _id = 0;
  late Order _order;
  var counter = 0;

  void _addItem(OrderItem orderItem) async {
    setState(() {
      orderitemlist.add(orderItem);
    });
  }

  void _loadItems(List<OrderItem> orderItem) async {
    setState(() {
      orderitemlist.addAll(orderItem);
    });
  }

  void _editList(OrderItem orderItem, int quantity) async {
    setState(() {
      orderitemlist = orderitemlist.map((item) {
        final isEditedUser = item == orderItem;
        return isEditedUser ? item.copy(qtdade: quantity) : item;
      }).toList();
    });
  }

  ClientRepository repository = ClientRepository();
  ProductRepository productRepository = ProductRepository();
  OrderRepository orderRepository = OrderRepository();

  @override
  void dispose() {
    _dateController.dispose();
    _nameController.dispose();
    _cpfController.dispose();
    super.dispose();
  }

  void _findOrder() async {
    try {
      _order = await orderRepository.findById(_id);
      _nameController.text = _order.client!.name;
      _cpfController.text = _order.client.cpf;
      if (counter == 0) {
        counter++;
        _loadItems(_order.items!);
      }
    } catch (exception) {
      ErrorHandler()
          .showError(context, "Erro ao abrir o cliente.", exception.toString());
    }
  }

  Future<Order?> _saveOrder() async {
    Order? order;
    _order.items = orderitemlist;
    try {
      order = await orderRepository.update(_order!);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pedido editado com sucesso!')));
    } catch (exception) {
      ErrorHandler().showError(
          context, "Erro ao salvar a edição do pedido.", exception.toString());
    }
    return order;
  }

  Widget buildDataTable() {
    final columns = ["Id", "Nome", "Qtdade", "Deletar"];

    return Expanded(
      child: DataTable(
        columns: getColumns(columns),
        rows: getRows(orderitemlist),
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
        final cells = [
          i.product.id,
          i.product.description,
          i.qtdade,
          "Deletar"
        ];

        return DataRow(
            cells: Utils.modelBuilder(cells, (index, cell) {
          final showEditIcon = index == 2;
          if (index == 3) {
            return DataCell(
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    orderitemlist.remove(i);
                  });
                },
              ),
            );
          }
          return DataCell(
            Text('$cell'),
            showEditIcon: showEditIcon,
            onTap: () {
              if (index == 2) {
                editQuantity(i);
              }
            },
          );
        }));
      }).toList();

  Future editQuantity(OrderItem orderItem) async {
    final quantity = await showTextDialog(
      context,
      title: "Quantidade",
      value: orderItem.qtdade.toString(),
    );
    _editList(orderItem, int.parse(quantity));
  }

  Widget _buildTable(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TypeAheadField<Product?>(
          textFieldConfiguration: const TextFieldConfiguration(
            decoration: InputDecoration(
              labelText: "Buscar produto",
              suffixIcon: Icon(Icons.search_sharp),
            ),
          ),
          suggestionsCallback: (pattern) async {
            if (pattern.isEmpty) {
              return <Product>[];
            }
            return await productRepository.findProductByName(pattern);
          },
          itemBuilder: (context, suggestion) {
            return ListTile(
              leading: Icon(Icons.person),
              title: Text(suggestion!.description),
            );
          },
          onSuggestionSelected: (suggestion) {
            Product product = Product(suggestion?.id!, suggestion!.description);
            OrderItem orderItem = OrderItem(qtdade: 1, product: product);
            _addItem(orderItem);
          },
        ),
        buildDataTable(),
        ElevatedButton(
            style: const ButtonStyle(alignment: Alignment.center),
            onPressed: () async {
              if (orderitemlist.isNotEmpty) {
                final result = await _saveOrder();

                if (result != null) {
                  Navigator.pushNamed(context, Routes.listOrders);
                }
              }
            },
            child: const Text("Salvar")),
      ],
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            const Text("Nome"),
            TextFormField(
              controller: _nameController,
              readOnly: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Campo não pode ser vazio";
                }
                return null;
              },
            ),
            const Text("Cpf"),
            TextFormField(
              controller: _cpfController,
              readOnly: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Campo não pode ser vazio";
                }
                return null;
              },
            ),
            // ElevatedButton(
            //     onPressed: () async {
            //       if (_formKey.currentState!.validate()) {
            //         Client? client = await _saveProduct();
            //         if (client != null) {
            //           Navigator.pushNamed(context, Routes.listClients);
            //         }
            //       }
            //     },
            //     child: const Text("Salvar")),
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.pop(context);
            //   },
            //   child: const Text('Cancelar'),
            // ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    final Map map = ModalRoute.of(context)!.settings.arguments as Map;
    _id = map["id"];
    _findOrder();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: const Text("Novo Pedido"),
            bottom: const TabBar(
              tabs: [
                Tab(
                  text: "Cliente",
                ),
                Tab(
                  text: "Produtos",
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              _buildForm(context),
              _buildTable(context),
            ],
          )),
    );
  }
}
