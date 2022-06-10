import 'dart:convert';

import 'package:vendas_flutter/models/client.model.dart';

import 'order_item.model.dart';

class Order {
  int? id;
  late String? date;
  late List<OrderItem>? items;
  late Client client;

  Order(
      {this.id, required this.date, required this.items, required this.client});

  Order.create(this.items, this.client);

  Map<String, dynamic> newOrderToMap() {
    return {"date": date, "items": items, "client": client};
  }

  Map<String, dynamic> fullOrderToMap() {
    return {"id": id, "date": date, "items": items, "client": client};
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    final it = map['items'] as List<dynamic>;
    return Order(
        id: map["id"],
        date: map["date"],
        items: it.map((e) => OrderItem.fromMap(e)).toList(),
        client: Client.fromMap(map["client"]));
  }

  static List<Order> fromMaps(List<Map<String, dynamic>> maps) {
    return List.generate(maps.length, (i) {
      return Order.fromMap(maps[i]);
    });
  }

  static Order fromJson(String json) =>
      Order.fromMap(jsonDecode(json.toString()));

  static List<Order> fromJsonList(String json) {
    final parsed = jsonDecode(json).cast<Map<String, dynamic>>();
    return parsed.map<Order>((map) => Order.fromMap(map)).toList();
  }

  String newOrderToJson() => jsonEncode(newOrderToMap());

  String fullOrderToJson() => jsonEncode(fullOrderToMap());
}
