import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hourses/Add_comment.dart';
import 'package:hourses/Add_hourses.dart';
import 'package:hourses/helper/My_Button.dart';
import 'package:hourses/helper/My_Text.dart';
import 'package:hourses/helper/Praf_handler.dart';
import 'package:hourses/helper/my_helper.dart';
import 'package:hourses/model/Horse_model.dart';
import 'package:hourses/model/Shedule_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hourses/Owner_hourses.dart';
import 'package:hourses/helper/My_Text_Field.dart';
import 'package:age_calculator/age_calculator.dart';
import 'package:age_calculator/age_calculator.dart';
import 'package:intl/intl.dart';
import 'package:telephony/telephony.dart';
import 'package:hourses/Add_comment.dart';

class Appointment extends StatefulWidget {
  final Shedule_modle shedule_modle;
  final DateTime weekDay;
  const Appointment({super.key, required this.shedule_modle, required this.weekDay});

  @override
  State<Appointment> createState() => _AppointmentState(shedule_modle,weekDay);
}

class _AppointmentState extends State<Appointment> {
  final Shedule_modle shedule_modle;
  final DateTime weekDay;
  final name=TextEditingController(),year_born=TextEditingController(),age=TextEditingController();

  String yearBorn_String='';

  _AppointmentState(this.shedule_modle, this.weekDay);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        backgroundColor: Colors.red,
        title: MyText(txt: shedule_modle.owner_name, color: Colors.white, txtSize: 38,fontWeight: FontWeight.bold),
      ),

      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          children: [
            /*
            SizedBox(height: 40,),
            Container(
              width: double.infinity,
              color: Colors.grey,
              child: Padding(
                padding: const EdgeInsets.only(left: 40,right: 40,top: 10,bottom: 10),
                child: Center(child: MyText(txt: shedule_modle.owner_name, color: Colors.black, txtSize: 25,fontWeight: FontWeight.bold)),
              ),
            ),
*/
            SizedBox(height: 20,),
            
            Container(
              width: double.infinity,
              color: const Color.fromARGB(255, 239, 57, 57),
              child: Padding(
                padding: const EdgeInsets.only(left: 40,right: 40,top: 10,bottom: 10),
                child: Row(children: [
                  MyText(txt: DateFormat('M-d-yyyy').format(weekDay), color: Colors.black, txtSize: 25,fontWeight: FontWeight.bold),
                  Spacer(),
                  MyText(txt: list.length.toString()+' hd', color: Colors.black, txtSize: 25,fontWeight: FontWeight.bold),
                ],),
              ),
            ),

            SizedBox(height: 20,),

           Expanded(
              child: Container(
                width: double.infinity,
                color: const Color.fromARGB(255, 239, 57, 57),
                child: Padding(
                  padding: const EdgeInsets.only(left: 40,right: 40,top: 10,bottom: 10),
                  child: Column(
                    children: [
//                      MyText(txt: 'Current Horses', color: Colors.black, txtSize: 25,fontWeight: FontWeight.bold,),
//                      SizedBox(height: 10,),
                      list_view_appointment(),
                      SizedBox(height: 10,),
/*
                      My_Btn(txt: 'Add', btn_color: Colors.red, btn_size: 200, gestureDetector: GestureDetector(onTap: () {

                        Get.to(Owner_hourses(shedule_modle: shedule_modle, weekDay: weekDay, added_horses: list_appointment,)
                            ,transition: Transition.circularReveal,duration: Duration(seconds: 1))!.then((value) {
                          if(value!=null)
                          getList_appointment();
                        });
                      },)),
*/
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 5,),
            /*
            My_Btn(txt: 'Call', btn_color: Colors.green, btn_size: 200, gestureDetector: GestureDetector(onTap: () async{

              var url = Uri.parse("tel:"+shedule_modle.owner_phone);
              await launchUrl(url);
             


            },)),
            SizedBox(height: 5,),
            My_Btn(txt: 'Message', btn_color: Colors.green, btn_size: 200, gestureDetector: GestureDetector(onTap: () async{
              var url = Uri.parse('sms:'+shedule_modle.owner_phone+'?body=hello%20there');
              await launchUrl(url);
            },)),
          */
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
                              print("inkwell=========================2");
                              getList_appointment();

//                              Navigator.pop(context,true);
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
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Add Horses'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Add your form fields here
//                        MyTextField(controller: nameController, label: 'Horse Name'),
                         Container(
                            width: double.infinity,
                            color: Colors.grey,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 40,right: 40,top: 10,bottom: 10),
                              child: Column(children: [

                                My_Text_Field(controler: name, label: 'Hourse Name'),
                                SizedBox(height: 10,),

                                TextButton(onPressed: () async{

                                  DateTime? picked_time=await showDatePicker(context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1990), lastDate: DateTime(2025));

                                  if(picked_time!=null){

                                    yearBorn_String=DateFormat.yMd().format(picked_time);

                                    // Find out your age as of today's date 2021-03-08
                                    DateDuration duration = AgeCalculator.age(picked_time);
                                    print('Your age is $duration');

                                    age.text=duration.toString();

                                    setState(() {

                                    });

                                  }


                                }, child: Text('Year born $yearBorn_String',style: TextStyle(color: Colors.black),)),
                                SizedBox(height: 10,),
                                My_Text_Field(controler: age, label: 'Age'),
                                SizedBox(height: 10,),

                              ],),
                            ),
                          ),
                      ],
                    ),
                    actions: <Widget>[
                      ElevatedButton(
                        onPressed: () async{
                          // Your 'Add' functionality here
                          // You can access the entered data using nameController.text and ageController.text
                          // Perform your data validation and saving logic here
                          // Then close the dialog
                            bool? permissionsGranted = await Telephony.instance.requestPhoneAndSmsPermissions;
                          if(!permissionsGranted!)
                            {
                              EasyLoading.showError('give permisson');
                              return;
                            }
                          Horse_model model=Horse_model(name: name.text, year_born: year_born.text, age: age.text,
                              owner_name: shedule_modle.owner_name, owner_nbr: shedule_modle.owner_phone);
                          String s=jsonEncode(model.toJson());
                          await praf_handler.add_list(shedule_modle.owner_name+my_helper.all_horses, s);

                          getList();
                          Navigator.of(context).pop();
                        },
                        child: Text('Add'),
                      ),
                      TextButton(
                        onPressed: () {
                          // Close the dialog
                          Navigator.of(context).pop();
                        },
                        child: Text('Cancel'),
                      ),
                    ],
                  );
                },
              ).then((value) {
                if (value != null) {
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
    getList_appointment();
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
//                 Navigator.pop(context,true);
                 getList_appointment();
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
  
    if(list_appointment.length>0) {
      Future.forEach(list_appointment, (element) {
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
    list=await praf_handler.get_horse_list(shedule_modle.owner_name+my_helper.all_horses);

    setState(() {

    });

  }


  Widget list_view_appointment(){

    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
          itemCount: list_appointment.length,
          itemBuilder: (context, index) {

           return ListTile(
            
             leading: MyText(txt: (index+1).toString(), color: Colors.black, txtSize: 20),
             title: MyText(txt: list_appointment[index].name, color: Colors.black, txtSize: 20),
             trailing: IconButton(onPressed: () async{
               await praf_handler.del_list_item(shedule_modle.owner_name+shedule_modle.owner_phone+weekDay.millisecondsSinceEpoch.toString(), index);

               getList_appointment();
             }, icon: Icon(Icons.delete)),
               onTap: () async{

                Get.to(Add_comment(shedule_modle: shedule_modle, weekDay: weekDay),transition: Transition.circularReveal,duration: Duration(seconds: 1))!.then((value) {
                if(value!=null)
                  {
                    getList();
                  }
              });

             },
           );


          },),
    );
  }

  List<Horse_model> list_appointment=[];
  getList_appointment()async{

    print("FOOL");
    list_appointment.clear();
    list_appointment=await praf_handler.get_horse_list(shedule_modle.owner_name+shedule_modle.owner_phone+weekDay.millisecondsSinceEpoch.toString());
    setState(() {

    });

  }

}
