import 'package:admin_uber_web_panel/methods/common_methods.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SuppliersDataList extends StatefulWidget {
  @override
  _SuppliersDataListState createState() => _SuppliersDataListState();
}

class _SuppliersDataListState extends State<SuppliersDataList> {
  bool isLocked = false;
  CommonMethods cMethods = CommonMethods();
  void updateButtonState() {
    setState(() {
      isLocked = !isLocked; // Đảo ngược giá trị của isLocked
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('suppliers').snapshots(),
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
                  // Expanded(
                  //   flex: 2,
                  //   child: Center(child: Text(item['sid'] ?? '')),
                  // ),
                  cMethods.data(
                    2,
                    Center(child: Text(item['sid'] ?? '')),
                  ),
                  cMethods.data(
                    1,
                    Center(child: Text(item['email'] ?? '')),
                  ),
                  cMethods.data(
                    1,
                    Center(child: Text(item['pay'] + '\$' ?? '')),
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
                            item['storelogo'] ?? '',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  cMethods.data(
                    1,
                    Center(child: Text(item['storename'] ?? '')),
                  ),
                  cMethods.data(
                    1,
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          // Xóa khách hàng
                          FirebaseFirestore.instance
                              .collection('suppliers')
                              .doc(item['sid']) // Sử dụng ID của khách hàng
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
                      ),
                    ),
                  ),
                  cMethods.data(
                    1,
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection('suppliers')
                              .doc(item['sid'])
                              .get()
                              .then((DocumentSnapshot documentSnapshot) {
                            if (documentSnapshot.exists) {
                              // Lấy giá trị của isLocked từ tài khoản từ cơ sở dữ liệu
                              bool isLocked = documentSnapshot.get('isLocked');
                              // Cập nhật văn bản của nút dựa trên giá trị của isLocked
                              setState(() {
                                isLocked =
                                    !isLocked; // Đảo ngược giá trị của isLocked
                              });
                              // Cập nhật trạng thái của tài khoản trong cơ sở dữ liệu
                              FirebaseFirestore.instance
                                  .collection('suppliers')
                                  .doc(item['sid'])
                                  .update({
                                'isLocked': isLocked,
                              }).then((value) {
                                // Thực hiện các hành động khác nếu cần
                              }).catchError((error) {
                                print(
                                    "Failed to update account status: $error");
                                // Xử lý lỗi nếu cần
                              });
                            } else {
                              print('Tài khoản không tồn tại');
                              // Xử lý khi tài khoản không tồn tại
                            }
                          }).catchError((error) {
                            print("Lỗi khi truy vấn cơ sở dữ liệu: $error");
                            // Xử lý lỗi nếu cần
                          });
                        },
                        icon: Icon(Icons
                            .lock), // Icon dựa trên trạng thái của tài khoản
                        label: StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('suppliers')
                              .doc(item['sid'])
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            }

                            // Lấy giá trị của isLocked từ snapshot
                            bool isLocked = snapshot.data!.get('isLocked');

                            // Trả về văn bản tùy thuộc vào giá trị của isLocked
                            return Text(
                              isLocked ? 'Unlock' : 'Lock',
                            );
                          },
                        ),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                                  (states) {
                            if (states.contains(MaterialState.disabled)) {
                              return Colors
                                  .grey; // Màu nền khi nút bị vô hiệu hóa
                            }
                            // Màu nền tùy thuộc vào giá trị của isLocked
                            return isLocked ? Colors.green : Colors.red;
                          }),
                          // Màu chữ của nút
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
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
