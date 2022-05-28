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
          icon: Icons.add,
          text: "Novo produto",
          onTap: () =>
              Navigator.pushReplacementNamed(context, Routes.newProduct)),
      const Divider(),
      _createDrawerItem(
          icon: Icons.list,
          text: "Listar produtos",
          onTap: () =>
              Navigator.pushReplacementNamed(context, Routes.listProducts)),
      _createDrawerItem(
          icon: Icons.list,
          text: "Listar Pedidos",
          onTap: () =>
              Navigator.pushReplacementNamed(context, Routes.listOrders)),
      ListTile(title: const Text("v0.1"), onTap: () {})
    ]));
  }

  Widget _createHeader() {
    return DrawerHeader(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      decoration: const BoxDecoration(color: Colors.grey),
      child: Stack(children: const <Widget>[
        Positioned(
          bottom: 12.0,
          left: 16.0,
          child: Text("Controle de VenDAS",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500)),
        )
      ]),
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
