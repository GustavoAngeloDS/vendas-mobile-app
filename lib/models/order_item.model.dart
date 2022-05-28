import 'dart:convert';

import 'package:vendas_flutter/models/product.model.dart';

class OrderItem {
  late int qtdade;
  late Product product;

  OrderItem({required this.qtdade, required this.product});

  OrderItem.create(this.qtdade, this.product);

  Map<String, dynamic> newProductToMap() {
    return {"qtdade": qtdade, "product": product};
  }

  Map<String, dynamic> fullProductToMap() {
    return {"qtdade": qtdade, "product": product};
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
        qtdade: map["qtdade"], product: Product.fromMap(map["product"]));
  }

  static List<OrderItem> fromMaps(List<Map<String, dynamic>> maps) {
    return List.generate(maps.length, (i) {
      return OrderItem.fromMap(maps[i]);
    });
  }

  factory OrderItem.fromJson(Map<String, dynamic> map) {
    return OrderItem(
        qtdade: map['qtdade'], product: Product.fromJson(map['product']));
  }

  static List<OrderItem> fromJsonList(String json) {
    final parsed = jsonDecode(json).cast<Map<String, dynamic>>();
    return parsed.map<OrderItem>((map) => OrderItem.fromMap(map)).toList();
  }

  String newProductToJson() => jsonEncode(newProductToMap());

  String fullProductToJson() => jsonEncode(fullProductToMap());
}
