import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horse/helper/My_Text.dart';
import 'package:horse/model/Horse_coment_model.dart';

class Horse_cmnts extends StatefulWidget {

  final List<Horse_cmnt_model> list;
  final int pos;


  const Horse_cmnts({super.key, required this.list, required this.pos});

  @override
  State<Horse_cmnts> createState() => _Horse_cmntsState(list,pos);
}

class _Horse_cmntsState extends State<Horse_cmnts> {

  final List<Horse_cmnt_model> list;
  final int pos;

  _Horse_cmntsState(this.list, this.pos);

  final player = AudioPlayer();

  bool play=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();




  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        backgroundColor: Colors.red,
        title: MyText(txt: "Comment", color: Colors.white, txtSize: 20,fontWeight: FontWeight.bold),
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 80,),
              MyText(txt: list[pos].owner_name, color: Colors.black, txtSize: 20),

              if(list[pos].img!="")
                Image.file(File(list[pos].img)),
              if(list[pos].record!="")                
              ElevatedButton(onPressed: () async{

                if(play){
                  await player.pause();
                }
                else{

                  await player.play(DeviceFileSource(list[pos].record));
                }
                setState(() {
                  play=!play;
                });
              }, child: Text(play?'pause':'play')),



              MyText(txt: list[pos].cmnt, color: Colors.black, txtSize: 18),
            ],
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
