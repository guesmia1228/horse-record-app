import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:horse/helper/My_Button.dart';
import 'package:horse/helper/My_Text_Field.dart';
import 'package:horse/helper/Praf_handler.dart';
import 'package:horse/model/Horse_coment_model.dart';
import 'package:horse/model/Horse_model.dart';
import 'package:horse/model/Shedule_model.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:horse/Horse_cmnts.dart';
import 'package:image_picker/image_picker.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

import 'helper/My_Text.dart';

class Horse_info extends StatefulWidget {

  final Shedule_modle shedule_modle;
  final Horse_model horse_model;

  const Horse_info({super.key, required this.shedule_modle, required this.horse_model});

  @override
  State<Horse_info> createState() => _Horse_infoState(shedule_modle,horse_model);
}

class _Horse_infoState extends State<Horse_info> {

  final Shedule_modle shedule_modle;
  final Horse_model horse_model;


  _Horse_infoState(this.shedule_modle, this.horse_model);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getList();
  }

  final cmnt=TextEditingController();

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
                child: Center(child: MyText(txt:'Horse - '+ horse_model.name, color: Colors.black, txtSize: 25,fontWeight: FontWeight.bold)),
              ),
            ),

            SizedBox(height: 20,),
            Expanded(
              child: Container(
                width: double.infinity,
                color: Colors.red,
                child: Padding(
                  padding: const EdgeInsets.only(left: 40,right: 40,top: 10,bottom: 10),
                  child: cmnts_list_widget()
                ),
              ),
            ),

            SizedBox(height: 20,),
            Container(
              width: double.infinity,
              color: Colors.green,
              child: Padding(
                padding: const EdgeInsets.only(left: 40,right: 40,top: 10,bottom: 10),
                child: Center(child: MyText(txt:'Today Comment', color: Colors.black, txtSize: 25,fontWeight: FontWeight.bold)),
              ),
            ),
            SizedBox(height: 20,),
            My_Text_Field(controler: cmnt, label: 'Add Comment'),
            SizedBox(height: 20,),

            Row(children: [

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: My_Btn(txt: 'Upload Picture', btn_color: Colors.red, btn_size: 200, gestureDetector: GestureDetector(onTap: () async{

                    XFile? xfile=await ImagePicker().pickImage(source: ImageSource.gallery);
                    if(xfile!=null)
                    {
                      Horse_cmnt_model horse_cmnt_model=Horse_cmnt_model(cmnt: cmnt.text, img: xfile.path, owner_name: shedule_modle.owner_name,
                          time_of_cmnt: DateTime.now().millisecondsSinceEpoch, img_picked: true);
                      praf_handler.add_list(horse_model.name+horse_model.age, jsonEncode(horse_cmnt_model.toJson()));
                      EasyLoading.showSuccess('added');
                      Future.delayed(Duration(seconds: 1)).then((value) => getList());
                    }

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
                      praf_handler.add_list(horse_model.name+horse_model.age, jsonEncode(horse_cmnt_model.toJson()));
                      EasyLoading.showSuccess('added');
                      Future.delayed(Duration(seconds: 1)).then((value) => getList());
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
                                time_of_cmnt: DateTime.now().millisecondsSinceEpoch, img_picked: false);
                            praf_handler.add_list(horse_model.name+horse_model.age, jsonEncode(horse_cmnt_model.toJson()));
                            EasyLoading.showSuccess('added');
                            Navigator.pop(context);
                            Future.delayed(Duration(seconds: 1)).then((value) => getList());
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
      ),

    );
  }

  bool recording=false;
  final record = AudioRecorder();


  Widget cmnts_list_widget(){
    return ListView.builder(
      shrinkWrap: true,
        itemCount: my_cmnts_list.length,
        itemBuilder: (context, index) {

        Horse_cmnt_model model=my_cmnts_list[index];

          return Center(child: ListTile(
            title: Column(
              children: [
                MyText(txt: DateFormat.yMMMd().format(DateTime.fromMillisecondsSinceEpoch(model.time_of_cmnt)), color: Colors.purple, txtSize: 18),
              ],
            ),
            trailing: InkWell(
                onTap: () async{
                  Get.to(Horse_cmnts(list: my_cmnts_list, pos: index,));
                },
                child: Icon(Icons.attach_file,color: Colors.black,)),
          ));
        },);
  }



  List<Horse_cmnt_model> my_cmnts_list=[];

  getList()async{

    my_cmnts_list.clear();
    my_cmnts_list=await praf_handler.get_horse_cmnr(horse_model.name+horse_model.age);

    setState(() {

    });
  }




}
