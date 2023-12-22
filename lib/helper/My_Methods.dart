import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:horse/helper/my_helper.dart';
import 'package:horse/model/User_model.dart';
import 'package:intl/intl.dart';

class my_Methods
{
  static getUserModel() async{
    DatabaseReference databaseReference=FirebaseDatabase.instance.ref();
    User_model? model;
    await databaseReference.child(my_helper.users_table).child(FirebaseAuth.instance.currentUser!.uid.toString()).once().then((value) {
      if(value.snapshot.exists)
      {
        model=User_model.fromJson(value.snapshot.value as Map);

      }
    });

    return model;
  }

  static my_id()
  {
    return FirebaseAuth.instance.currentUser!.uid.toString();
  }

  static get_days_in_week(DateTime date, int week_nbr)async{


    List<DateTime> weekdays = [];

//    int year = DateTime.now().year-1;

    int firstDayOfWeek = (week_nbr-1) * 7;
    final extraDuration = Duration(days: firstDayOfWeek);

//    final startDate = DateTime(year);
    final startDate = date;
    
    final dates = startDate.add(extraDuration);
    DateTime  dates_after = dates;
    String dayOfWeek = DateFormat.E().format(dates);    
    if(dayOfWeek == "Mon")
    {
      dates_after = dates.subtract(Duration(days:1));
    }
    if(dayOfWeek == "Tue")
    {
      dates_after = dates.subtract(Duration(days:2));
    }
    if(dayOfWeek == "Wed")
    {
      dates_after = dates.subtract(Duration(days:3));
    }
    if(dayOfWeek == "Thu")
    {
   // print(dayOfWeek);
  
      dates_after = dates.subtract(Duration(days:4));
   //   print(dates);
    } 
    if(dayOfWeek == "Fri")
    {
      
      dates_after = dates.subtract(Duration(days:5));
    }               
    if(dayOfWeek == "Sat")
    {
      dates_after = dates.subtract(Duration(days:6));
    }               

    for (var i = 0; i < 7; i++) {
      DateTime newDate = dates_after.add(Duration(days: i));
  
  String formattedNewDate = DateFormat('yyyy-MM-dd 00:00:00.000').format(newDate);
  
  // Parse the formatted date string back into a DateTime object
  DateTime newDateTime = DateTime.parse(formattedNewDate);
    weekdays.add(newDateTime);
   //   print(DateFormat.yMMMMEEEEd().format(newDate));
      // if(DateFormat('E').format(newDate) == 'Mon')print('Monday:'+newDate.toString());
      // else if(DateFormat('EEEE').format(newDate) == 'Tuesday')print('Tuesday:'+newDate.toString());
      // else if(DateFormat('EEEE').format(newDate) == 'Friday')print('Friday:'+newDate.toString());
    }

    return weekdays;

  }

}