import 'dart:convert';

import 'package:age_calculator/age_calculator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:record/record.dart';
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
import 'package:hourses/Horse_cmnts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hourses/model/Horse_coment_model.dart';
import 'package:hourses/model/Horse_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
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
  TextEditingController dateController = TextEditingController(text: DateFormat.yMd().format(DateTime.now()));
  void initState() {
    // TODO: implement initState
    super.initState();
    getList();
//    getHistoryList();
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

  final record = AudioRecorder();

  Widget ShowHorse() {
    print("=================RS+++++++++++++++++++++++++");
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
               ShowHorseName(index,list[index].name, true),
               Container(
                child: list[index].name == show_flag ? ShowHorseDetail(list[index].name):Container(),
     //           shedule_list_d1=await praf_handler.get_shedule_list(list[index].name);
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
    print("mmm"+name);
//    getHistoryList();
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),  
      itemCount: my_cmnts_list.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {

//        Shedule_modle model=list[index];
//        print(model.owner_name);
          Horse_cmnt_model model=my_cmnts_list[index];

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
                  praf_handler.del_list_item(name, index);
//                  ShowHorse();
                  setState(() {
                       if (index >= 0 && index < my_cmnts_list.length) {
                        my_cmnts_list.removeAt(index);
                      }
                  });
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
//              MyText(txt: my_cmnts_list.toString()+' HD', color: Colors.black, txtSize: 20),

                MyText(txt: DateFormat.yMMMd().format(DateTime.fromMillisecondsSinceEpoch(model.time_of_cmnt)), color: Colors.purple, txtSize: 18),
              InkWell(
                onTap: () async{
                  Get.to(Horse_cmnts(list: my_cmnts_list, pos: index,));
                },
                child: Icon(Icons.attach_file,color: Colors.black,)),
    
             
            ],),
//          Text(model.reason)

        ],);

        },);
  }
  bool recording=false;
  final cmnt=TextEditingController();
  DateTime selectedDate=DateTime.now();
  XFile? xfile;

   Widget ShowHorseName(int index, String name,bool mode){
    print("name=====================name");
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [

        Container(
          width: 30,height: 30,
          decoration: BoxDecoration(
            color: Colors.red,

          ),
          child: Center(child: MyText(txt: (index+1).toString(), color: Colors.black, txtSize: 20,fontWeight: FontWeight.bold)),

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
                my_cmnts_list=await praf_handler.get_horse_cmnr(show_flag);

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
                          padding: const EdgeInsets.only(left: 40, right: 40, top: 10, bottom: 10),
                          child: Column(
                            children: [
                              // My_Text_Field(controler: name, label: 'Horse Name'),
                              SizedBox(height: 20),
                                My_Text_Field(controler: cmnt, label: 'Add Comment'),
                              SizedBox(height: 20),
                           


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

                                    String formattedDate = DateFormat.yMd().format(selectedDate);

                                    // Set the selected date in the TextFormField
                                    dateController.text = formattedDate;

                                    // Find out the age based on today's date
                                    setState(() {});
                                  }
                                }
                              ),   
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                                            

                         Row(children: [

                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: My_Btn(txt: 'Upload Picture', btn_color: Colors.red, btn_size: 200, gestureDetector: GestureDetector(onTap: () async{

                                    xfile=await ImagePicker().pickImage(source: ImageSource.gallery);
                                   
                                  },)),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: My_Btn(txt: 'Upload MP3', btn_color: Colors.red, btn_size: 200, gestureDetector: GestureDetector(onTap: () async{

                                    FilePickerResult? res=await FilePicker.platform.pickFiles();
                                    if(res!=null)
                                    {
                                      Horse_cmnt_model horse_cmnt_model=Horse_cmnt_model(cmnt: cmnt.text, img: res.files.single.path!, owner_name: shedule_modle.owner_name,
                                          time_of_cmnt: DateTime.now().millisecondsSinceEpoch, img_picked: false);
//                                      praf_handler.add_list(horse_model.name+horse_model.age, jsonEncode(horse_cmnt_model.toJson()));
                                      praf_handler.add_list(name, jsonEncode(horse_cmnt_model.toJson()));

                                      EasyLoading.showSuccess('added');
                                      Future.delayed(Duration(seconds: 1)).then((value) => getHistoryList());

                                    }
                                  },)),
                                ),
                              ),
                            ],),


                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: My_Btn(txt: recording?'Stop':'start recording', btn_color: Colors.red, btn_size: 200, gestureDetector: GestureDetector(onTap: () async{

                                if(!await record.hasPermission()){
                                  EasyLoading.showError('give permission');
                                  return;
                                }


                                if(recording){

                                  final path = await record.stop();
                                  record.dispose();
                                  showDialog(context: context,
                                      builder: (context) {
                                        return AlertDialog(title: Text('Save'),actions: [
                                          TextButton(onPressed: () {
                                            Navigator.pop(context);
                                          }, child: Text('No')),
                                          TextButton(onPressed: () {
                                            Horse_cmnt_model horse_cmnt_model=Horse_cmnt_model(cmnt: cmnt.text, img: path!, owner_name: shedule_modle.owner_name,
                                                time_of_cmnt: selectedDate.millisecondsSinceEpoch, img_picked: false);
//                                            praf_handler.add_list(horse_model.name+horse_model.age, jsonEncode(horse_cmnt_model.toJson()));
                                            praf_handler.add_list(name, jsonEncode(horse_cmnt_model.toJson()));
                                            
                                            EasyLoading.showSuccess('added');
                                            Navigator.pop(context);
                                            Future.delayed(Duration(seconds: 1)).then((value) => getHistoryList());
                                          }, child: Text('YES'))
                                        ],);
                                      },);
                                  recording=false;
                                  setState(() {

                                  });
                                }
                                else{

                                  try{

                                    final directory = await getApplicationDocumentsDirectory();
                                    final path = '${directory.path}/myFile.mp3';

                                    await record.start(const RecordConfig(), path: path);
                                    EasyLoading.showSuccess('speak');
                                    recording=true;
                                    setState(() {

                                    });
                                  }
                                  catch(error){
                                    print('samak'+error.toString());
                                  }


                                }




                              },)),
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
                         if(xfile!=null)
                                    {
                                      print(selectedDate);
/*                                      Horse_cmnt_model horse_cmnt_model=Horse_cmnt_model(cmnt: cmnt.text, img: xfile.path, owner_name: shedule_modle.owner_name,
                                          time_of_cmnt: DateTime.now().millisecondsSinceEpoch, img_picked: true);
                                      praf_handler.add_list(horse_model.name+horse_model.age, jsonEncode(horse_cmnt_model.toJson()));*/
                                     Horse_cmnt_model horse_cmnt_model=Horse_cmnt_model(cmnt: cmnt.text,  img: xfile?.path ?? '', owner_name: name,
                                          time_of_cmnt: selectedDate.millisecondsSinceEpoch, img_picked: true);
                                      praf_handler.add_list(name, jsonEncode(horse_cmnt_model.toJson()));
                                      EasyLoading.showSuccess('added');
//                                      Future.delayed(Duration(seconds: 1)).then((value) => getHistoryList());
                                    }                          
                            bool? permissionsGranted = await Telephony.instance.requestPhoneAndSmsPermissions;
                          if(!permissionsGranted!)
                            {
                              EasyLoading.showError('give permisson');
                              return;
                            }
//                          Horse_model model=Horse_model(name: name.text, year_born: year_born.text, age: age.text,
  //                            owner_name: shedule_modle.owner_name, owner_nbr: shedule_modle.owner_phone);
//                          String s=jsonEncode(model.toJson());
//                          await praf_handler.add_list(shedule_modle.owner_name+my_helper.all_horses, s);

                          getHistoryList();
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

  List<Horse_cmnt_model> my_cmnts_list=[];

  getHistoryList()async{

    my_cmnts_list.clear();
//    my_cmnts_list=await praf_handler.get_horse_cmnr(horse_model.name+horse_model.age);
    my_cmnts_list=await praf_handler.get_horse_cmnr(show_flag);

    setState(() {

    });
  }
}
