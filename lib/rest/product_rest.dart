import 'package:http/http.dart' as http;
import 'package:vendas_flutter/rest/api.dart';

import '../models/product.model.dart';

class ProductRest {
  Future<Product> findById(int id) async {
    final http.Response response =
        await http.get(Uri.http(API.endpoint, "/products/$id"));
    if (response.statusCode == 200) {
      return Product.fromJson(response.body);
    } else {
      throw Exception(
          'Erro ao buscar produto $id. Erro: [${response.statusCode}]');
    }
  }

  Future<List<Product>> findAll() async {
    final http.Response response =
        await http.get(Uri.http(API.endpoint, "/products"));
    if (response.statusCode == 200) {
      return Product.fromJsonList(response.body);
    } else {
      throw Exception(
          'Erro ao buscar todos os produtos. Erro: [${response.statusCode}]');
    }
  }

  Future<Product> save(Product product) async {
    final http.Response response = await http.post(
        Uri.http(API.endpoint, "/products"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8"
        },
        body: product.newProductToJson());

    if (response.statusCode == 200) {
      return Product.fromJson(response.body);
    } else {
      throw Exception(
          'Erro ao inserir produto. Erro: [${response.statusCode}]');
    }
  }

  Future<Product> update(Product product) async {
    final http.Response response = await http.put(
        Uri.http(API.endpoint, "/products"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8"
        },
        body: product.fullProductToJson());

    if (response.statusCode == 200) {
      return product;
    } else {
      throw Exception(
          'Erro ao alterar produto ${product.id}. Erro: [${response.statusCode}]');
    }
  }

  Future<Product> remove(Product product) async {
    final http.Response response = await http.delete(
        Uri.http(API.endpoint, "/products"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8"
        },
        body: product.fullProductToJson());

    if (response.statusCode != 200) {
      throw Exception(
          'Falha ao remover produto ${product.id}. Erro: [${response.statusCode}]');
    }
    return product;
  }
}
