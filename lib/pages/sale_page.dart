import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class SalePage extends StatefulWidget {
  static const String id = "webPageSale";

  const SalePage({Key? key}) : super(key: key);

  @override
  _SalePageState createState() => _SalePageState();
}

class _SalePageState extends State<SalePage> {
  final TextEditingController _codeNameController = TextEditingController();
  final TextEditingController _codePercentageController =
      TextEditingController();
  final CollectionReference _saleCollection =
      FirebaseFirestore.instance.collection('sale');
  DateTime? _expiryDate;
  bool _forAllUsers = true;
  String? _selectedUserId;
  List<Map<String, dynamic>> _users = [];

  @override
  void initState() {
    super.initState();
    _deleteExpiredDiscountCodes();
    _fetchUsers().then((users) {
      setState(() {
        _users = users;
      });
    });
  }

  Future<List<Map<String, dynamic>>> _fetchUsers() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('customers').get();
    return querySnapshot.docs.map((doc) {
      return {
        'id': doc.id,
        'name': doc['name'],
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter Discount Code Details',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.pinkAccent.shade700,
              ),
            ),
            const SizedBox(height: 20),
            
            TextField(
              controller: _codeNameController,
              decoration: InputDecoration(
                labelText: "Code Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.pinkAccent.shade700,
                  ),
                ),
                prefixIcon: Icon(Icons.code, color: Colors.pinkAccent.shade700),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _codePercentageController,
              decoration: InputDecoration(
                labelText: "Code Percentage",
                labelStyle: TextStyle(
                  color: Colors.pinkAccent.shade700,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.pinkAccent.shade700,
                  ),
                ),
                prefixIcon:
                    Icon(Icons.percent, color: Colors.pinkAccent.shade700),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            SwitchListTile(
              title: Text('For all users'),
              value: _forAllUsers,
              onChanged: (value) {
                setState(() {
                  _forAllUsers = value;
                });
              },
            ),
            if (!_forAllUsers)
              DropdownButtonFormField<String>(
                value: _selectedUserId,
                decoration: InputDecoration(
                  labelText: 'Select User',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.pinkAccent.shade700,
                    ),
                  ),
                ),
                items: _users.map((user) {
                  return DropdownMenuItem<String>(
                    value: user['id'],
                    child: Text(user['name']),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedUserId = value;
                  });
                },
              ),
            const SizedBox(height: 20),
            ListTile(
              title: Text(
                _expiryDate == null
                    ? 'Select Expiry Date'
                    : 'Expiry Date: ${DateFormat.yMMMd().format(_expiryDate!)}',
              ),
              trailing: Icon(Icons.calendar_today),
              onTap: _selectExpiryDate,
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: _forAllUsers || _selectedUserId != null
                    ? _addOrUpdateDiscountCode
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text("Add / Update Code"),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _saleCollection.orderBy('expiryDate').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                        child: Text('No discount codes available.'));
                  }

                  List<DocumentSnapshot> documents = snapshot.data!.docs;
                  List<Map<String, dynamic>> discountCodes =
                      documents.map((doc) {
                    Map<String, dynamic> data =
                        doc.data() as Map<String, dynamic>;
                    data['id'] = doc.id;
                    return data;
                  }).toList();

                  return ListView.builder(
                    itemCount: discountCodes.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: CircleAvatar(
                            backgroundColor: Colors.pinkAccent.shade100,
                            child: Icon(Icons.local_offer,
                                color: Colors.pinkAccent.shade700),
                          ),
                          title: Text(
                            discountCodes[index]['codeName'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.pinkAccent.shade700,
                            ),
                          ),
                          subtitle: Text(
                            '${discountCodes[index]['percentage']}% off\nExpires: ${DateFormat.yMMMd().format(discountCodes[index]['expiryDate'].toDate())}',
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit,
                                    color: Colors.blueAccent.shade700),
                                onPressed: () =>
                                    _editDiscountCode(discountCodes[index]),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete,
                                    color: Colors.redAccent.shade700),
                                onPressed: () => _deleteDiscountCode(
                                    discountCodes[index]['id']),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectExpiryDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _expiryDate) {
      setState(() {
        _expiryDate = picked;
      });
    }
  }

  Future<void> _addOrUpdateDiscountCode() async {
    String codeName = _codeNameController.text.trim();
    String codePercentage = _codePercentageController.text.trim();

    if (codeName.isEmpty ||
        codePercentage.isEmpty ||
        _expiryDate == null ||
        (!_forAllUsers && _selectedUserId == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please enter all fields including expiry date')),
      );
      return;
    }

    int percentage;
    try {
      percentage = int.parse(codePercentage);
      if (percentage < 0 || percentage > 100) {
        throw const FormatException("Percentage out of range");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please enter a valid percentage (0-100)')),
      );
      return;
    }

    try {
      if (_selectedUserId != null) {
        // Update discount code for specific user
        await _saleCollection.doc().set({
          'codeName': codeName,
          'percentage': percentage,
          'expiryDate': Timestamp.fromDate(_expiryDate!),
          'userId': _selectedUserId,
        });
      } else {
        // Add discount code for all users
        await _saleCollection.add({
          'codeName': codeName,
          'percentage': percentage,
          'expiryDate': Timestamp.fromDate(_expiryDate!),
          'userId': null,
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Discount code added/updated successfully')),
      );

      _codeNameController.clear();
      _codePercentageController.clear();
      setState(() {
        _expiryDate = null;
        _forAllUsers = true;
        _selectedUserId = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _deleteDiscountCode(String id) async {
    try {
      await _saleCollection.doc(id).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Discount code deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _editDiscountCode(Map<String, dynamic> discountCode) async {
    setState(() {
      _codeNameController.text = discountCode['codeName'];
      _codePercentageController.text = discountCode['percentage'].toString();
      _expiryDate = discountCode['expiryDate'].toDate();
      _forAllUsers = discountCode['userId'] == null;
      _selectedUserId = discountCode['userId'];
    });

    await _saleCollection.doc(discountCode['id']).delete();
  }

  Future<void> _deleteExpiredDiscountCodes() async {
    final now = Timestamp.now();
    final querySnapshot = await _saleCollection
        .where('expiryDate', isLessThanOrEqualTo: now)
        .get();

    final batch = FirebaseFirestore.instance.batch();
    for (var doc in querySnapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
}
