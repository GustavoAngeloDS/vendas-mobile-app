import 'package:flutter/material.dart';
import 'package:vendas_flutter/routes/routes.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(padding: EdgeInsets.zero, children: <Widget>[
      _createHeader(),
      _createDrawerItem(
          text: "Home",
          icon: Icons.home,
          onTap: () =>
              Navigator.pushReplacementNamed(context, Routes.homePage)),
      const Divider(),
      _createDrawerItem(
          text: "Clientes",
          icon: Icons.people,
          onTap: () =>
              Navigator.pushReplacementNamed(context, Routes.listClients)),
      _createDrawerItem(
          text: "Produtos",
          icon: Icons.shopping_cart,
          onTap: () =>
              Navigator.pushReplacementNamed(context, Routes.listProducts)),
      _createDrawerItem(
          text: "Pedidos",
          icon: Icons.shopping_basket,
          onTap: () =>
              Navigator.pushReplacementNamed(context, Routes.listProducts)),
      const Divider(),
      ListTile(title: const Text("SDV Version: 0.3"), onTap: () {})
    ]));
  }

  Widget _createHeader() {
    return const DrawerHeader(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
          color: Colors.grey,
          image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage('assets/images/venDASLogoReduzido.png'))), child: null,
    );
  }

  Widget _createDrawerItem(
      {required IconData icon,
      required String text,
      required GestureTapCallback onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          Icon(icon),
          Padding(padding: const EdgeInsets.only(left: 8.0), child: Text(text))
        ],
      ),
      onTap: onTap,
    );
  }
}
