import 'package:vendas_flutter/rest/product_rest.dart';

import '../models/product.model.dart';

class ProductRepository {
  final ProductRest restInterface = ProductRest();

  Future<Product> findById(int id) async {
    return await restInterface.findById(id);
  }

  Future<List<Product>> findAll() async {
    return await restInterface.findAll();
  }

  Future<Product> save(Product product) async {
    return await restInterface.save(product);
  }

  Future<Product> update(Product product) async {
    return await restInterface.update(product);
  }

  Future<Product> remove(Product product) async {
    return await restInterface.remove(product);
  }
}
