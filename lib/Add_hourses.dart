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

class Add_hourses extends StatefulWidget {
  final Shedule_modle shedule_modle;
  final DateTime weekDay;
  const Add_hourses({super.key, required this.shedule_modle, required this.weekDay});

  @override
  State<Add_hourses> createState() => _Add_hoursesState(shedule_modle,weekDay);
}

class _Add_hoursesState extends State<Add_hourses> {
  final Shedule_modle shedule_modle;
  final DateTime weekDay;

  _Add_hoursesState(this.shedule_modle, this.weekDay);

  final name=TextEditingController(),year_born=TextEditingController(),age=TextEditingController();

  String yearBorn_String='';
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
                child: Center(child: MyText(txt:'Owner - '+ shedule_modle.owner_name, color: Colors.black, txtSize: 25,fontWeight: FontWeight.bold)),
              ),
            ),

            SizedBox(height: 20,),
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

            SizedBox(height: 20,),

            My_Btn(txt: 'Add', btn_color: Colors.red, btn_size: 200, gestureDetector: GestureDetector(onTap: () async{


              bool? permissionsGranted = await Telephony.instance.requestPhoneAndSmsPermissions;
              if(!permissionsGranted!)
                {
                  EasyLoading.showError('give permisson');
                  return;
                }
              Horse_model model=Horse_model(name: name.text, year_born: year_born.text, age: age.text,
                  owner_name: shedule_modle.owner_name, owner_nbr: shedule_modle.owner_phone);
              String s=jsonEncode(model.toJson());
              await praf_handler.add_list(my_helper.all_horses, s);

              getList();
              
            },)),


            Expanded(
              child: Container(
                width: double.infinity,
                color: Colors.grey,
                child: Padding(
                  padding: const EdgeInsets.only(left: 40,right: 40,top: 10,bottom: 10),
                  child: Column(
                    children: [
                      MyText(txt: 'Other Horses', color: Colors.black, txtSize: 25,fontWeight: FontWeight.bold,),
                      SizedBox(height: 10,),
                      list_view(),


                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10,),
            My_Btn(txt: 'Save', btn_color: Colors.red, btn_size: 200, gestureDetector: GestureDetector(onTap: () {
              Navigator.pop(context,true);
            },)),



          ],


        ),
      ),
    );
  }

  calculateAge(DateTime birthDate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
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
             title: InkWell(
               onTap: () {
                 Get.to(Horse_info(shedule_modle: shedule_modle, horse_model: list[index]));
               },
                 child: MyText(txt: list[index].name, color: Colors.red, txtSize: 20)),
             trailing: IconButton(onPressed: () async{
               await praf_handler.del_list_item(shedule_modle.owner_name+shedule_modle.owner_phone, index);

               getList();
             }, icon: Icon(Icons.delete)),
           );


          },),
    );
  }

  List<Horse_model> list=[];
  getList()async{

    list.clear();
    list=await praf_handler.get_horse_list(my_helper.all_horses);
    setState(() {

    });

  }


}
