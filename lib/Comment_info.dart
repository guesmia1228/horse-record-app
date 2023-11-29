import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horse/helper/My_Text.dart';
import 'package:horse/model/Horse_coment_model.dart';
import 'package:horse/helper/Praf_handler.dart';

import 'package:horse/helper/My_Text_Field.dart';
class Comment_info extends StatefulWidget {


  const Comment_info({super.key});

  @override
  State<Comment_info> createState() => _Comment_infoState();
}

class _Comment_infoState extends State<Comment_info> {


  final cmnt=TextEditingController();

  _Comment_infoState();

  final player = AudioPlayer();

  bool play=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();




  }
void showDeleteConfirmationDialog(BuildContext context, Function onConfirm) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text("Confirm Save"),
          content: Text("Are you sure you want to Save this item?"),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                 Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text("Save"),
              onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                onConfirm(); // Call the onConfirm function passed as a parameter
              },
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        backgroundColor: Colors.red,
        title: MyText(txt: "Comment", color: Colors.white, txtSize: 20,fontWeight: FontWeight.bold),
        actions: [
            IconButton(
              icon: Icon(Icons.save),
              onPressed: () async{
                // Add the functionality for saving the comment here
                 showDeleteConfirmationDialog(context, () async {
                   praf_handler.set_string("now_comment",cmnt.text);
                    String top = await praf_handler.get_string("now_comment");
                    print(top);
                    Navigator.pop(context, true);
                  });
                   

              },
            ),
          ],
      ),

     body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 20),
                My_Text_Field(controler: cmnt, label: 'Add Comment'),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),

      // ListView.builder(
      //   itemCount: list.length,
      //     itemBuilder: (context, index) {
      //       Horse_cmnt_model model=list[index];
      //
      //       File file=File(model.img);
      //       return Padding(
      //         padding: const EdgeInsets.all(8.0),
      //         child: Column(
      //           children: [
      //             MyText(txt: model.owner_name, color: Colors.black, txtSize: 20),
      //             Image.file(file),
      //             MyText(txt: model.cmnt, color: Colors.black, txtSize: 18),
      //           ],
      //         ),
      //       );
      //
      //     },),


    );
  }
}
