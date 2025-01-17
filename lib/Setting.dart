import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:horse/Home.dart';
import 'package:horse/Report.dart';
import 'package:horse/ReportHorse.dart';
import 'package:horse/ReportSchedule.dart';
import 'package:horse/ReportScheduleSent.dart';
import 'package:horse/helper/My_Button.dart';
import 'package:horse/helper/My_Text.dart';
import 'package:horse/helper/Praf_handler.dart';
import 'package:horse/helper/my_helper.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:horse/OwnerPage.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  Contact ?contact;
  final w1=TextEditingController(),w2=TextEditingController(),w3=TextEditingController();
  
  String fixed_digital_time='09:30 AM';

  getFixedDigitalTime()async{
    int t=await praf_handler.get_int(my_helper.fixed_digital_time);
   // print(t);
    if(t>0)
      fixed_digital_time=DateFormat('hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(t));

   // print('fixed '+fixed_digital_time);
    setState(() {

    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getFixedDigitalTime();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: MyText(txt: 'Setting', color: Colors.white, txtSize: 18),
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
           currentIndex: 2,
          onTap: (int index) async{
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
       
        }
         if(index==0)
          {
            Get.to(Home())!.then((value){

            });
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
        child: Column(
          children: [


            week_days(),

            shedule_alert(),

            SizedBox(height: 10,),


            TextButton(onPressed: () async{

              TimeOfDay? time=await showTimePicker(context: context,
                  initialTime: TimeOfDay.now());
              if(time!=null)
              {

                final now = new DateTime.now();
                final dt= DateTime(now.year, now.month, now.day, time.hour, time.minute);
                fixed_digital_time=DateFormat('hh:mm a').format(dt);
                praf_handler.set_int(my_helper.fixed_digital_time, dt.millisecondsSinceEpoch);
          //      print(dt.millisecondsSinceEpoch);
                setState(() {

                });
           //     print(DateFormat('hh:mm a').format(dt));
              }

            },
                child: Text(fixed_digital_time)),

            noti(),

          ],
        ),
      ),
    );
  }
  Widget week_days(){
    return Column(children: [
      SizedBox(height: 10,),
      Center(child: MyText(txt: 'Enter Week days', color: Colors.black, txtSize: 20)),
      SizedBox(height: 10,),

      Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: w1,
                decoration: InputDecoration(
                    hintText: 'week 1'
                ),
                keyboardType: TextInputType.number,

              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: w2,
                decoration: InputDecoration(
                    hintText: 'week 2'
                ),
                keyboardType: TextInputType.number,

              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: w3,
                decoration: InputDecoration(
                    hintText: 'week 3'
                ),
                keyboardType: TextInputType.number,

              ),
            ),
          ),
        ],
      ),

      SizedBox(height: 30,),
      My_Btn(txt: 'Save', btn_color: Colors.red, btn_size: 200, gestureDetector: GestureDetector(onTap: () {

        if(w1.text.isEmpty||w2.text.isEmpty||w3.text.isEmpty){
          EasyLoading.showError('fill all the fields');
        }
        else{
          praf_handler.set_int(my_helper.w1, int.parse(w1.text));
          praf_handler.set_int(my_helper.w2, int.parse(w2.text));
          praf_handler.set_int(my_helper.w3, int.parse(w3.text));
          EasyLoading.showSuccess('saved');
//          Home();
            Get.to(Home())!.then((value){

            });
//           Navigator.pushReplacementNamed(context, '/home'); // 
//          Navigator.pop(context,true);
        }

      },),txt_color: Colors.white,),

  
    ],);
  }



  var day_before=TextEditingController(),hour_before=TextEditingController();
  Widget shedule_alert(){
    return Column(children: [
      SizedBox(height: 20,),
      Center(child: MyText(txt: 'Alert', color: Colors.black, txtSize: 20)),
      SizedBox(height: 10,),

      Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: day_before,
                decoration: InputDecoration(
                    labelText: 'Days before'
                ),
                keyboardType: TextInputType.number,

              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: hour_before,
                decoration: InputDecoration(
                    labelText: 'Minute before'
                ),
                keyboardType: TextInputType.number,

              ),
            ),
          ),

        ],
      ),

      SizedBox(height: 30,),
      My_Btn(txt: 'Save', btn_color: Colors.red, btn_size: 200, gestureDetector: GestureDetector(onTap: () {

        if(day_before.text.isEmpty||hour_before.text.isEmpty){
          EasyLoading.showError('fill all the fields');
        }
        else{
          praf_handler.set_int(my_helper.day_before, int.parse(day_before.text));
          praf_handler.set_int(my_helper.hour_before, int.parse(hour_before.text));
          EasyLoading.showSuccess('saved');
           Get.to(Home())!.then((value){

            });
//          Navigator.pop(context,true);
        }

      },),txt_color: Colors.white,)

    ],);
  }
  var noti_txt=TextEditingController();
  var month_txt = TextEditingController();  
  int noti_time=1;// 1 for year 2 for month 3 for day
  Widget noti(){
    return Column(children: [
      SizedBox(height: 20,),
      Center(child: MyText(txt: 'Alert', color: Colors.black, txtSize: 20)),
      SizedBox(height: 10,),

      Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: noti_txt,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                    labelText: 'Alert text'
                ),
              ),
            ),
          ),


        ],
      ),

      SizedBox(height: 10,),
       Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: month_txt,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                    labelText: 'months'
                ),
              ),
            ),
          ),
        ],
      ),


      SizedBox(height: 30,),
      My_Btn(txt: 'Save', btn_color: Colors.red, btn_size: 200, gestureDetector: GestureDetector(onTap: () {

        if(noti_txt.text.isEmpty){
          EasyLoading.showError('fill all the fields');
        }
        else{

          DateTime dt=DateTime.now();
//          dt=dt.add(Duration(days: noti_time));
          String monthTxt = month_txt.text;  // Assuming monthTxtController is your TextEditingController
          int month = int.tryParse(monthTxt) ?? 0;
          dt= DateTime(dt.year, dt.month + month , 1, 1 , 9 ,0 );
      //    print(dt);

          praf_handler.set_int(my_helper.noti_duration, dt.millisecondsSinceEpoch);
          praf_handler.set_int(my_helper.noti_time, noti_time);
          praf_handler.set_string(my_helper.noti_txt, noti_txt.text);
          EasyLoading.showSuccess('saved');
   Get.to(Home())!.then((value){

            });          
//          Navigator.pop(context,true);
        }

      },),txt_color: Colors.white,),


      SizedBox(height: 10,),
      Center(child: MyText(txt: 'Report', color: Colors.black, txtSize: 30)),
      SizedBox(height: 10,),


      GestureDetector(
          onTap: () {
            Get.to(Report())!.then((value) {});
          },
          child: Text(
            'Report with scheduled time',
            style: TextStyle(
              decoration: TextDecoration.underline,
              color: Colors.blue,
              fontSize: 20,              
            ),
          ),
        ),
      SizedBox(height: 10,),

    
     GestureDetector(
          onTap: () {
            Get.to(ReportHorse())!.then((value) {});
          },
          child: Text(
            'Report with attachment',
            style: TextStyle(
              decoration: TextDecoration.underline,
              color: Colors.blue,
              fontSize: 20,              
            ),
          ),
        ),
      SizedBox(height: 10,),

        GestureDetector(
          onTap: () {
            Get.to(ReportSchedule())!.then((value) {});
          },
          child: Text(
            'Scheduled Notification',
            style: TextStyle(
              decoration: TextDecoration.underline,
              color: Colors.blue,
              fontSize: 20,              
            ),
          ),
        ),
      SizedBox(height: 10,),

       GestureDetector(
          onTap: () {
            Get.to(ReportScheduleSent())!.then((value) {});
          },
          child: Text(
            'Sent Notification',
            style: TextStyle(
              decoration: TextDecoration.underline,
              color: Colors.blue,
              fontSize: 20,              
            ),
          ),
        ),
      SizedBox(height: 10,),
    ],);

    
  }
}
