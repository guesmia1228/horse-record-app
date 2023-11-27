import 'dart:convert';

import 'package:age_calculator/age_calculator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:record/record.dart';
import 'package:horse/Horse_info.dart';
import 'package:horse/helper/My_Button.dart';
import 'package:horse/helper/My_Text.dart';
import 'package:horse/helper/My_Text_Field.dart';
import 'package:horse/helper/Praf_handler.dart';
import 'package:horse/helper/my_helper.dart';
import 'package:horse/model/Horse_model.dart';
import 'package:horse/model/Shedule_model.dart';
import 'package:intl/intl.dart';
import 'package:telephony/telephony.dart';
import 'package:horse/Horse_cmnts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:horse/model/Horse_coment_model.dart';
import 'package:horse/model/Horse_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:horse/Setting.dart';
import 'package:horse/Home.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:url_launcher/url_launcher.dart';

class OwnerPage extends StatefulWidget {
  final Contact? contact;
  const OwnerPage({required this.contact});

  @override
  State<OwnerPage> createState() => _OwnerPageState(contact!);
}

class _OwnerPageState extends State<OwnerPage> {
  final Contact contact;

  _OwnerPageState(this.contact);

  String yearBorn_String='';
  String show_flag= '';
   Shedule_modle ?shedule_modle;
  DateTime ?weekDay;
  String record_path = '';
  int record_flag = 1;
  String buttonTitle = "RRS";
  TextEditingController dateController = TextEditingController(text: DateFormat.yMd().format(DateTime.now()));

  final name=TextEditingController(),year_born=TextEditingController(),age=TextEditingController();

//  DateTime selectedDate=DateTime.now();
  @override
  TextEditingController dateController_age = TextEditingController(text: DateFormat.yMd().format(DateTime.now()));
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
        title: MyText(txt: contact!.fullName!.toString(), color: Colors.white, txtSize: 20,fontWeight: FontWeight.bold),
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
           currentIndex: 1,
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
                  Home();
//                  getSelectedWeeks();
//                  getWeekDays();   
                }
            });
          }
        },
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
                        //              print('Your age is $duration');

                                      age.text='${duration.years}';

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
                              owner_name: contact!.fullName!.toString(), owner_nbr: contact!.phoneNumbers![0].toString());
                          String s=jsonEncode(model.toJson());
                          await praf_handler.add_list(contact!.fullName!.toString()+my_helper.all_horses, s);

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
        ShowHorse(),
      Center(  child: Padding(
    padding: EdgeInsets.symmetric(horizontal: 16), 
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
                    var url = Uri.parse("tel:"+contact!.phoneNumbers![0].toString());
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
                    var url = Uri.parse('sms:'+contact!.phoneNumbers![0].toString()+'?body=%20');
                    await launchUrl(url);
                  },
                ),
              ),
            ),
          ],
        ),
      ))]



      ));
  }

  final record = AudioRecorder();

  Widget ShowHorse() {
   // print("=================RS+++++++++++++++++++++++++");
    if (list.length < 1) {
      return Container();
    }
    return Expanded(
      child: Center(
        
        child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) {
      //      print("=========================================");
      //      print(list[index].name);

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
   // print("mmm"+name);
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
//              MyText(txt: model.horse.toString()+' HD', color: Colors.black, txtSize: 20),
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
  FilePickerResult? res;
   Widget ShowHorseName(int index, String name,bool mode){
   // print("name=====================name");
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

                 SizedBox(
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
                builder: (context) {
                  bool recording = false;
                  return StatefulBuilder(builder:(context, setState) {
             return AlertDialog(
                    
                    title: Text('Add Comment'),
                    content:  Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Add your form fields here
//                        MyTextField(controller: nameController, label:z'Horse Name'),
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
                                  child: My_Btn(txt: 'Picture', btn_color: Colors.red, btn_size: 200, gestureDetector: GestureDetector(onTap: () async{

                                    xfile=await ImagePicker().pickImage(source: ImageSource.gallery);
                                    record_flag=1;
                                  },)),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: My_Btn(txt: 'MP3', btn_color: Colors.red, btn_size: 200, gestureDetector: GestureDetector(onTap: () async{

                                    res=await FilePicker.platform.pickFiles();
                                    record_flag=3;                                   
                                  },)),
                                ),
                              ),

                           
                              Expanded(child: Padding(
                               padding: const EdgeInsets.all(8.0),
                              // ignore: dead_code
                              child: My_Btn(txt: recording? "Stop":"Record", btn_color: Colors.red, btn_size: 200, gestureDetector: GestureDetector(onTap: () async{
                                
                                if(!await record.hasPermission()){
                                  EasyLoading.showError('give permission');
                                  return;
                                }


                                if(recording){
                                  
                                    setState(() {
                                      recording=!recording;
//                                      buttonTitle = 'Start Recording';
                               //       print(buttonTitle);
                            //          print(recording);
                                    });
                                  final path = await record.stop();
                                  record.dispose();
                                  showDialog(context: context,
                                      builder: (context) {
                                        return AlertDialog(title: Text('Save'),actions: [
                                          TextButton(onPressed: () {
                                            Navigator.pop(context);
                                          }, child: Text('No')),
                                          TextButton(onPressed: () {
                                            record_flag=2;
                                            
/*                                            Horse_cmnt_model horse_cmnt_model=Horse_cmnt_model(cmnt: cmnt.text, img: record_path!, owner_name: shedule_modle.owner_name,
                                                time_of_cmnt: selectedDate.millisecondsSinceEpoch, img_picked: 2);
//                                            praf_handler.add_list(horse_model.name+horse_model.age, jsonEncode(horse_cmnt_model.toJson()));
                                            praf_handler.add_list(name, jsonEncode(horse_cmnt_model.toJson()));
                                            
                                            EasyLoading.showSuccess('added');
                                            Navigator.pop(context);
                                            Future.delayed(Duration(seconds: 1)).then((value) => getHistoryList());*/
                                          }, child: Text('YES'))
                                        ],);
                                      },);
 
                                    
                                }
                                else{
                                    setState(() {
                                      recording=!recording;

//                                      recording=true;                                      
//                                      buttonTitle = 'Stop Recording';
                         //             print(buttonTitle);
                           //           print(recording);

                                    });

                                  try{

                                    final directory = await getApplicationDocumentsDirectory();
 //                                   final path = '${directory.path}/myFile.mp3';
                                    final path = '${directory.path}/myFile_${DateTime.now().millisecondsSinceEpoch}.mp3';
                                    await record.start(const RecordConfig(), path: path);
                                    record_path=path;
                                    EasyLoading.showSuccess('speak');
                                  }
                                  catch(error){
                    //                print('samak'+error.toString());
                                  }


                                }

                            


                              },)), 
                              ),)
                            ],),


                      /*      Padding(
                                                          
                           
                            ),*/

                      ],
                    ),
                    actions: <Widget>[
                      ElevatedButton(
                        onPressed: () async{
                          // Your 'Add' functionality here
                          // You can access the entered data using nameController.text and ageController.text
                          // Perform your data validation and saving logic here
                          // Then close the dialog
                          if(record_flag==2)
                          {
                                Horse_cmnt_model horse_cmnt_model=Horse_cmnt_model(cmnt: cmnt.text, img: record_path!, owner_name: name,
                                                time_of_cmnt: selectedDate.millisecondsSinceEpoch, img_picked: record_flag);
//                                            praf_handler.add_list(horse_model.name+horse_model.age, jsonEncode(horse_cmnt_model.toJson()));
                                            praf_handler.add_list(name, jsonEncode(horse_cmnt_model.toJson()));
                                            
                                            EasyLoading.showSuccess('added');                          
                                record_flag=0;
                               xfile=null;
                                res=null;
                                record_path="";

                          }
                          else if(xfile!=null&& record_flag==1)
                          {
                               Horse_cmnt_model horse_cmnt_model=Horse_cmnt_model(cmnt: cmnt.text,  img: xfile?.path ?? '', owner_name: name,
                                          time_of_cmnt: selectedDate.millisecondsSinceEpoch, img_picked: 1);
                                      praf_handler.add_list(name, jsonEncode(horse_cmnt_model.toJson()));
                                      EasyLoading.showSuccess('added');
                                record_flag=0;
                               xfile=null;
                                res=null;
                                record_path="";

                          }
                          else if(res!=null && record_flag == 3)
                                    {
                                      Horse_cmnt_model horse_cmnt_model=Horse_cmnt_model(cmnt: cmnt.text, img: res?.files?.isNotEmpty == true ? res!.files.single.path! : "defaultPath", owner_name: name,
                                          time_of_cmnt: selectedDate.millisecondsSinceEpoch, img_picked: 2);
//                                      praf_handler.add_list(horse_model.name+horse_model.age, jsonEncode(horse_cmnt_model.toJson()));
                                      praf_handler.add_list(name, jsonEncode(horse_cmnt_model.toJson()));

                                      EasyLoading.showSuccess('added');
                                      Future.delayed(Duration(seconds: 1)).then((value) => getHistoryList());
                                record_flag=0;
                               xfile=null;
                                res=null;
                                record_path="";

                                    }
                         else
                         {
                                Horse_cmnt_model horse_cmnt_model=Horse_cmnt_model(cmnt: cmnt.text, img:  "defaultPath", owner_name: name,
                                          time_of_cmnt: selectedDate.millisecondsSinceEpoch, img_picked: 0);
//                                      praf_handler.add_list(horse_model.name+horse_model.age, jsonEncode(horse_cmnt_model.toJson()));
                                      praf_handler.add_list(name, jsonEncode(horse_cmnt_model.toJson()));

                                      EasyLoading.showSuccess('added');
                                      Future.delayed(Duration(seconds: 1)).then((value) => getHistoryList());
                                record_flag=0;
                               xfile=null;
                                res=null;
                                record_path="";

                         }     
                              
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
                  },);
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

        ),/*
        Container(
          width: 30,height: 30,
          decoration: BoxDecoration(
            color: Colors.red,

          ),
          child: Center(child: IconButton(onPressed: () async{
//            await praf_handler.del_list_item(shedule_modle.owner_name+my_helper.all_horses,index);

          }, icon: Icon(Icons.delete,color: Colors.black,size: 20,))),

        ),*/
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
    list=await praf_handler.get_horse_list(contact!.fullName!+my_helper.all_horses);

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
