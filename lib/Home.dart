import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:horse/Appointment.dart';
import 'package:horse/Date_added_horse.dart';
import 'package:horse/OwnerPage.dart';
import 'package:horse/Setting.dart';
import 'package:horse/Shedulaining.dart';
import 'package:horse/helper/My_Button.dart';
import 'package:horse/helper/My_Methods.dart';
import 'package:horse/helper/My_Text.dart';
import 'package:horse/helper/Praf_handler.dart';
import 'package:horse/helper/my_helper.dart';
import 'package:horse/helper/notifi_service.dart';
import 'package:horse/model/Shedule_model.dart';
import 'package:intl/intl.dart';
import 'package:telephony/telephony.dart';
import 'package:horse/Appointment.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:horse/OwnerPage.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Contact ?contact;

  DateTime selected_date = DateTime.now();
  bool show_d1_list = false, show_d2_list = false, show_d3_list = false, show_d4_list = false,
       show_d5_list = false, show_d6_list = false, show_d7_list = false;
  List<Shedule_modle> shedule_list_d1 = [], shedule_list_d2 = [], shedule_list_d3 = [],
      shedule_list_d4 = [], shedule_list_d5 = [], shedule_list_d6 = [], shedule_list_d7 = [];
  int selected_week = 1;
  List<DateTime> weekDays = [];
  int d1h = 0, d2h = 0, d3h = 0, d4h = 0, d5h = 0, d6h = 0, d7h = 0;
  bool d1m = true, d2m = true, d3m = true, d4m = true, d5m = true, d6m = true, d7m = true;
  int w1 = 1, w2 = 2, w3 = 3, week_showing = 1;
  int full=0;
  List<int> horse_num =    List<int>.filled(7, 0);
  getWeekDays() async{
    weekDays=await my_Methods.get_days_in_week(selected_date,week_showing);

    d1h=await praf_handler.get_int(my_helper.hourse+weekDays[0].millisecondsSinceEpoch.toString());
    d2h=await praf_handler.get_int(my_helper.hourse+weekDays[1].millisecondsSinceEpoch.toString());
    d3h=await praf_handler.get_int(my_helper.hourse+weekDays[2].millisecondsSinceEpoch.toString());
    d4h=await praf_handler.get_int(my_helper.hourse+weekDays[3].millisecondsSinceEpoch.toString());
    d5h=await praf_handler.get_int(my_helper.hourse+weekDays[4].millisecondsSinceEpoch.toString());
    d6h=await praf_handler.get_int(my_helper.hourse+weekDays[5].millisecondsSinceEpoch.toString());
    d7h=await praf_handler.get_int(my_helper.hourse+weekDays[6].millisecondsSinceEpoch.toString());
    horse_num[0]=d1h;
    horse_num[1]=d2h;
    horse_num[2]=d3h;
    horse_num[3]=d4h;
    horse_num[4]=d5h;
    horse_num[5]=d6h;
    horse_num[6]=d7h;

    d1m=await praf_handler.get_bool(my_helper.day_mode+weekDays[0].millisecondsSinceEpoch.toString());
    d2m=await praf_handler.get_bool(my_helper.day_mode+weekDays[1].millisecondsSinceEpoch.toString());
    d3m=await praf_handler.get_bool(my_helper.day_mode+weekDays[2].millisecondsSinceEpoch.toString());
    d4m=await praf_handler.get_bool(my_helper.day_mode+weekDays[3].millisecondsSinceEpoch.toString());
    d5m=await praf_handler.get_bool(my_helper.day_mode+weekDays[4].millisecondsSinceEpoch.toString());
    d6m=await praf_handler.get_bool(my_helper.day_mode+weekDays[5].millisecondsSinceEpoch.toString());
    d7m=await praf_handler.get_bool(my_helper.day_mode+weekDays[6].millisecondsSinceEpoch.toString());
    setState(() {});
  }

  getSelectedWeeks() async{
    w1=await praf_handler.get_int(my_helper.w1);
    if(w1==0) w1=1;
    w2=await praf_handler.get_int(my_helper.w2);
    if(w2==0) w2=2;
    w3=await praf_handler.get_int(my_helper.w3);
    if(w3==0) w3=3;
    selected_week=w1;
    week_showing= 1;
    getWeekDays();
    setState(() {});
  }
  init_value() async{
  show_d1_list = false; show_d2_list = false; show_d3_list = false; show_d4_list = false;
       show_d5_list = false; show_d6_list = false; show_d7_list = false;
    shedule_list_d1 = []; shedule_list_d2 = []; shedule_list_d3 = [];
      shedule_list_d4 = []; shedule_list_d5 = []; shedule_list_d6 = []; shedule_list_d7 = [];

   }

  @override
  void initState() {
    super.initState();

    String selected_date1 = DateFormat('yyyy-MM-dd 00:00:00.000').format(selected_date);
    selected_date = DateFormat('yyyy-MM-dd 00:00:00.000').parse(selected_date1);

    getSelectedWeeks();
    getWeekDays();
  }

  Widget selected_weeks(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: () async{
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: selected_date, // Use selectedDate as the initial date
              firstDate: DateTime(1990),
              lastDate: DateTime(2025),
            );
            if (pickedDate != null) {
              selected_date = pickedDate;
              week_showing=1;
              selected_week=1;
              show_d1_list=false;
              show_d2_list=false;
              show_d3_list=false;
              show_d4_list=false;
              show_d5_list=false;
              show_d6_list=false;
              show_d7_list=false;
              getWeekDays();

              //Not sure
              setState(() {});
            }        
          },
          child: Icon(Icons.apps,size: 30,),
        ),
        InkWell(
          onTap: () {
            week_showing=week_showing-selected_week;
            show_d1_list=false;
            show_d2_list=false;
            show_d3_list=false;
            show_d4_list=false;
            show_d5_list=false;
            show_d6_list=false;
            show_d7_list=false;
            getWeekDays();
          },
          child: Icon(Icons.arrow_back,size: 50,),
        ),
        SizedBox(width: 20,),
        Container(
          width: 50,height: 50,
          decoration: BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle
          ),
          child: Center(
            child: InkWell(
              child: MyText(txt: w1.toString(), color: selected_week==w1?Colors.white: Colors.black, txtSize: 20,fontWeight: FontWeight.bold),
              onTap: () {
                selected_week=w1;
                setState(() {});
              },
            )
          )
        ),
        SizedBox(width: 5,),
        Container(
          width: 50,height: 50,
          decoration: BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle
          ),
          child: Center(
            child: InkWell(
              child: MyText(txt: w2.toString(), color:selected_week==w2?Colors.white: Colors.black, txtSize: 20,fontWeight: FontWeight.bold),
              onTap: () {
                selected_week=w2;
                setState(() {});
              },
            )
          ),
        ),
        SizedBox(width: 5,),
        Container(
          width: 50,height: 50,
          decoration: BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle
          ),
          child: Center(
            child: InkWell(
              child: MyText(txt: w3.toString(), color:selected_week==w3?Colors.white: Colors.black, txtSize: 20,fontWeight: FontWeight.bold),
              onTap: () {
                selected_week=w3;
                setState(() {});
              }
            )
          ),
        ),
        SizedBox(width: 20,),
        InkWell(
          child: Icon(Icons.arrow_forward, size : 50),
          onTap: () {
            week_showing=selected_week+week_showing;
            show_d1_list=false;
            show_d2_list=false;
            show_d3_list=false;
            show_d4_list=false;
            show_d5_list=false;
            show_d6_list=false;
            show_d7_list=false;
            getWeekDays();

            //Not sure
            setState(() {});
          }
        ),
        InkWell(
          child: Icon(Icons.calendar_today,size: 30,),
          onTap: () {
            week_showing=1;
            selected_week=1;
            selected_date  = DateTime.now();
            String selected_date1 = DateFormat('yyyy-MM-dd 00:00:00.000').format(selected_date);
            selected_date = DateFormat('yyyy-MM-dd 00:00:00.000').parse(selected_date1);            
            show_d1_list=false;
            show_d2_list=false;
            show_d3_list=false;
            show_d4_list=false;
            show_d5_list=false;
            show_d6_list=false;
            show_d7_list=false;
            getWeekDays();

            //Not sure
            setState(() {});
          }
        ),
      ],
    );
  }

  Widget week_days(){
    if(weekDays.length < 1) return Container();
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            days_view(weekDays[0], d1h, d1m,0),
            Container(
              child: show_d1_list ? days_list_view(shedule_list_d1,weekDays[0],0) : Container(),
            ),
            SizedBox(height: 5),
            days_view(weekDays[1], d2h, d2m,1),
            Container(
              child: show_d2_list ? days_list_view(shedule_list_d2,weekDays[1],1) : Container(),
            ),
            SizedBox(height: 5),
            days_view(weekDays[2], d3h, d3m,2),
            Container(
              child: show_d3_list ? days_list_view(shedule_list_d3,weekDays[2],2) : Container(),
            ),
            SizedBox(height: 5),
            days_view(weekDays[3], d4h, d4m,3),
            Container(
              child: show_d4_list ? days_list_view(shedule_list_d4,weekDays[3],3) : Container(),
            ),
            SizedBox(height: 5),
            days_view(weekDays[4], d5h, d5m,4),
            Container(
              child: show_d5_list?days_list_view(shedule_list_d5,weekDays[4],4):Container(),
            ),
            SizedBox(height: 5),
            days_view(weekDays[5], d6h, d6m,5),
            Container(
              child: show_d6_list?days_list_view(shedule_list_d6,weekDays[5],5):Container(),
            ),
            SizedBox(height: 5),
            days_view(weekDays[6], d7h, d7m,6),
            Container(
              child: show_d7_list ? days_list_view(shedule_list_d7,weekDays[6],6) : Container(),
            ),
            SizedBox(height: 5),
          ],
        ),
      ),
    );
  }

  Widget days_view(DateTime dateTime,int hours,bool mode,int index_num){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.red
          ),
          width: 30,
          height: 30,
          child: Center(child: MyText(txt: (horse_num[index_num]).toString(), color: Colors.black, txtSize: 20,fontWeight: FontWeight.bold)),
        ),
        SizedBox(width: 5,),
        SizedBox(
          width: 200,
          child: Container(
            color: mode ? Colors.grey : Colors.red,
            child: Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: InkWell(
                child: Column(
                  children: [
                    MyText(txt: DateFormat.EEEE().format(dateTime), color: Colors.black, txtSize: 15),
                    MyText(txt: DateFormat.yMMMd().format(dateTime), color: Colors.black, txtSize: 15),
                  ],
                ),
                onTap: () async{

                  if(dateTime.millisecondsSinceEpoch==weekDays[0].millisecondsSinceEpoch) {
                    shedule_list_d1=await praf_handler.get_shedule_list(my_helper.shedule+dateTime.millisecondsSinceEpoch.toString());
                    show_d1_list=!show_d1_list;
                  }else if(dateTime.millisecondsSinceEpoch==weekDays[1].millisecondsSinceEpoch) {
                    shedule_list_d2=await praf_handler.get_shedule_list(my_helper.shedule+dateTime.millisecondsSinceEpoch.toString());
                    show_d2_list=!show_d2_list;
                  }else if(dateTime.millisecondsSinceEpoch==weekDays[2].millisecondsSinceEpoch) {
                    shedule_list_d3=await praf_handler.get_shedule_list(my_helper.shedule+dateTime.millisecondsSinceEpoch.toString());
                    show_d3_list=!show_d3_list;
                  }else if(dateTime.millisecondsSinceEpoch==weekDays[3].millisecondsSinceEpoch) {
                    shedule_list_d4=await praf_handler.get_shedule_list(my_helper.shedule+dateTime.millisecondsSinceEpoch.toString());
                    show_d4_list=!show_d4_list;
                  }else if(dateTime.millisecondsSinceEpoch==weekDays[4].millisecondsSinceEpoch) {
                    shedule_list_d5=await praf_handler.get_shedule_list(my_helper.shedule+dateTime.millisecondsSinceEpoch.toString());
                    show_d5_list=!show_d5_list;
                  }else if(dateTime.millisecondsSinceEpoch==weekDays[5].millisecondsSinceEpoch) {
                    shedule_list_d6=await praf_handler.get_shedule_list(my_helper.shedule+dateTime.millisecondsSinceEpoch.toString());
                    show_d6_list=!show_d6_list;
                  }else if(dateTime.millisecondsSinceEpoch==weekDays[6].millisecondsSinceEpoch) {
                    shedule_list_d7=await praf_handler.get_shedule_list(my_helper.shedule+dateTime.millisecondsSinceEpoch.toString());
                    show_d7_list=!show_d7_list;
                  }

                  setState(() {});
                },
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
          child: Center(
            child: IconButton(
              icon: Icon(Icons.add,color: Colors.black,size: 15,),
              onPressed: () async{
                Get.to(Sheduling(weekDay: dateTime, edit_value: false),transition: Transition.circularReveal,duration: Duration(seconds: 1))!.then((value) async {
                  if(value!=null)
                    {
                     int h=await praf_handler.get_int(my_helper.hourse+dateTime.millisecondsSinceEpoch.toString());
                     print(my_helper.hourse+dateTime.millisecondsSinceEpoch.toString());
                      print("mother");
                      print(h);
                    setState((){
                      horse_num[index_num]=h;
                      hours=h;                     
                      print(horse_num[index_num]);
//                      print(horse_num);
                      print(index_num);
                      print("===mother===");
                      print(horse_num[index_num]);
                    });
                    init_value();
                    getWeekDays();
//                      init_value();                     
                    }
                });
              }, 
            )
          ),
        ),
      ],
    );
  }

  Widget days_list_view(List<Shedule_modle> list,DateTime dateTime,int index_h){
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemCount: list.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          Shedule_modle model=list[index];
          return 
          Container(
            width: 200,            
            child:Column(              
              children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async{  
                    await praf_handler.del_list_item_from_schedule(my_helper.shedule+ dateTime.millisecondsSinceEpoch.toString(), index);
                    int hours;
                      hours=await praf_handler.get_int(my_helper.hourse+dateTime.millisecondsSinceEpoch.toString());
                      hours-=model.horse;
                      praf_handler.set_int(my_helper.hourse+dateTime.millisecondsSinceEpoch.toString(), hours);
                      
                      setState(() {
                        if (index >= 0 && index < list.length) {
                          list.removeAt(index);
                        }
                        horse_num[index_h]=hours;
                      });
  //                    init_value();
  //                    getWeekDays();
                    },
                  ),

                  InkWell(
                      onTap: () {
                        Get.to(
                          Appointment(
                            shedule_modle: model,
                            weekDay: dateTime,
                          ),
                          transition: Transition.circularReveal,
                          duration: Duration(seconds: 1),
                        );
                      },
                      child: RichText(
                        text: TextSpan(
                          text: model.time.toString() + '-',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: model.owner_name,
                              style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  Container(
                    width: 45,
                    padding: EdgeInsets.zero,
                    alignment: Alignment.centerRight,
                    child: MyText(
                      txt: '-' + model.horse.toString() + ' hd',
                      color: Colors.black,
                      txtSize: 15,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () async{
                      await praf_handler.del_list_item_from_schedule(my_helper.shedule+ dateTime.millisecondsSinceEpoch.toString(), index);
                      int hours;
                      hours=await praf_handler.get_int(my_helper.hourse+dateTime.millisecondsSinceEpoch.toString());
                      hours-=model.horse;
                      praf_handler.set_int(my_helper.hourse+dateTime.millisecondsSinceEpoch.toString(), hours);                    
                      Get.to(Sheduling(weekDay: dateTime, edit_value:true),transition: Transition.circularReveal,duration: Duration(seconds: 1))!.then((value) async{
                        if(value!=null){
                        int h=await praf_handler.get_int(my_helper.hourse+dateTime.millisecondsSinceEpoch.toString());
                        print(my_helper.hourse+dateTime.millisecondsSinceEpoch.toString());
                          print("mother");
                          print(h);
                        setState((){
                          horse_num[index_h]=h;
                          hours=h;                     
                          print(horse_num[index_h]);
    //                      print(horse_num);
                          print(index_h);
                          print("===mother===");
                          print(horse_num[index_h]);
                        });  
                        init_value();
                          getWeekDays();
                        }
                      });
                    },
                  ),
                ],
              ),
              Text(model.reason)
            ],)
          );
        },
      );
  }

  @override
  Widget build(BuildContext context) {

    int hours = 0;
    
     void updateHours(int newHours) {
    setState(() {
      hours = newHours;
    });
  }
    return Scaffold(
      backgroundColor: my_helper.backgroundColor,
      /*
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: MyText(txt: 'Home', color: Colors.white, txtSize: 18,fontWeight: FontWeight.bold),
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
          if (index == 2) {
            Get.to(Setting())!.then((value) {
              if(value!=null)
                {
                  getSelectedWeeks();
                  getWeekDays();                  
                }
            });
          }
<<<<<<< HEAD
          if (index == 1)
          {
              contact=await FlutterContactPicker().selectContact();
=======
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
            } else {
              // Handle the case where contact is null
              // For example: show an error message or take alternative action
            }
             
            /*
            Get.to(Con())!.then((value) {
              if(value!=null)
                {
                  getSelectedWeeks();
                  getWeekDays();                  
                }
            });*/
>>>>>>> tmp
          }
        },
        ),      */
      body: Column(
        children: [
          SizedBox(height: 20),
          selected_weeks(),
          SizedBox(height: 50),
          week_days(),
          /*
          My_Btn(txt: 'Setting', btn_color: Colors.red, btn_size: 100, gestureDetector: GestureDetector(onTap: () async{
            Get.to(Setting())!.then((value) {
              if(value!=null)
                {
                  getSelectedWeeks();
                  getWeekDays();
                }
            });
          },),txt_color: Colors.white),
          SizedBox(height: 30,),
          */
        ],
      )
    );
  }
}
