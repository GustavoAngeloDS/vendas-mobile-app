import 'package:vendas_flutter/models/client.model.dart';
import 'package:vendas_flutter/rest/client.rest.dart';

class ClientRepository {
  final ClientRest restInterface = ClientRest();

  Future<List<Client>> findClientByText(String text) async {
    return await restInterface.findClientByText(text);
  }

  Future<Client> findById(int id) async {
    return await restInterface.findById(id);
  }

  Future<List<Client>> findAll() async {
    return await restInterface.findAll();
  }

  Future<Client> save(Client client) async {
    try {
      return await restInterface.save(client);
    } catch (exception) {
      rethrow;
    }
  }

  Future<Client> update(Client client) async {
    try {
      return await restInterface.update(client);
    } catch (exception) {
      rethrow;
    }
  }

  Future<Client> remove(Client client) async {
    return await restInterface.remove(client);
  }
}
