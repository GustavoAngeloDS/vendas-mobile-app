import 'package:vendas_flutter/models/product.model.dart';

class ProductService {

  List<Product> getAllProducts() {
    Product pd1 = Product("Banana", 1);
    Product pd2 = Product("Abacate", 2);

    return [pd1, pd2];
  }

  Product getProductById(int id) {
    return Product("Produto Teste", id);
  }

  void saveProduct(Product product) {

  }

  void removeProduct(Product product) {

  }

  Product updateProduct(Product product) {
    return product;
  }
}
