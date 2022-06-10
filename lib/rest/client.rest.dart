import 'package:http/http.dart' as http;
import 'package:vendas_flutter/ErrorDTO/error.dto.dart';
import 'package:vendas_flutter/models/client.model.dart';
import 'package:vendas_flutter/rest/api.dart';

class ClientRest {
  Future<List<Client>> findClientByText(String text) async {
    final http.Response response =
        await http.get(Uri.http(API.endpoint, "/clients/search/$text"));
    if (response.statusCode == 200) {
      return Client.fromJsonList(response.body);
    } else {
      throw Exception('Erro ao buscar cliente. Erro: [${response.statusCode}]');
    }
  }

  Future<Client> findById(int id) async {
    final http.Response response =
        await http.get(Uri.http(API.endpoint, "/clients/$id"));
    if (response.statusCode == 200) {
      return Client.fromJson(response.body);
    } else {
      throw Exception(
          'Erro ao buscar o cliente $id. Motivo: ${ErrorDTO.fromJson(response.body).message}');
    }
  }

  Future<List<Client>> findAll() async {
    final http.Response response =
        await http.get(Uri.http(API.endpoint, "/clients"));
    if (response.statusCode == 200) {
      return Client.fromJsonList(response.body);
    } else {
      throw Exception(
          'Erro ao buscar todos os clientes. Motivo: ${ErrorDTO.fromJson(response.body).message}');
    }
  }

  Future<Client> save(Client client) async {
    final http.Response response = await http.post(
        Uri.http(API.endpoint, "/clients"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8"
        },
        body: client.newClientToJson());

    if (response.statusCode == 200) {
      return Client.fromJson(response.body);
    } else {
      throw Exception(
          'Erro ao inserir o cliente. Motivo: ${ErrorDTO.fromJson(response.body).message}');
    }
  }

  Future<Client> update(Client client) async {
    final http.Response response = await http.put(
        Uri.http(API.endpoint, "/clients"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8"
        },
        body: client.fullClientToJson());

    if (response.statusCode == 200) {
      return client;
    } else {
      throw Exception(
          'Erro ao alterar o cliente ${client.id}. Motivo: ${ErrorDTO.fromJson(response.body).message}');
    }
  }

  Future<Client> remove(Client client) async {
    final http.Response response = await http.delete(
        Uri.http(API.endpoint, "/clients"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8"
        },
        body: client.fullClientToJson());

    if (response.statusCode != 200) {
      throw Exception(
          'Falha ao remover o cliente ${client.id}. Motivo: ${ErrorDTO.fromJson(response.body).message}');
    }
    return client;
  }
}
