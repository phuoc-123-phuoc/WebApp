import 'package:admin_uber_web_panel/widgets/order_data_list.dart';
import 'package:admin_uber_web_panel/widgets/product_data_list.dart';
import 'package:flutter/material.dart';

import '../methods/common_methods.dart';

class ProdutcPage extends StatefulWidget {
  static const String id = "\webPageProduct";

  const ProdutcPage({super.key});

  @override
  State<ProdutcPage> createState() => _ProdutcPageState();
}

class _ProdutcPageState extends State<ProdutcPage> {
  CommonMethods cMethods = CommonMethods();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.topLeft,
                child: const Text(
                  "Manage Products",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(
                height: 18,
              ),

              Row(
                children: [
                  cMethods.header(2, "ID"),
                  cMethods.header(1, "MAIN CATEG"),
                  cMethods.header(1, "PRO DESC"),
                  cMethods.header(1, "PRONAME"),
                  cMethods.header(1, "SUBCATEG"),
                  cMethods.header(1, "PRO IMAGE"),
                  cMethods.header(1, "DISCOUNT"),
                  cMethods.header(1, "INSTOCK"),
                  cMethods.header(1, "COLOR"),
                  cMethods.header(1, "PRICE"),
                  cMethods.header(1, "SIZE"),
                  cMethods.header(1, "ACTION"),
                ],
              ),

              //display data
              ProductsDataList(),
            ],
          ),
        ),
      ),
    );
  }
}
