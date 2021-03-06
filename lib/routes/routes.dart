import 'package:vendas_flutter/views/client/list_clients_page.dart';
import 'package:vendas_flutter/views/client/new_client_page.dart';
import 'package:vendas_flutter/views/client/update_client_page.dart';
import 'package:vendas_flutter/views/order/list_order_page.dart';
import 'package:vendas_flutter/views/order/new_order_page.dart';
import 'package:vendas_flutter/views/order/update_order_page.dart';
import 'package:vendas_flutter/views/product/list_product_page.dart';
import 'package:vendas_flutter/views/product/new_product_page.dart';
import 'package:vendas_flutter/views/product/update_product.dart';

class Routes {
  static const String homePage = "/";
  static const String listProducts = ListProductPage.routeName;
  static const String newProduct = NewProductPage.routeName;
  static const String updateProduct = UpdateProductPage.routeName;

  static const String listOrders = ListOrderPage.routeName;
  static const String newOrder = NewOrderPage.routeName;
  static const String updateOrder = UpdateOrderPage.routeName;

  static const String listClients = ListClientPage.routeName;
  static const String newClient = NewClientPage.routeName;
  static const String updateClient = UpdateClientPage.routeName;
}
