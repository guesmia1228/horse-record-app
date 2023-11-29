import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'My_Text.dart';

class Icon_Button extends StatelessWidget {
  final String txt;
  Color btn_color,txt_color=Colors.white;
  final GestureDetector gestureDetector;
  double radios,btn_size;
   Icon_Button({super.key, required this.txt,required this.btn_color, this.txt_color=Colors.white60,
     this.radios=20,required this.btn_size, required this.gestureDetector});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: gestureDetector.onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: btn_color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radios)),
          fixedSize: Size.fromWidth(btn_size),
        ),
        child: Center(
          child: Icon(
            txt == "picture" ? Icons.picture_in_picture_sharp :
            (txt == "comment" ? Icons.comment :
              (txt == "Record" ? Icons.record_voice_over :
                 Icons.stop)),  // Replace 'picture' with the desired icon from the Flutter icon library
            size: 24,  // Set the size of the icon
            color: txt_color,  // Set the color of the icon
          ),
        ),
      );
  }
}
