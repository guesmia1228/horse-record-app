import 'package:flutter/cupertino.dart';

class MyText extends StatelessWidget {
  final String txt;
  final Color color;
  final double txtSize;
  final TextDecoration textDecoration;
  final FontWeight fontWeight;
  const MyText({super.key, required this.txt, required this.color, required this.txtSize,this.textDecoration=TextDecoration.none,this.fontWeight=FontWeight.normal});

  @override
  Widget build(BuildContext context) {
    return Text(txt,style: TextStyle(
      color: color,fontSize: txtSize,
      decoration: textDecoration,fontWeight: fontWeight
    ),);
  }
}
