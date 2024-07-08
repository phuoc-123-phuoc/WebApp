import 'package:admin_uber_web_panel/methods/stats_grid.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  static const String id = "\webPageHome";

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int membersCount = 0;
  int trainersCount = 0;
  int equipmentCount = 0;
  int classesCount = 0;
  double totalIncome = 0.0;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      // Perform all queries concurrently
      List<QuerySnapshot> snapshots = await Future.wait([
        FirebaseFirestore.instance.collection('customers').get(),
        FirebaseFirestore.instance.collection('suppliers').get(),
        FirebaseFirestore.instance.collection('orders').get(),
        FirebaseFirestore.instance.collection('products').get(),
        FirebaseFirestore.instance.collection('suppliers').get(),
      ]);

      double income = 0.0;
      for (var doc in snapshots[4].docs) {
        // Convert class_fee to double if it's a string
        String feeStr = doc['pay'];
        double fee = double.tryParse(feeStr) ?? 0.0;
        income += fee;
      }

      setState(() {
        membersCount = snapshots[0].size;
        trainersCount = snapshots[1].size;
        equipmentCount = snapshots[2].size;
        classesCount = snapshots[3].size;
        totalIncome = income;
      });
    } catch (e) {
      print('Error fetching data: $e');
      // Handle error as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40.0),
                    bottomRight: Radius.circular(40.0),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    StatsGrid(
                      'Income',
                      'Rs. ${totalIncome.toStringAsFixed(2)}' + '\$',
                      'images/increase_presentation_Profit_growth-512.png',
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StatsGrid(
                    'Customers',
                    membersCount.toString(),
                    'images/baby_child_children_boy-512.png',
                  ),
                  StatsGrid(
                    'Suppliers',
                    trainersCount.toString(),
                    'images/gym_coach_trainer_fitness-512.png',
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  StatsGrid(
                    'Order',
                    equipmentCount.toString(),
                    'images/cash_flow_tranfer_finance-512.png',
                  ),
                  StatsGrid(
                    'product',
                    classesCount.toString(),
                    'images/dumbbell_gym_fitness_exercise-512.png',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
