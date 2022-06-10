import 'package:vendas_flutter/models/client.model.dart';
import 'package:vendas_flutter/models/order.model.dart';
import 'package:vendas_flutter/rest/order_rest.dart';

class OrderRepository {
  final OrderRest restInterface = OrderRest();

  // Future<Order> findById(int id) async {
  //   return await restInterface.findById(id);
  // }

  Future<List<Order>> findAll() async {
    return await restInterface.findAll();
  }

  Future<List<Order>> findByCpf(String cpf) async {
    return await restInterface.findByCpf(cpf);
  }

  Future<List<Client>> findClientByText(String text) async {
    return await restInterface.findClientByText(text);
  }

  Future<Order> save(Order order) async {
    return await restInterface.save(order);
  }

  // Future<Order> update(Order order) async {
  //   return await restInterface.update(order);
  // }
}
