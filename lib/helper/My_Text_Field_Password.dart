import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class My_Text_Field_Password extends StatefulWidget {
  final controler;
  final String label;
  My_Text_Field_Password({super.key,required this.controler,required this.label});

  @override
  State<My_Text_Field_Password> createState() => _My_Text_Field_PasswordState(controler,label);
}

class _My_Text_Field_PasswordState extends State<My_Text_Field_Password> {
  final controler;
  final String label;

  _My_Text_Field_PasswordState(this.controler, this.label);

  bool passHide=true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controler,
      style: TextStyle(color: Colors.white),
      obscureText: passHide,
      cursorColor: Colors.white,
      decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white38),
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white38)),
        suffixIcon: IconButton(onPressed: () {
          if(passHide)
            passHide=false;
          else
            passHide=true;
          setState(() {

          });
        }, icon: passHide?Icon(Icons.visibility):Icon(Icons.visibility_off)),
        suffixIconColor: Colors.white38
      ),

    );
  }
}

