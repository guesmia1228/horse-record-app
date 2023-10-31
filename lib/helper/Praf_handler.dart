import 'dart:convert';

import 'package:hourses/model/Horse_coment_model.dart';
import 'package:hourses/model/Horse_model.dart';
import 'package:hourses/model/Shedule_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  static add_list(String key,String value)async{
    SharedPreferences sharedPreferences=await my_Praf();

    List<String> list=await get_list_json(key);
    list.add(value);
    sharedPreferences.setStringList(key, list);
  }

  static get_shedule_list(String key)async{


    List<String> list=await get_list_json(key);

    List<Shedule_modle> my_list=[];

    list.forEach((element) {
      print(element);
      my_list.add(Shedule_modle.fromJson(jsonDecode(element)));
    });

    print(my_list.length);
    return my_list;

  }

  static del_list_item(String key,int pos)async{

    SharedPreferences sharedPreferences=await my_Praf();

    List<String> list=await get_list_json(key);
    list.removeAt(pos);
    sharedPreferences.setStringList(key, list);

  }

  static get_horse_list(String key)async{


    List<String> list=await get_list_json(key);

    List<Horse_model> my_list=[];

    list.forEach((element) {
      print(element);
      my_list.add(Horse_model.fromJson(jsonDecode(element)));
    });

    print(my_list.length);
    return my_list;

  }



  static get_horse_cmnr(String key)async{


    List<String> list=await get_list_json(key);

    List<Horse_cmnt_model> my_list=[];

    list.forEach((element) {
      print(element);
      my_list.add(Horse_cmnt_model.fromJson(jsonDecode(element)));
    });

    print(my_list.length);
    return my_list;

  }






}