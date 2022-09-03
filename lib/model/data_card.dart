import 'package:flutter/material.dart';

import '../components/constant.dart';

class DataCard extends StatelessWidget {
  DataCard(
      {required this.myController,
      required this.labelText,
      required this.hintText,
      required this.keyboardType,
      required this.inputFormate});

  final TextEditingController myController;
  final String labelText;
  final String hintText;
  final TextInputType keyboardType;
  final List inputFormate;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: myController,
        keyboardType: keyboardType,
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: xAppBarColor),
          ),
          labelText: labelText,
          hintText: hintText,
          counterText: '',
          hintStyle: TextStyle(fontSize: 15),
          labelStyle: TextStyle(color: xAppBarColor),
        ),
      ),
    );
  }
}
