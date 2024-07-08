import 'package:admin_uber_web_panel/widgets/order_data_list.dart';
import 'package:flutter/material.dart';

import '../methods/common_methods.dart';

class TripsPage extends StatefulWidget {
  static const String id = "\webPageTrips";

  const TripsPage({super.key});

  @override
  State<TripsPage> createState() => _TripsPageState();
}

class _TripsPageState extends State<TripsPage> {
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
                  "Manage Orders",
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
                  cMethods.header(2, "ORDER ID"),
                  cMethods.header(1, "ADDRESS"),
                  cMethods.header(1, "CUST NAME"),
                  cMethods.header(1, "DELIVERY"),
                  cMethods.header(1, "EMAIL"),
                  cMethods.header(1, "ORDER IMAGE"),
                  cMethods.header(1, "ORDER NAME"),
                  cMethods.header(1, "PHONE"),
                  cMethods.header(1, "PRICE"),
                  cMethods.header(1, "QUANTITY"),
                  cMethods.header(1, "PROFILE IMAGE"),
                  cMethods.header(1, "ACTION"),
                ],
              ),

              //display data
              OrdersDataList(),
            ],
          ),
        ),
      ),
    );
  }
}
