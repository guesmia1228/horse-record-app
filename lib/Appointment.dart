import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:horse/Add_comment.dart';
import 'package:horse/Add_horse.dart';
import 'package:horse/helper/My_Button.dart';
import 'package:horse/helper/My_Text.dart';
import 'package:horse/helper/Praf_handler.dart';
import 'package:horse/helper/my_helper.dart';
import 'package:horse/model/Horse_model.dart';
import 'package:horse/model/Shedule_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:horse/Owner_horse.dart';
import 'package:horse/helper/My_Text_Field.dart';
import 'package:age_calculator/age_calculator.dart';
import 'package:age_calculator/age_calculator.dart';
import 'package:intl/intl.dart';
import 'package:telephony/telephony.dart';
import 'package:horse/Add_comment.dart';
import 'package:horse/Setting.dart';
import 'package:horse/Home.dart';
import 'package:horse/OwnerPage.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';

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
  TextEditingController dateController = TextEditingController(text: DateFormat.yMd().format(DateTime.now()));

  final name=TextEditingController(),year_born=TextEditingController(),age=TextEditingController();

  String yearBorn_String='';
    Contact ?contact;
  DateTime selectedDate=DateTime.now();
  int _selectedIndex=1;
  _AppointmentState(this.shedule_modle, this.weekDay);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        backgroundColor: Colors.red,
        title: MyText(txt: shedule_modle.owner_name, color: Colors.white, txtSize: 20,fontWeight: FontWeight.bold),
      ),
       bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'Owners',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
            
          ],
           currentIndex: _selectedIndex,
          onTap: (int index) async{
         if(index==0)
          {
            Get.to(Home())!.then((value){

            });
          }      
          if (index == 2) {
            Get.to(Setting())!.then((value) {
              if(value!=null)
                {
                }
            });
          }
       if (index == 1) {
             contact=await FlutterContactPicker().selectContact();
    
             if (contact != null) {
              Get.to(OwnerPage(contact: contact!))!.then((value) {
                if (value != null) {
                  // Perform additional actions here based on the returned value
                  // For example:
                  // getSelectedWeeks();
                  // getWeekDays(); 
                }
              });
            }
       
        }}
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
              color: Color.fromARGB(255, 49, 43, 225),
              child: Padding(
                padding: const EdgeInsets.only(left: 40,right: 40,top: 10,bottom: 10),
                child: Row(children: [
                  MyText(txt: DateFormat('M-d-yyyy').format(weekDay), color: Colors.black, txtSize: 20,fontWeight: FontWeight.bold),
                  Spacer(),
                  MyText(txt: list_appointment.length.toString()+'/', color: Colors.black, txtSize: 20,fontWeight: FontWeight.bold),
                  MyText(txt: shedule_modle.horse.toString()+' hd', color: Colors.black, txtSize: 20,fontWeight: FontWeight.bold),
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

                        Get.to(Owner_horse(shedule_modle: shedule_modle, weekDay: weekDay, added_horses: list_appointment,)
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
                        //      print("inkwell=========================2");
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

                                My_Text_Field(controler: name, label: 'Horse Name'),
                                SizedBox(height: 10,),


                                  TextFormField(
                                  readOnly: true,
                                  controller: dateController,
                                  onTap: () async {
                                    DateTime selectedDate1 = DateTime.now(); // Initialize selectedDate with today's date

                                    DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: selectedDate1, // Use selectedDate as the initial date
                                      firstDate: DateTime(1990),
                                      lastDate: DateTime(2025),
                                    );

                                    if (pickedDate != null) {
                                      // Update selectedDate with the picked date
                                      selectedDate = pickedDate;

                                      String selectedYear = DateFormat('yyyy').format(selectedDate);

                                      String formattedDate = '01-01-' + selectedYear;
                                      // Set the selected date in the TextFormField
                                      dateController.text = formattedDate;

                                      yearBorn_String=DateFormat.yMd().format(pickedDate);

                                      // Find out your age as of today's date 2021-03-08
                                      DateDuration duration = AgeCalculator.age(pickedDate);
                             //         print('Your age is $duration');

                                      age.text='${duration.years + 1}';

                                      setState(() {

                                      });

                                      // Find out the age based on today's date
                                      setState(() {});
                                    }
                                  }
                                ),   

                            
                                  SizedBox(height: 10,),
                                TextFormField(
                                    controller: age, // The controller for the age text field
                                    decoration: InputDecoration(
                                      labelText: 'Age', // The label for the age text field
                                    ),
                                    onChanged: (value) { // Event handler for when the value of the age field changes
                                      if (value.isNotEmpty) { // Check if the value is not empty
                                        int enteredAge = int.tryParse(value) ?? 0; // Convert the entered value to an integer or default to 0
                                        DateTime today = DateTime.now(); // Get the current date
                                        int currentYear = today.year; // Extract the current year
                                        int birthYear = currentYear - enteredAge + 1; // Calculate the birth year based on the entered age
                                        String formattedDate = '01-01-$birthYear'; // Format the birth date as '01-01-YYYY'
                                        dateController.text = formattedDate; // Set the birth date in the date text field
                                      }
                                    },
                                  ),
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
                          /*
                            bool? permissionsGranted = await Telephony.instance.requestPhoneAndSmsPermissions;
                          if(!permissionsGranted!)
                            {
                              EasyLoading.showError('give permisson');
                              return;
                            }*/
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

            Center(  child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 26), 
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: My_Btn(
                          txt: 'Call',
                          btn_color: Colors.green,
                          btn_size: 160,
                          gestureDetector: GestureDetector(
                            onTap: () async {
                              var url = Uri.parse("tel:"+shedule_modle.owner_phone);
                              await launchUrl(url);
                            },
                          ),
                        ),
                      ),
                      SizedBox(width: 8), // Adjust the spacing between the buttons as needed
                      Expanded(
                        child: My_Btn(
                          txt: 'Message',
                          btn_color: Colors.green,
                          btn_size: 160,
                          gestureDetector: GestureDetector(
                            onTap: () async {
                              var url = Uri.parse('sms:'+shedule_modle.owner_phone+'?body=%20');
                              await launchUrl(url);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ))
      
          

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
              //   print("fooo================");
           //      print(weekDay.millisecondsSinceEpoch.toString());
//                 Navigator.pop(context,true);
                 getList_appointment();
               }  

             },
             leading: MyText(txt: (index+1).toString(), color: Colors.black, txtSize: 20),
             title: SizedBox(
                width: double.infinity,  // Ensure the title takes the remaining space
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align the components horizontally
                  crossAxisAlignment: CrossAxisAlignment.center, // Center align vertically
                  children: <Widget>[
                    MyText(txt: list[index].name, color: Colors.red, txtSize: 20),
                    MyText(txt: list[index].age + " years", color: Colors.blue, txtSize: 20),
                  ],
                ),
              ),
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
               setState(() {
                  if (index >= 0 && index < list_appointment.length) {
                          list_appointment.removeAt(index);
                        }
               });
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

   // print("FOOL");
    list_appointment.clear();
    list_appointment=await praf_handler.get_horse_list(shedule_modle.owner_name+shedule_modle.owner_phone+weekDay.millisecondsSinceEpoch.toString());
    setState(() {

    });

  }

}
