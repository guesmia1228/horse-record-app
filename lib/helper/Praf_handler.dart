import 'dart:convert';

import 'package:horse/model/Horse_coment_model.dart';
import 'package:horse/model/Horse_model.dart';
import 'package:horse/model/Shedule_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
class praf_handler{
  static my_Praf()async{
    SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    await sharedPreferences.reload();
    return sharedPreferences;
  }

  static set_int(String key,int value)async{
    SharedPreferences sharedPreferences=await my_Praf();
    sharedPreferences.setInt(key, value);
  }
  static get_int(String key)async{
    SharedPreferences sharedPreferences=await my_Praf();
    return sharedPreferences.getInt(key)??0;
  }
  static set_bool(String key,bool value)async{
    SharedPreferences sharedPreferences=await my_Praf();
    sharedPreferences.setBool(key, value);
  }
  static get_bool(String key)async{
    SharedPreferences sharedPreferences=await my_Praf();
    return sharedPreferences.getBool(key)??true;
  }
  static set_string(String key,String value)async{
    SharedPreferences sharedPreferences=await my_Praf();
    sharedPreferences.setString(key, value);
  }
  static get_string(String key)async{
    SharedPreferences sharedPreferences=await my_Praf();
    return sharedPreferences.getString(key)??'';
  }

  static get_list_json(String key)async{
    SharedPreferences sharedPreferences=await my_Praf();
    List<String> s=[];
    s=await sharedPreferences.getStringList(key)??[];
    return s;
  }

  static add_list(String key,String value )async{
    SharedPreferences sharedPreferences=await my_Praf();

    List<String> list=await get_list_json(key);

      list.add(value);

      sharedPreferences.setStringList(key, list);
   // print("add_list=========================1");
  }

 static DateTime _parseTime(String time){
  String formattedTime = time.replaceAll(" ", "");

  // Manually parsing the time string
  int hour = int.parse(formattedTime.substring(0, 2));
  int minute = int.parse(formattedTime.substring(3, 5));
  String period = formattedTime.substring(5);

  if (period == "PM" && hour < 12) {
    hour += 12;
  }

  return DateTime(2023, 1, 1, hour, minute);
}
  static add_list_sort(String key,String value , String type)async{
    SharedPreferences sharedPreferences=await my_Praf();

    List<String> list=await get_list_json(key);
    if(type=="Schedule")
    {
      List<Shedule_modle> my_list=[];
      list.add(value);
      list.forEach((element) {
        my_list.add(Shedule_modle.fromJson(jsonDecode(element)));
       });

       print("length");
       print(my_list.length);
       print(my_list);
       int i;
       for(i=0;i<my_list.length;i++){
          print(my_list[i].time);
       }

       Shedule_modle temp;           
       for(i=0;i<my_list.length-1;i++)
       {
          for(int j=i+1;j<my_list.length;j++)
          {
              String time1=my_list[i].time;
              String time2=my_list[j].time;
              DateTime parsedTime1 = _parseTime(time1);
              DateTime parsedTime2 = _parseTime(time2);        
       
              int comparisonResult = parsedTime1.compareTo(parsedTime2);
              print("==============================================");
              print(parsedTime1);
              print(parsedTime2);
              print(comparisonResult);
              print("==============================================");

               if (comparisonResult > 0) {
                  temp = my_list[i];
                  my_list[i] = my_list[j];
                  my_list[j] = temp;
               }              
          }
      }
      for(i=0;i<my_list.length;i++){
          print(my_list[i].time);
       }
      List<String> list_new=[];
      for(int i=0;i<my_list.length;i++){
        list_new.add(jsonEncode(my_list[i].toJson()));        
      }
      sharedPreferences.setStringList(key, list_new);
    }
    if(type=="horse_sort")
    {
       List<Horse_cmnt_model> my_list=[];
      list.add(value);
      list.forEach((element) {
        my_list.add(Horse_cmnt_model.fromJson(jsonDecode(element)));
       });

       print("length");
       print(my_list.length);
       print(my_list);
       int i;
      

       Horse_cmnt_model temp;           
       for(i=0;i<my_list.length-1;i++)
       {
          for(int j=i+1;j<my_list.length;j++)
          {
              int time1=my_list[i].time_of_cmnt;
              int time2=my_list[j].time_of_cmnt;      
       
//              int comparisonResult = parsedTime1.compareTo(parsedTime2);
              print("==============================================");
//              print(parsedTime1);
//              print(parsedTime2);
              print("==============================================");

               if (time1 > time2) {
                  temp = my_list[i];
                  my_list[i] = my_list[j];
                  my_list[j] = temp;
               }              
          }
      }

      List<String> list_new=[];
      for(int i=0;i<my_list.length;i++){
        list_new.add(jsonEncode(my_list[i].toJson()));        
      }
      sharedPreferences.setStringList(key, list_new);
    }
   // print("add_list=========================1");
  }
  static del_list_item_from_schedule(String key,int pos) async{
      SharedPreferences sharedPreferences=await my_Praf();

    List<String> list=await get_list_json(key);
    list.removeAt(pos);
    sharedPreferences.setStringList(key, list);

  }
  static get_shedule_list(String key)async{


    List<String> list=await get_list_json(key);

    List<Shedule_modle> my_list=[];

    list.forEach((element) {
   //   print(element);
      my_list.add(Shedule_modle.fromJson(jsonDecode(element)));
    });

  //  print(my_list.length);
    return my_list;

  }

  static del_list_item(String key,int pos)async{

    SharedPreferences sharedPreferences=await my_Praf();

    List<String> list=await get_list_json(key);
    list.removeAt(pos);
    sharedPreferences.setStringList(key, list);

  }
  static edit_list_item(String key,int pos,String s,String name)async{

    SharedPreferences sharedPreferences=await my_Praf();

    List<String> list=await get_list_json(key);

    Horse_model temp = Horse_model.fromJson(jsonDecode(list[pos]));

    list[pos]=s;
//    list.removeAt(pos);
//   print("Jane ==========");
   print(temp.name);
    List<String> list_comment=await get_list_json(temp.name);

    sharedPreferences.setStringList(key, list);

    sharedPreferences.setStringList(name, list_comment);
  }
  static get_horse_list(String key)async{


    List<String> list=await get_list_json(key);

    List<Horse_model> my_list=[];

    list.forEach((element) {
    //  print(element);
      my_list.add(Horse_model.fromJson(jsonDecode(element)));
    });

   // print(my_list.length);
    return my_list;

  }



  static get_horse_cmnr(String key)async{


    List<String> list=await get_list_json(key);

    List<Horse_cmnt_model> my_list=[];

    list.forEach((element) {
//      print(element);
      my_list.add(Horse_cmnt_model.fromJson(jsonDecode(element)));
    });

//    print(my_list.length);
    return my_list;

  }






}