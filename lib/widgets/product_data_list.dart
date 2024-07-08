import 'package:admin_uber_web_panel/methods/common_methods.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductsDataList extends StatefulWidget {
  @override
  _ProductsDataListState createState() => _ProductsDataListState();
}

class _ProductsDataListState extends State<ProductsDataList> {
  CommonMethods cMethods = CommonMethods();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('products').snapshots(),
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
                    Center(child: Text(item['proid'] ?? '')),
                  ),
                  cMethods.data(
                    1,
                    Center(child: Text(item['maincateg'] ?? '')),
                  ),
                  cMethods.data(
                    1,
                    Center(child: Text(item['prodesc'] ?? '')),
                  ),
                  cMethods.data(
                    1,
                    Center(child: Text(item['proname'] ?? '')),
                  ),
                  cMethods.data(
                    1,
                    Center(child: Text(item['subcateg'] ?? '')),
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
                            item['proimages'][0] ?? '',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  cMethods.data(
                    1,
                    Center(child: Text(item['discount']?.toString() ?? '')),
                  ),
                  cMethods.data(
                    1,
                    Center(child: Text(item['instock']?.toString() ?? '')),
                  ),
                  cMethods.data(
                    1,
                    Center(
                        child: Text(item['colors'] != null
                            ? item['colors'].join(', ')
                            : '')),
                  ),
                  cMethods.data(
                    1,
                    Center(
                        child: Text("\$" + (item['price']?.toString() ?? ''))),
                  ),
                  cMethods.data(
                    1,
                    Center(
                        child: Text(item['sizes'] != null
                            ? item['sizes'].join(', ')
                            : '')),
                  ),
                  cMethods.data(
                    1,
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          // Xóa sản phẩm
                          FirebaseFirestore.instance
                              .collection('products')
                              .doc(item['proid']) // Sử dụng ID của sản phẩm
                              .delete()
                              .then((value) {
                            // Sau khi xóa thành công, cập nhật lại danh sách sản phẩm
                            setState(() {});
                          }).catchError((error) {
                            print("Failed to delete product: $error");
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
