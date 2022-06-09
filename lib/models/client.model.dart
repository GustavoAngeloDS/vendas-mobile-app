import 'dart:convert';

class Client {
  int ?id;
  String cpf;
  String name;
  String lastname;

  Client(this.id, this.cpf, this.name, this.lastname);

  Client.create(this.cpf, this.name, this.lastname);

  Map<String, dynamic> newClientToMap() {
    return {
      "cpf": cpf,
      "name": name,
      "lastname": lastname
    };
  }

  Map<String, dynamic> fullClientToMap() {
    return {
      "id": id,
      "cpf": cpf,
      "name": name,
      "lastname": lastname
    };
  }

  static Client fromMap(Map<String, dynamic> map) {
    return Client(
        map["id"],
        map["cpf"],
        map["name"],
        map["lastname"]
    );
  }

  static List<Client> fromMaps(List<Map<String, dynamic>> maps) {
    return List.generate(maps.length, (i) {
      return Client.fromMap(maps[i]);
    });
  }

  static Client fromJson(String json) => Client.fromMap(jsonDecode(json));

  static List<Client> fromJsonList(String json) {
    final parsed = jsonDecode(json).cast<Map<String, dynamic>>();
    return parsed.map<Client>((map) => Client.fromMap(map)).toList();
  }

  String newClientToJson() => jsonEncode(newClientToMap());

  String fullClientToJson() => jsonEncode(fullClientToMap());
}