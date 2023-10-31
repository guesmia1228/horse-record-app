import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'My_Text.dart';

class My_Btn extends StatelessWidget {
  final String txt;
  Color btn_color,txt_color=Colors.white;
  final GestureDetector gestureDetector;
  double radios,btn_size;
   My_Btn({super.key, required this.txt,required this.btn_color, this.txt_color=Colors.white60,
     this.radios=20,required this.btn_size, required this.gestureDetector});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: gestureDetector.onTap,
        child: MyText(txt: txt, color: txt_color, txtSize: 13),style: ElevatedButton.styleFrom(
        backgroundColor: btn_color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radios)),
        fixedSize: Size.fromWidth(btn_size)
      ),);
  }
}
