import 'package:currency_convertor/utils/HexColor.dart';
import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  MyTextField(this.controller);

  @override
  Widget build(BuildContext context) {
    return TextField(
        keyboardType: TextInputType.number,
        controller: controller,
        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: HexColor('#273c75'),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.blueAccent,
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          hintText: "Amount",
        ));
  }
}
