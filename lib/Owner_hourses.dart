import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hourses/Add_hourses.dart';
import 'package:hourses/helper/My_Button.dart';
import 'package:hourses/helper/My_Text.dart';
import 'package:hourses/helper/Praf_handler.dart';
import 'package:hourses/helper/my_helper.dart';
import 'package:hourses/model/Horse_model.dart';
import 'package:hourses/model/Shedule_model.dart';

class Owner_hourses extends StatefulWidget {
  final Shedule_modle shedule_modle;
  final DateTime weekDay;
  final List<Horse_model> added_horses;
  const Owner_hourses({super.key, required this.shedule_modle, required this.weekDay, required this.added_horses});

  @override
  State<Owner_hourses> createState() => _Owner_hoursesState(shedule_modle,weekDay,added_horses);
}

class _Owner_hoursesState extends State<Owner_hourses> {
  final Shedule_modle shedule_modle;
  final DateTime weekDay;
  final List<Horse_model> added_horses;

  _Owner_hoursesState(this.shedule_modle, this.weekDay, this.added_horses);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          children: [
            SizedBox(height: 40,),
            Container(
              width: double.infinity,
              color: Colors.grey,
              child: Padding(
                padding: const EdgeInsets.only(left: 40,right: 40,top: 10,bottom: 10),
                child: Center(child: MyText(txt: shedule_modle.owner_name, color: Colors.black, txtSize: 25,fontWeight: FontWeight.bold)),
              ),
            ),

            SizedBox(height: 20,),
            Container(
              width: double.infinity,
              color: Colors.grey,
              child: Padding(
                padding: const EdgeInsets.only(left: 40,right: 40,top: 10,bottom: 10),
                child: Row(children: [
                  MyText(txt: shedule_modle.time, color: Colors.black, txtSize: 25,fontWeight: FontWeight.bold),
                  Spacer(),
                  MyText(txt: list.length.toString()+' Head', color: Colors.black, txtSize: 25,fontWeight: FontWeight.bold),
                ],),
              ),
            ),

            SizedBox(height: 20,),

            Expanded(
              child: Container(
                width: double.infinity,
                color: Colors.grey,
                child: Padding(
                  padding: const EdgeInsets.only(left: 40,right: 40,top: 10,bottom: 10),
                  child: Column(
                    children: [
                      MyText(txt: 'Horses', color: Colors.black, txtSize: 25,fontWeight: FontWeight.bold,),
                      SizedBox(height: 10,),
                      list_view(),

                      SizedBox(height: 10,),
                      
                      InkWell(
                        onTap: () async{
                          if(list.length>0)
                            {

                             await Future.forEach(list, (element) async{
                               bool b=await check_horse_already_added(element.name);
                               if(!b)
                                 {
                                   await praf_handler.add_list(shedule_modle.owner_name+shedule_modle.owner_phone+weekDay.millisecondsSinceEpoch.toString(),
                                       jsonEncode(element.toJson()));
                                 }
                              });

                              Navigator.pop(context,true);
                            }
                        },
                          child: MyText(txt: 'Selected All', color: Colors.black, txtSize: 20))

                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10,),
            My_Btn(txt: 'Add', btn_color: Colors.red, btn_size: 200, gestureDetector: GestureDetector(onTap: () {
              Get.to(Add_hourses(shedule_modle: shedule_modle, weekDay: weekDay),transition: Transition.circularReveal,duration: Duration(seconds: 1))!.then((value) {
                if(value!=null)
                  {
                    getList();
                  }
              });
            },)),



          ],


        ),
      ),
    );
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getList();
  }

  List<Horse_model> selected_horse=[];
  Widget list_view(){

    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
          itemCount: list.length,
          itemBuilder: (context, index) {


           return ListTile(
             onTap: () async{

               bool b=await check_horse_already_added(list[index].name);
               if(b)
                 {
                   EasyLoading.showError('already added');

                 }
               else
               {
                 await praf_handler.add_list(shedule_modle.owner_name+shedule_modle.owner_phone+weekDay.millisecondsSinceEpoch.toString(), jsonEncode(list[index].toJson()));
                 Navigator.pop(context,true);
               }

             },
             leading: MyText(txt: (index+1).toString(), color: Colors.black, txtSize: 20),
             title: MyText(txt: list[index].name, color: Colors.red, txtSize: 20),

           );


          },),
    );
  }

  check_horse_already_added(String name)async{
    bool exist=false;

    if(added_horses.length>0) {
      Future.forEach(added_horses, (element) {
        if (element.name == name) {
          exist = true;
        }
      });
    }

    return exist;

  }


  List<Horse_model> list=[];
  getList()async{

    list.clear();
    list=await praf_handler.get_horse_list(my_helper.all_horses);
    setState(() {

    });

  }


}
