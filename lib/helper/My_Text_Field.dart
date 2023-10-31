import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class My_Text_Field extends StatelessWidget {
  final controler;
  final String label;
  My_Text_Field({super.key,required this.controler, required this.label});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controler,
      style: TextStyle(color: Colors.black),
      cursorColor: Colors.white,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.black),
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black))
      ),

    );
  }
}
