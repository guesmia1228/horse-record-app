import 'dart:convert';

import 'package:age_calculator/age_calculator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hourses/Horse_info.dart';
import 'package:hourses/helper/My_Button.dart';
import 'package:hourses/helper/My_Text.dart';
import 'package:hourses/helper/My_Text_Field.dart';
import 'package:hourses/helper/Praf_handler.dart';
import 'package:hourses/helper/my_helper.dart';
import 'package:hourses/model/Horse_model.dart';
import 'package:hourses/model/Shedule_model.dart';
import 'package:intl/intl.dart';
import 'package:telephony/telephony.dart';

class Add_comment extends StatefulWidget {
  final Shedule_modle shedule_modle;
  final DateTime weekDay;
  const Add_comment({super.key, required this.shedule_modle, required this.weekDay});

  @override
  State<Add_comment> createState() => _Add_commentState(shedule_modle,weekDay);
}

class _Add_commentState extends State<Add_comment> {
  final Shedule_modle shedule_modle;
  final DateTime weekDay;

  _Add_commentState(this.shedule_modle, this.weekDay);

  String yearBorn_String='';
  String show_flag= '';
  @override

  void initState() {
    // TODO: implement initState
    super.initState();
    getList();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: MyText(txt: shedule_modle.owner_name, color: Colors.white, txtSize: 38,fontWeight: FontWeight.bold),
      ),
      body: Column(

//      mainAxisAlignment: MainAxisAlignment.center, // Center the content vertically
       crossAxisAlignment: CrossAxisAlignment.center, // Center the content horizontally
        children: [
//          SizedBox(height: 20,),
//          selected_weeks(),
//          SizedBox(height: 50,),
          Text(
              'Horses',
              style: TextStyle(
                fontSize: 50,
              ),
            ),
        ShowHorse(),



        ],


      ));
  }


  Widget ShowHorse() {
    if (list.length < 1) {
      return Container();
    }
    return Expanded(
      child: Center(
        
        child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
            print("=========================================");
            print(list[index].name);
            return Column(
              children: [
               ShowHorseName(list[index].name, true),
               Container(
                child: list[index].name == show_flag ? ShowHorseDetail(list[index].name):Container(),
               ),
                SizedBox(height: 5),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget ShowHorseDetail(String name){
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemCount: list.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {

//        Shedule_modle model=list[index];
//        print(model.owner_name);
        
        return Column(children: [
          Row(
             
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  // Add code to handle deletion here
                  // For example: deleteEntry(model);
                },
              ),
//              MyText(txt: model.hourses.toString()+' HD', color: Colors.black, txtSize: 20),
              SizedBox(width: 10,),

              /*
              InkWell(
                  onTap: () {
                    Get.to(Appointment(shedule_modle: model, weekDay: dateTime,),transition: Transition.circularReveal,duration: Duration(seconds: 1));
                  },
                  child: MyText(txt: model.time.toString()+' - '+model.owner_name, color: Colors.black, txtSize: 20)),
              */
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  // Add code to handle deletion here
                  // For example: deleteEntry(model);
               },
              ),

            ],),
//          Text(model.reason)

        ],);

        },);
  }

   Widget ShowHorseName(String name,bool mode){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        Container(
          width: 30,height: 30,
          decoration: BoxDecoration(
            color: Colors.red,

          ),
          child: Center(child: MyText(txt: "1", color: Colors.black, txtSize: 20,fontWeight: FontWeight.bold)),

        ),
        SizedBox(width: 5,),
        SizedBox(

        width: 250,
        height: 30,
        child: Container(
          color: mode?Colors.grey:Colors.red,
          child: Padding(
            padding: const EdgeInsets.only(left: 30,right: 30),
            child: InkWell(
              onTap: () async{

//                if(dateTime.millisecondsSinceEpoch==weekDays[0].millisecondsSinceEpoch) {
//                  shedule_list_d1=await praf_handler.get_shedule_list(my_helper.shedule+dateTime.millisecondsSinceEpoch.toString());
//                  show_d1_list=!show_d1_list;
//                }
//                  show_detail[]
                show_flag = name;
                setState(() {

                });

              },
              child: Column(children: [

                MyText(txt: name, color: Colors.black, txtSize: 20),

              ],),
            ),
          ),
        ),                 
        ),
        SizedBox(width: 5,),
        Container(
          width: 30,height: 30,
          decoration: BoxDecoration(
            color: Colors.red,

          ),
          child: Center(child: IconButton(onPressed: () async{
/*             Get.to(Sheduling(weekDay: dateTime),transition: Transition.circularReveal,duration: Duration(seconds: 1))!.then((value) {
               if(value!=null)
                 {
                   getWeekDays();
                 }
             });*/

          }, icon: Icon(Icons.add,color: Colors.black,size: 20,))),

        ),
        Container(
          width: 30,height: 30,
          decoration: BoxDecoration(
            color: Colors.red,

          ),
          child: Center(child: IconButton(onPressed: () async{
/*             Get.to(Sheduling(weekDay: dateTime),transition: Transition.circularReveal,duration: Duration(seconds: 1))!.then((value) {
               if(value!=null)
                 {
                   getWeekDays();
                 }
             });*/

          }, icon: Icon(Icons.delete,color: Colors.black,size: 20,))),

        ),
        Container(
                width: 30,height: 30,
                decoration: BoxDecoration(
                  color: Colors.red,

                ),
                child: Center(child: IconButton(onPressed: () async{
      /*             Get.to(Sheduling(weekDay: dateTime),transition: Transition.circularReveal,duration: Duration(seconds: 1))!.then((value) {
                    if(value!=null)
                      {
                        getWeekDays();
                      }
                  });*/

                }, icon: Icon(Icons.send,color: Colors.black,size: 20,))),

            ),
      ],
    );
  }
/*
  Widget ShowDetailHorseName(DateTime dateTime,int hours,bool mode){
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        Container(
          width: 50,height: 50,
          decoration: BoxDecoration(
            color: Colors.red,

          ),
          child: Center(child: MyText(txt: hours.toString(), color: Colors.black, txtSize: 25,fontWeight: FontWeight.bold)),

        ),
        SizedBox(width: 5,),
        SizedBox(

        width: 200,
        child: Container(
          color: mode?Colors.grey:Colors.red,
          child: Padding(
            padding: const EdgeInsets.only(left: 30,right: 30),
            child: InkWell(
              onTap: () async{


                if(dateTime.millisecondsSinceEpoch==weekDays[0].millisecondsSinceEpoch) {
                  shedule_list_d1=await praf_handler.get_shedule_list(my_helper.shedule+dateTime.millisecondsSinceEpoch.toString());
                  show_d1_list=!show_d1_list;
                }

                setState(() {

                });

              },
              child: Column(children: [

                MyText(txt: DateFormat.EEEE().format(dateTime), color: Colors.black, txtSize: 20),
                MyText(txt: DateFormat.yMMMd().format(dateTime), color: Colors.black, txtSize: 20),



              ],),
            ),
          ),
        ),                 
        ),
        SizedBox(width: 5,),
        Container(
          width: 50,height: 50,
          decoration: BoxDecoration(
            color: Colors.red,

          ),
          child: Center(child: IconButton(onPressed: () async{
             Get.to(Sheduling(weekDay: dateTime),transition: Transition.circularReveal,duration: Duration(seconds: 1))!.then((value) {
               if(value!=null)
                 {
                   getWeekDays();
                 }
             });

          }, icon: Icon(Icons.add,color: Colors.black,size: 30,))),

        ),


      ],
    );
  }*/
   List<Horse_model> list=[];
  getList()async{

    list.clear();
    list=await praf_handler.get_horse_list(shedule_modle.owner_name+my_helper.all_horses);

    setState(() {

    });

  }
}
