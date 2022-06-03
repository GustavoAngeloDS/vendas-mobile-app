import 'dart:convert';

class Product {
  int? id;
  String description;

  Product(this.id, this.description);

  Product.create(this.description);

  Map<String, dynamic> newProductToMap() {
    return {"description": description};
  }

  Map<String, dynamic> fullProductToMap() {
    return {"id": id, "description": description};
  }

  static Product fromMap(Map<String, dynamic> map) {
    return Product(map["id"], map["description"]);
  }

  static List<Product> fromMaps(List<Map<String, dynamic>> maps) {
    return List.generate(maps.length, (i) {
      return Product.fromMap(maps[i]);
    });
  }

  static Product fromJson(String json) => Product.fromMap(jsonDecode(json));

  static List<Product> fromJsonList(String json) {
    final parsed = jsonDecode(json).cast<Map<String, dynamic>>();
    return parsed.map<Product>((map) => Product.fromMap(map)).toList();
  }

  String newProductToJson() => jsonEncode(newProductToMap());

  String fullProductToJson() => jsonEncode(fullProductToMap());
}
