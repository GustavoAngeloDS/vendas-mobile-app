import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:vendas_flutter/models/client.model.dart';
import 'package:vendas_flutter/models/order_item.model.dart';
import 'package:vendas_flutter/models/product.model.dart';
import 'package:vendas_flutter/repository/client.repository.dart';
import 'package:vendas_flutter/repository/product.repository.dart';
import 'package:vendas_flutter/routes/routes.dart';
import 'package:vendas_flutter/utils/error_handler.dart';
import 'package:editable/editable.dart';

class NewOrderPage extends StatefulWidget {
  const NewOrderPage({Key? key}) : super(key: key);
  static const String routeName = "/new-order";

  @override
  State<StatefulWidget> createState() => _NewOrderPageState();
}

class _NewOrderPageState extends State<NewOrderPage> {
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _nameController = TextEditingController();
  final _cpfController = TextEditingController();
  final _editableKey = GlobalKey<EditableState>();
  List rows = [
    {
      "id": 1,
      "description": 'Lapis',
      "qtdade": 1,
    },
    {
      "id": 2,
      "description": 'Caneta',
      "qtdade": 2,
    },
    {
      "id": 3,
      "description": 'Caderno',
      "qtdade": 3,
    }
  ];
  List cols = [
    {"title": 'id', 'widthFactor': 0.1, 'key': 'id', 'editable': false},
    {
      "title": 'Nome',
      'widthFactor': 0.5,
      'key': 'description',
      'editable': false
    },
    {"title": 'Qtdade', 'widthFactor': 0.2, 'key': 'qtdade'},
  ];
  Product p1 = Product(1, "Lapis");
  Product p2 = Product(2, "Caneta");
  Product p3 = Product(3, "Caderno");
  OrderItem oi = OrderItem(product: Product(1, "Lapis"), qtdade: 1);

  List<Product> _productList = [];

  ClientRepository repository = ClientRepository();
  ProductRepository productRepository = ProductRepository();

  final columns = [
    const DataColumn(
      label: Text('ID'),
    ),
    const DataColumn(
      label: Text('Nome'),
    ),
    const DataColumn(
      label: Text('Qtdade'),
    ),
  ];

  @override
  void dispose() {
    _dateController.dispose();
    _nameController.dispose();
    _cpfController.dispose();
    super.dispose();
  }

  Future<Client?> _saveProduct() async {
    Client? newClient;
    try {
      newClient = await repository.save(Client.create(
          _dateController.text, _nameController.text, _cpfController.text));
      _dateController.clear();
      _nameController.clear();
      _cpfController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Cliente salvo com sucesso.")));

      return newClient;
    } catch (exception) {
      ErrorHandler().showError(
          context, "Erro ao salvar o cliente.", exception.toString());
      return null;
    }
  }

  Widget _buildTable(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(
          child: TypeAheadField<Product?>(
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
              Product product =
                  Product(suggestion?.id!, suggestion!.description);
              print(product.id);
            },
          ),
        ),
        // Expanded(
        // child: DataTable(
        //   columns: columns,
        // ),
        // ),
        ElevatedButton(
            style: ButtonStyle(alignment: Alignment.center),
            onPressed: () async {
              print("salvando $rows");
              // if (_formKey.currentState!.validate()) {
              //   Client? client = await _saveProduct();
              //   if (client != null) {
              //     Navigator.pushNamed(context, Routes.listClients);
              //   }
              // }
            },
            child: const Text("Salvar")),

        // ElevatedButton(
        //     style: ButtonStyle(alignment: Alignment.bottomLeft),
        //     onPressed: () async {
        //       if (_formKey.currentState!.validate()) {
        //         Client? client = await _saveProduct();
        //         if (client != null) {
        //           Navigator.pushNamed(context, Routes.listClients);
        //         }
        //       }
        //     },
        //     child: const Text("Salvar")),
      ],
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            TypeAheadField<Client?>(
              textFieldConfiguration: const TextFieldConfiguration(
                decoration: InputDecoration(
                  labelText: "Buscar cliente",
                  suffixIcon: Icon(Icons.search_sharp),
                ),
              ),
              suggestionsCallback: (pattern) async {
                if (pattern.isEmpty) {
                  return <Client>[];
                }
                return await repository.findClientByText(pattern);
              },
              itemBuilder: (context, suggestion) {
                return ListTile(
                  leading: Icon(Icons.person),
                  title: Text(suggestion!.name),
                  subtitle: Text('\$${suggestion.cpf}'),
                );
              },
              onSuggestionSelected: (suggestion) {
                Client client = Client(suggestion?.id!, suggestion!.name,
                    suggestion.cpf, suggestion.lastname);

                _nameController.text = suggestion!.name;
                _cpfController.text = suggestion.cpf;

                print(client.id.toString());
              },
            ),
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
                Product product =
                    Product(suggestion?.id!, suggestion!.description);
                print(product.id);
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
