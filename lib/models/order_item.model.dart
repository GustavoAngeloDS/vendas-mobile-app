import 'dart:convert';

import 'package:vendas_flutter/models/product.model.dart';

class OrderItem {
  late int qtdade;
  late Product product;

  OrderItem({required this.qtdade, required this.product});

  OrderItem.create(this.qtdade, this.product);

  OrderItem copy({
    int? qtdade,
    Product? product,
  }) =>
      OrderItem(
        product: product ?? this.product,
        qtdade: qtdade ?? this.qtdade,
      );

  Map<String, dynamic> newOrderItemToMap() {
    return {"qtdade": qtdade, "product": product};
  }

  Map<String, dynamic> fullProductToMap() {
    return {"qtdade": qtdade, "product": product};
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
        qtdade: map["qtdade"] ?? 1,
        product: Product.fromMap(map["product"] ?? {}));
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

  String newProductToJson() => jsonEncode(newOrderItemToMap());

  String fullProductToJson() => jsonEncode(fullProductToMap());

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['qtdade'] = this.qtdade;
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    return data;
  }
}
