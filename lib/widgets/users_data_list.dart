import 'package:admin_uber_web_panel/methods/common_methods.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UsersDataList extends StatefulWidget {
  @override
  _UsersDataListState createState() => _UsersDataListState();
}

class _UsersDataListState extends State<UsersDataList> {
  CommonMethods cMethods = CommonMethods();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('customers').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text(
              "Error Occurred. Try Later.",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.pink,
              ),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        List<DocumentSnapshot> documents = snapshot.data!.docs;

        return Column(
          children: documents.map((document) {
            var item = document.data() as Map<String, dynamic>;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  cMethods.data(
                    2,
                    Center(child: Text(item['cid'] ?? '')),
                  ),
                  cMethods.data(
                    1,
                    Center(child: Text(item['email'] ?? '')),
                  ),
                  cMethods.data(
                    1,
                    Center(child: Text(item['name'] ?? '')),
                  ),
                  cMethods.data(
                    1,
                    Center(child: Text(item['phone'] ?? '')),
                  ),
                  cMethods.data(
                    1,
                    Center(
                      child: Container(
                        width: 100,
                        height: 100,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                              10), // Nếu bạn muốn bo tròn góc
                          child: Image.network(
                            item['profileimage'] ?? '',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  cMethods.data(
                    1,
                    Center(child: Text(item['address'] ?? '')),
                  ),
                  cMethods.data(
                    1,
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          // Xóa khách hàng
                          FirebaseFirestore.instance
                              .collection('customers')
                              .doc(item['cid']) // Sử dụng ID của khách hàng
                              .delete()
                              .then((value) {
                            // Sau khi xóa thành công, cập nhật lại danh sách người dùng
                            setState(() {});
                          }).catchError((error) {
                            print("Failed to delete customer: $error");
                            // Xử lý lỗi nếu cần
                          });
                        },
                        child: Text('Delete'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 0.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
