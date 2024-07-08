import 'package:admin_uber_web_panel/dashboard/dashboard.dart';
import 'package:admin_uber_web_panel/pages/dashboard_home.dart';
import 'package:admin_uber_web_panel/pages/drivers_page.dart';
import 'package:admin_uber_web_panel/pages/product_page.dart';
import 'package:admin_uber_web_panel/pages/sale_page.dart';
import 'package:admin_uber_web_panel/pages/trips_page.dart';
import 'package:admin_uber_web_panel/pages/users_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

class SideNavigationDrawer extends StatefulWidget {
  const SideNavigationDrawer({super.key});

  @override
  State<SideNavigationDrawer> createState() => _SideNavigationDrawerState();
}

class _SideNavigationDrawerState extends State<SideNavigationDrawer> {
  Widget chosenScreen = DriversPage();

  sendAdminTo(selectedPage) {
    switch (selectedPage.route) {
      case DriversPage.id:
        setState(() {
          chosenScreen = DriversPage();
        });
        break;

      case UsersPage.id:
        setState(() {
          chosenScreen = UsersPage();
        });
        break;

      case TripsPage.id:
        setState(() {
          chosenScreen = TripsPage();
        });
        break;
      case ProdutcPage.id:
        setState(() {
          chosenScreen = ProdutcPage();
        });
        break;
      case SalePage.id:
        setState(() {
          chosenScreen = SalePage();
        });
        break;
      case HomePage.id:
        setState(() {
          chosenScreen = HomePage();
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 213, 156, 177),
        title: const Text(
          "Admin Web",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      sideBar: SideBar(
        items: const [
          AdminMenuItem(
            title: "Supplier",
            route: DriversPage.id,
            icon: CupertinoIcons.suit_diamond_fill,
          ),
          AdminMenuItem(
            title: "Users",
            route: UsersPage.id,
            icon: CupertinoIcons.person_2_fill,
          ),
          AdminMenuItem(
            title: "Orders",
            route: TripsPage.id,
            icon: CupertinoIcons.shopping_cart,
          ),
          AdminMenuItem(
            title: "Products",
            route: ProdutcPage.id,
            icon: CupertinoIcons.plus_app,
          ),
          AdminMenuItem(
            title: "Sale Off",
            route: SalePage.id,
            icon: CupertinoIcons.rectangle_arrow_up_right_arrow_down_left_slash,
          ),
          AdminMenuItem(
            title: "Home ",
            route: HomePage.id,
            icon: CupertinoIcons.home,
          ),
        ],
        selectedRoute: DriversPage.id,
        onSelected: (selectedPage) {
          sendAdminTo(selectedPage);
        },
      ),
      body: chosenScreen,
    );
  }
}
