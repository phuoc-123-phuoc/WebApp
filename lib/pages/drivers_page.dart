import 'package:admin_uber_web_panel/widgets/drivers_data_list.dart';
import 'package:admin_uber_web_panel/widgets/users_data_list.dart';
import 'package:flutter/material.dart';
import '../methods/common_methods.dart';

class DriversPage extends StatefulWidget {
  static const String id = "\webPageSuppliers";

  const DriversPage({super.key});

  @override
  State<DriversPage> createState() => _DriversPageState();
}

class _DriversPageState extends State<DriversPage> {
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
                  "Manage Supplier",
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
                  cMethods.header(2, "SUPP ID"),
                  cMethods.header(1, "EMAIL"),
                  cMethods.header(1, "PAY"),
                  cMethods.header(1, "PHONE"),
                  cMethods.header(1, "STORE LOGO"),
                  cMethods.header(1, "STORE NAME"),
                  cMethods.header(1, "ACTION"),
                  cMethods.header(1, "BLOCK"),
                ],
              ),

              //display data
              SuppliersDataList(),
            ],
          ),
        ),
      ),
    );
  }
}
