import 'dart:convert';

import 'package:vendas_flutter/models/client.model.dart';

import 'order_item.model.dart';

class Order {
  int? id;
  String? date;
  late List<OrderItem>? items;
  late Client client;

  Order({this.id, this.date, required this.items, required this.client});

  Order.create(this.date, this.items, this.client);

  Map<String, dynamic> newOrderToMap() {
    return {"items": items, "client": client};
  }

  Map<String, dynamic> fullOrderToMap() {
    return {"id": id, "date": date, "items": items, "client": client};
  }

  Order.fromMap(Map<String, dynamic> map)
      : id = map['id'] ?? 0,
        date = map['date'] ?? "",
        items = ((map['items'] ?? []) as List)
            .map((e) => OrderItem.fromMap(e))
            .toList(),
        client = Client.fromMap(map["client"] ?? {});

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

  // dynamic toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['id'] = this.id;
  //   data['date'] = this.date;
  //   if (this.items != null) {
  //     data['items'] = this.items!.map((v) => v.toJson()).toList();
  //   }
  //   if (this.client != null) {
  //     data['client'] = this.client!.toJson();
  //   }
  //   return jsonEncode(data);
  // }
}
