import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:vendas_flutter/models/client.model.dart';
import 'package:vendas_flutter/models/order.model.dart';
import 'package:vendas_flutter/rest/api.dart';

class OrderRest {
  // Future<Order> findById(int id) async {
  //   final http.Response response =
  //       await http.get(Uri.http(API.endpoint, "/orders/$id"));
  //   if (response.statusCode == 200) {
  //     return Order.fromJson(response.body);
  //   } else {
  //     throw Exception(
  //         'Erro ao buscar pedido $id. Erro: [${response.statusCode}]');
  //   }
  // }

  Future<List<Order>> findAll() async {
    final http.Response response =
        await http.get(Uri.http(API.endpoint, "/orders"));
    if (response.statusCode == 200) {
      return Order.fromJsonList(response.body);
    } else {
      throw Exception(
          'Erro ao buscar todos os pedidos. Erro: [${response.statusCode}]');
    }
  }

  Future<List<Client>> findClientByText(String text) async {
    final http.Response response =
        await http.get(Uri.http(API.endpoint, "/clients/search/$text"));
    if (response.statusCode == 200) {
      return Client.fromJsonList(response.body);
    } else {
      throw Exception('Erro ao buscar cliente. Erro: [${response.statusCode}]');
    }
  }

  Future<List<Order>> findByCpf(String cpf) async {
    final http.Response response =
        await http.get(Uri.http(API.endpoint, "/orders/cpf/$cpf"));
    if (response.statusCode == 200) {
      return Order.fromJsonList(response.body);
    } else {
      throw Exception('Erro ao buscar pedidos. Erro: [${response.statusCode}]');
    }
  }

  // Future<Order> save(Order order) async {
  //   final http.Response response = await http.post(
  //       Uri.http(API.endpoint, "/orders"),
  //       headers: <String, String>{
  //         "Content-Type": "application/json; charset=UTF-8"
  //       },
  //       body: order.newOrderToJson());

  //   if (response.statusCode == 200) {
  //     return Order.fromJson(response.body);
  //   } else {
  //     throw Exception('Erro ao criar pedido. Erro: [${response.statusCode}]');
  //   }
  // }

  // Future<Order> update(Order order) async {
  //   final http.Response response = await http.put(
  //       Uri.http(API.endpoint, "/orders"),
  //       headers: <String, String>{
  //         "Content-Type": "application/json; charset=UTF-8"
  //       },
  //       body: order.fullOrderToJson());

  //   if (response.statusCode == 200) {
  //     return order;
  //   } else {
  //     throw Exception(
  //         'Erro ao alterar pedido ${order.id}. Erro: [${response.statusCode}]');
  //   }
  // }

  // Future<Order> remove(Order order) async {
  //   final http.Response response = await http.delete(
  //       Uri.http(API.endpoint, "/orders"),
  //       headers: <String, String>{
  //         "Content-Type": "application/json; charset=UTF-8"
  //       },
  //       body: order.fullOrderToJson());

  //   if (response.statusCode != 200) {
  //     throw Exception(
  //         'Falha ao remover pedido ${order.id}. Erro: [${response.statusCode}]');
  //   }
  //   return order;
  // }
}
