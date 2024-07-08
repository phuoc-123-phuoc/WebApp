import 'package:flutter/material.dart';

class CommonMethods {
  double calculateAmount(double accountValue) {
    const baseAmount = 12.0; // Số tiền cơ bản cho mỗi tài khoản là 12$
    if (accountValue <= 1) {
      return baseAmount;
    } else {
      return baseAmount * accountValue;
    }
  }

  Widget header(int headerFlexValue, String headerTitle) {
    return Expanded(
      flex: headerFlexValue,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          color: const Color.fromARGB(255, 38, 29, 32),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            headerTitle,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget data(int dataFlexValue, Widget widget) {
    return Expanded(
      flex: dataFlexValue,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: widget,
        ),
      ),
    );
  }
}
