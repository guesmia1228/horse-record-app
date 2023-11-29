import 'dart:convert';

//import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:get/get.dart';
import 'package:horse/helper/My_Button.dart';
import 'package:horse/helper/My_Text.dart';
import 'package:horse/helper/Praf_handler.dart';
import 'package:horse/helper/my_helper.dart';
import 'package:horse/model/Shedule_model.dart';
import 'package:intl/intl.dart';
import 'package:horse/Setting.dart';
import 'package:horse/Home.dart';
import 'package:horse/model/Shedule_model1.dart';
import 'package:horse/OwnerPage.dart';


class Sheduling extends StatefulWidget {
  final DateTime weekDay;
  final bool edit_value;
  const Sheduling({super.key, required this.weekDay, required this.edit_value});
  @override
  State<Sheduling> createState() => _ShedulingState(weekDay,edit_value);
}

class _ShedulingState extends State<Sheduling> {
      Contact ?contact;

  final DateTime weekDay;
  bool edit_value;
  _ShedulingState(this.weekDay,this.edit_value);
  bool alert_on=true;

  String fixed_digital_time='09:30 AM';

  getFixedDigitalTime()async{
    int t=await praf_handler.get_int(my_helper.fixed_digital_time);
    if(t>0){

      DateTime dt=DateTime.fromMillisecondsSinceEpoch(t);
      set_digital_time(dt.hour, dt.minute);
    }
    else
     set_digital_time(9, 30);
   // print('fixed '+fixed_digital_time);
    setState(() {

    });
  }

  set_digital_time(int h,int m){

    manual_selected_shedule_time=DateTime(weekDay.year,weekDay.month,weekDay.day,h,m);

    fixed_digital_time=DateFormat('hh:mm a').format(manual_selected_shedule_time);
    setState(() {

    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getFixedDigitalTime();
  }

  // 1 for normal and 2 for busy
  int mode=1;
  var reason=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
             appBar: AppBar(
        backgroundColor: Colors.red,
        title: MyText(txt: "Appointment", color: Colors.white, txtSize: 30,fontWeight: FontWeight.bold),
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
           currentIndex: 0,
          onTap: (int index) async{
          if(index==0)
          {
            Get.to(Home())!.then((value){

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
       
        }
          if (index == 2) {
            Get.to(Setting())!.then((value) {
              if(value!=null)
                {
//                  getSelectedWeeks();
//                  getWeekDays();   
                }
            });
          }
        },
        ),

      body: SingleChildScrollView(
        child: Column(children: [

          Center(
            child:mode==2?Container(): My_Btn(txt: 'Owner Search', btn_color: Colors.grey, btn_size: 300, gestureDetector: GestureDetector(onTap: () async{

              
               contact=await FlutterContactPicker().selectContact();
              setState(() {
                
              });  
            },),txt_color: Colors.black),
          ),

          SizedBox(height: 10,),

          Text('Select Mode'),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

            RadioMenuButton(value: 1, groupValue: mode, onChanged: (value) {
              setState(() {
                mode=value!;
              });
            }, child: Text("Normal")),

            RadioMenuButton(value: 2, groupValue: mode, onChanged: (value) {
              setState(() {
                mode=value!;
              });
            }, child: Text("Busy")),

          ],),

        //        MyText(txt: DateFormat.yMMMd().format(weekDay), color: Colors.purple, txtSize: 18),
    Container(
              width: double.infinity,
              color: Color.fromARGB(255, 109, 106, 213),              
              child: Padding(
                padding: const EdgeInsets.only(left: 40,right: 40,top: 10,bottom: 10),
                child: Row(children: [
                  MyText(txt: DateFormat('M-d-yyyy').format(weekDay), color: Colors.black, txtSize: 20,fontWeight: FontWeight.bold),
                  Spacer(),
                  if(contact!=null)
                    MyText(txt: contact!.fullName!.toString(), color: Colors.black, txtSize: 20,fontWeight: FontWeight.bold),
                ],),
              ),
            ),    
           Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: double.infinity,
              color: Colors.black,
              child: Center(child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: MyText(txt: 'Time', color: Colors.white, txtSize: 20,fontWeight: FontWeight.bold),
              )),
            ),
          ),
          grid_time(),
        
          mode==2?Container():Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: double.infinity,
              color: Colors.black,
              child: Center(child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: MyText(txt: '# of Horses', color: Colors.white, txtSize: 20,fontWeight: FontWeight.bold),
              )),
            ),
          ),
//          SizedBox(height: 10,),

          grid_horse(),
//          SizedBox(height: 10,),
          Row(children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: My_Btn(txt:alert_on? 'Alert On':'Alert Off', btn_color: Colors.pink, btn_size: 000, gestureDetector: GestureDetector(onTap: () {

                  DateTime d=DateTime.now();
                  d=d.add(Duration(seconds: 10));

                  alert_on=!alert_on;
                  setState(() {

                  });

                },)),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: My_Btn(txt: edit_value? 'Change':'Submit', btn_color: Colors.yellow, btn_size: 00, gestureDetector: GestureDetector(onTap: () async{


                  if(mode==2){
                    Shedule_modle model=Shedule_modle(horse: 0, time: fixed_digital_time,
                        owner_name: '',
                        owner_phone:'',
                         alert_on: alert_on, reason: reason.text, shedule_time: manual_selected_shedule_time.millisecondsSinceEpoch);

                    String s=jsonEncode(model.toJson());
                    
                    praf_handler.add_list_sort(my_helper.shedule+weekDay.millisecondsSinceEpoch.toString(), s,"Schedule");

                    Shedule_model1 model1=Shedule_model1(horse: 0, date:weekDay.toIso8601String(), time: fixed_digital_time,
                        owner_name: '',
                        owner_phone:'',
                         alert_on: alert_on, reason: reason.text, shedule_time: manual_selected_shedule_time.millisecondsSinceEpoch);

                    String s1=jsonEncode(model1.toJson());
           //         await praf_handler.add_list(my_helper.shedule_total, s1);

                      print("another====fool====");
//                      print(my_helper.shedule_total,s1);
                    // int h=await praf_handler.get_int(my_helper.hourse+weekDay.millisecondsSinceEpoch.toString());
                    //
                    // h=h+horse;
                    //
                    // praf_handler.set_int(my_helper.hourse+weekDay.millisecondsSinceEpoch.toString(), h);
                    praf_handler.set_bool(my_helper.day_mode+weekDay.millisecondsSinceEpoch.toString(),
                        mode==1?true:false);

                    Navigator.pop(context,true);

                  }
                  else{
                    if(contact!=null) {
                      Shedule_modle model=Shedule_modle(horse: horse, time: fixed_digital_time, owner_name: contact!.fullName!.toString(),
                          owner_phone: contact!.phoneNumbers![0],
                          alert_on: alert_on, reason: reason.text, shedule_time: manual_selected_shedule_time.millisecondsSinceEpoch);


                      String s=jsonEncode(model.toJson());
                      praf_handler.add_list_sort(my_helper.shedule+weekDay.millisecondsSinceEpoch.toString(), s,"Schedule");
                //      print("another====fool====");
              //        print(my_helper.shedule+weekDay.millisecondsSinceEpoch.toString());
                      int h=await praf_handler.get_int(my_helper.hourse+weekDay.millisecondsSinceEpoch.toString());

                      h=h+horse;

 
                     await praf_handler.set_int(my_helper.hourse+weekDay.millisecondsSinceEpoch.toString(), h);
             //         print(my_helper.hourse+weekDay.millisecondsSinceEpoch.toString());


                     Shedule_model1 model1=Shedule_model1(horse: h, date:weekDay.toIso8601String(), time: fixed_digital_time,
                        owner_name: '',
                        owner_phone:'',
                         alert_on: alert_on, reason: reason.text, shedule_time: manual_selected_shedule_time.millisecondsSinceEpoch);

                    String s1=jsonEncode(model1.toJson());
                    await praf_handler.add_list_sort(my_helper.shedule_total, s1,"Schedule");
                    //   print(await praf_handler.get_int(my_helper.hourse+weekDay.millisecondsSinceEpoch.toString()));
                      await praf_handler.set_bool(my_helper.day_mode+weekDay.millisecondsSinceEpoch.toString(),
                          mode==1?true:false);

                      Navigator.pop(context,true);

                    }
                    else{
                      EasyLoading.showError('select owner');
                    }
                  }

                  
                },),txt_color: Colors.black),
              ),
            ),

          ],)
        ],),
      ),
    );
  }
  int selectedTime=1,mnt=00;
  bool am_select=false,pm_select=false;

  String manual_selected_time='';
  DateTime manual_selected_shedule_time=DateTime.now();

  Widget grid_time(){
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Column(
        children: [

          GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 12,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,crossAxisSpacing: 5,mainAxisSpacing: 5

            ),
            itemBuilder: (context, index) {

              return InkWell(
                onTap: () {
                  selectedTime=(index+1);

                  if(selectedTime<7){
                    pm_select=true;
                    am_select=false;
                    set_digital_time(selectedTime+12, mnt);
                  }
                  else{
                    am_select=true;
                    pm_select=false;
                    set_digital_time(selectedTime, mnt);
                  }

                  setState(() {

                  });
                },
                child: Container(

                  decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle
                  ),
                  child: Center(child: MyText(txt: (index+1).toString(), color: selectedTime==(index+1)?Colors.white:Colors.black, txtSize: 25,fontWeight: FontWeight.bold,)),
                ),
              );

            },),
          
          Row(children: [
           Expanded(
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle, // Make it a circle
                    color: Colors.yellow, // Set circle color to yellow
                  ),
                  padding: EdgeInsets.all(4), // Add padding to create space around the circle
                  child: TextButton(
                    onPressed: () {
                      am_select = true;
                      pm_select = false;
                      set_digital_time(selectedTime, mnt);
                      setState(() {});
                    },
                    child: Text(
                      'AM',
                      style: TextStyle(
                        color: am_select ? Colors.blue : Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Spacer(),
            InkWell(
              onTap: () {
                if(mnt==30)
                  mnt=0;
                else
                  mnt=30;
          //      print(selectedTime);
                if(selectedTime>=7) {
                    pm_select=false;
                    am_select=true;
                    set_digital_time(selectedTime, mnt);
                  }else{
                  pm_select=true;
                  am_select=false;
                  set_digital_time(selectedTime+12, mnt);

                }
                setState(() {

                });
              },
              child: Container(
                width: 50,height: 50,

                decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle
                ),
                child: Center(child: MyText(txt: '30', color: mnt==30?Colors.white:Colors.black, txtSize: 25,fontWeight: FontWeight.bold,)),
              ),
            ),
            Spacer(),
            Expanded(
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle, // Make it a circle
                    color: Colors.yellow, // Set circle color to yellow
                  ),
                  padding: EdgeInsets.all(4), // Add padding to create space around the circle
                  child: TextButton(
                    onPressed: () {
                      am_select = false;
                      pm_select = true;
                      set_digital_time(selectedTime + 12, mnt);
                      setState(() {});
                    },
                    child: Text(
                      'PM',
                      style: TextStyle(
                        color: pm_select ? Colors.blue : Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],),


          TextButton(onPressed: () async{

            TimeOfDay? time=await showTimePicker(context: context,
                initialTime: TimeOfDay.now());
            if(time!=null)
              {

                final now = new DateTime.now();
                final dt= DateTime(now.year, now.month, now.day, time.hour, time.minute);
                set_digital_time(dt.hour, dt.minute);
                setState(() {

                });
         //       print(DateFormat('hh:mm a').format(dt));
              }

          },
              child: Text(fixed_digital_time)),

          mode==1?Container():Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: reason,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                labelText: 'Reason'
              ),
            ),
          )


        ],

      ),
    );
  }
  int horse=1;
  Widget grid_horse(){
    return mode==2?Container():Padding(
      padding: const EdgeInsets.all(2.0),
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: 18,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,crossAxisSpacing: 5,mainAxisSpacing: 5

          ),
          itemBuilder: (context, index) {

          return InkWell(
            onTap: () {
              horse=(index+1);
              setState(() {

              });
            },
            child: Container(

              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle
              ),
              child: Center(child: MyText(txt: (index+1).toString(), color: horse==(index+1)?Colors.white:Colors.black, txtSize: 25,fontWeight: FontWeight.bold,)),
            ),
          );

          },),
    );
  }

}

