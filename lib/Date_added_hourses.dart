import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hourses/Owner_hourses.dart';
import 'package:hourses/helper/My_Button.dart';
import 'package:hourses/helper/My_Text.dart';
import 'package:hourses/helper/Praf_handler.dart';
import 'package:hourses/model/Horse_model.dart';
import 'package:hourses/model/Shedule_model.dart';
import 'package:url_launcher/url_launcher.dart';

class Date_added_hourses extends StatefulWidget {
  final Shedule_modle shedule_modle;
  final DateTime weekDay;
  const Date_added_hourses({super.key, required this.shedule_modle, required this.weekDay});

  @override
  State<Date_added_hourses> createState() => _Date_added_hoursesState(shedule_modle,weekDay);
}

class _Date_added_hoursesState extends State<Date_added_hourses> {
  final Shedule_modle shedule_modle;
  final DateTime weekDay;

  _Date_added_hoursesState(this.shedule_modle, this.weekDay);

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
                child: MyText(txt:'Phone - ' +shedule_modle.owner_phone, color: Colors.black, txtSize: 20,fontWeight: FontWeight.bold),
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
                      MyText(txt: 'Current Horses', color: Colors.black, txtSize: 25,fontWeight: FontWeight.bold,),
                      SizedBox(height: 10,),
                      list_view(),
                      SizedBox(height: 10,),
                      My_Btn(txt: 'Add', btn_color: Colors.red, btn_size: 200, gestureDetector: GestureDetector(onTap: () {

                        Get.to(Owner_hourses(shedule_modle: shedule_modle, weekDay: weekDay, added_horses: list,)
                            ,transition: Transition.circularReveal,duration: Duration(seconds: 1))!.then((value) {
                          if(value!=null)
                          getList();
                        });
                      },)),

                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 5,),
            My_Btn(txt: 'Call', btn_color: Colors.green, btn_size: 200, gestureDetector: GestureDetector(onTap: () async{

              var url = Uri.parse("tel:"+shedule_modle.owner_phone);
              await launchUrl(url);
             


            },)),
            SizedBox(height: 5,),
            My_Btn(txt: 'Message', btn_color: Colors.green, btn_size: 200, gestureDetector: GestureDetector(onTap: () async{
              var url = Uri.parse('sms:'+shedule_modle.owner_phone+'?body=hello%20there');
              await launchUrl(url);
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

  Widget list_view(){

    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
          itemCount: list.length,
          itemBuilder: (context, index) {

           return ListTile(
            
             leading: MyText(txt: (index+1).toString(), color: Colors.black, txtSize: 20),
             title: MyText(txt: list[index].name, color: Colors.red, txtSize: 20),
             trailing: IconButton(onPressed: () async{
               await praf_handler.del_list_item(shedule_modle.owner_name+shedule_modle.owner_phone+weekDay.millisecondsSinceEpoch.toString(), index);

               getList();
             }, icon: Icon(Icons.delete)),
           );

          },),
    );
  }

  List<Horse_model> list=[];
  getList()async{

    list.clear();
    list=await praf_handler.get_horse_list(shedule_modle.owner_name+shedule_modle.owner_phone+weekDay.millisecondsSinceEpoch.toString());
    setState(() {

    });

  }
}
