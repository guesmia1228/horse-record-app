import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:horse/Home.dart';
import 'package:horse/ReportSchedule.dart';
import 'package:horse/Setting.dart';
import 'package:horse/helper/My_Button.dart';
import 'package:horse/helper/My_Text.dart';
import 'package:horse/helper/Praf_handler.dart';
import 'package:horse/helper/my_helper.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:horse/OwnerPage.dart';
import 'package:horse/model/Shedule_model.dart';
import 'package:horse/helper/My_Text_Field.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:flutter_native_contact_picker/flutter_native_contact_picker.dart';
import 'package:custom_date_range_picker/custom_date_range_picker.dart';
class ReportSchedule extends StatefulWidget {
  const ReportSchedule({super.key});

  @override
  State<ReportSchedule> createState() => _ReportState();
}

class _ReportState extends State<ReportSchedule> {
  Contact ?contact;
  int sum=0;
//  final w1=TextEditingController(),w2=TextEditingController(),w3=TextEditingController();
  TextEditingController dateController = TextEditingController(text: DateFormat.yMd().format(DateTime.now()));
  String fixed_digital_time='09:30 AM';
        List<Shedule_modle> total_list = [];
  bool isAscendingName = true;
  bool isAscendingDate = true;

   DateTime endDate= DateTime.now();
  DateTime startDate = DateTime.now().subtract(Duration(days: 14));
  DateRange? selectedDateRange;
  // Future<void> _selectDateRange(BuildContext context) async {
  //   final List<DateTime> picked = await DateRangePicker.showDatePicker(
  //     context: context,
  //     initialFirstDate: _startDate,
  //     initialLastDate: _endDate,
  //     firstDate: DateTime(2020),
  //     lastDate: DateTime(2100),
  //   );
  //   if (picked != null && picked.length == 2) {
  //     setState(() {
  //       _startDate = picked[0];
  //       _endDate = picked[1];
  //     });
  //   }
  // }

  getFixedDigitalTime()async{
    int t=await praf_handler.get_int(my_helper.fixed_digital_time);
   // print(t);
    if(t>0)
      fixed_digital_time=DateFormat('hh:mm a').format(DateTime.fromMillisecondsSinceEpoch(t));

   // print('fixed '+fixed_digital_time);
    setState(() {

    });
  }
  _getDataAndDisplaySchedule() async
  {
    if(startDate!=null && endDate!=null )
                {
                    sum=0;
                    total_list=[];
                    for (DateTime i = startDate; i.isBefore(endDate); i = i.add(Duration(days: 1))) {
                        String formattedDate = DateFormat('yyyy-MM-dd 00:00:00.000').format(i);
                        DateTime date = DateTime.parse(formattedDate);                      
                        print("formmatedate");
                        print(my_helper.shedule + date.millisecondsSinceEpoch.toString());
                        List<Shedule_modle> list=[];
                        list =  await praf_handler.get_shedule_list(my_helper.shedule + date.millisecondsSinceEpoch.toString());
                        for(int i=0;i<list.length;i++)
                          sum+=list[i].horse;

                        total_list.addAll(list);
                    }
                    print(total_list);
                 
                }
              setState(() {

              });

    // You can now use the total_list in your application as needed
    // For example, you can display it in a ListView or process the data further.
  }
  @override
  void initState() {
    endDate =  DateTime.now();
    startDate = DateTime.now().subtract(Duration(days: 15));


    // TODO: implement initState
    super.initState();
    getFixedDigitalTime();
   _getDataAndDisplaySchedule();
  }

  @override
   Widget datePickerBuilder(
          BuildContext context, dynamic Function(DateRange?) onDateRangeChanged,
          [bool doubleMonth = true]) =>
      DateRangePickerWidget(
        doubleMonth: doubleMonth,
        maximumDateRangeLength: 10,
        // quickDateRanges: [
        //   QuickDateRange(dateRange: null, label: "Remove date range"),
        //   QuickDateRange(
        //     label: 'Last 3 days',
        //     dateRange: DateRange(
        //       DateTime.now().subtract(const Duration(days: 3)),
        //       DateTime.now(),
        //     ),
        //   ),
        //   QuickDateRange(
        //     label: 'Last 7 days',
        //     dateRange: DateRange(
        //       DateTime.now().subtract(const Duration(days: 7)),
        //       DateTime.now(),
        //     ),
        //   ),
        //   QuickDateRange(
        //     label: 'Last 30 days',
        //     dateRange: DateRange(
        //       DateTime.now().subtract(const Duration(days: 30)),
        //       DateTime.now(),
        //     ),
        //   ),
        //   QuickDateRange(
        //     label: 'Last 90 days',
        //     dateRange: DateRange(
        //       DateTime.now().subtract(const Duration(days: 90)),
        //       DateTime.now(),
        //     ),
        //   ),
        //   QuickDateRange(
        //     label: 'Last 180 days',
        //     dateRange: DateRange(
        //       DateTime.now().subtract(const Duration(days: 180)),
        //       DateTime.now(),
        //     ),
        //   ),
        // ],
        minimumDateRangeLength: 3,
        initialDateRange: selectedDateRange,
        disabledDates: [DateTime(2023, 11, 20)],
        initialDisplayedDate:
            selectedDateRange?.start ?? DateTime(2023, 11, 20),
        onDateRangeChanged: onDateRangeChanged,
      );
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

             Text(
              'Report',
              style: TextStyle(
                fontSize: 30,
              ),
            ),
 
             Container(
              width: double.infinity,
              color: Color.fromARGB(255, 109, 106, 213),              
              child: Padding(
                padding: const EdgeInsets.only(left: 40,right: 40,top: 10,bottom: 10),
                
                child: Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                  if(startDate!=null)
                    MyText(txt:'Date Range('+ DateFormat('M-d-yyyy').format(startDate!), color: Colors.black, txtSize: 14,fontWeight: FontWeight.bold),
                  if(endDate!=null)
                    MyText(txt: ' to ' + DateFormat('M-d-yyyy').format(endDate!)+')', color: Colors.black, txtSize: 14,fontWeight: FontWeight.bold),

                  Spacer(),
//                  MyText(txt: shedule_modle.horse.toString()+' hd', color: Colors.black, txtSize: 20,fontWeight: FontWeight.bold),
                ],),
              ),
            ),    
    
            SizedBox(height: 20,),
      // _getDataAndDisplaySchedule(),
         Container(
                height: 25, // Replace with your desired height
                padding: EdgeInsets.all(4),
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: Color.fromARGB(255, 82, 116, 207),
                child:  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [

                    
                     Expanded(
                      flex: 1,
                        child: Text("No"),
                    ),
                    Expanded(
                      flex: 2,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isAscendingName = !isAscendingName;
                            total_list.sort((a, b) => isAscendingName ? a.owner_name.compareTo(b.owner_name) : b.owner_name.compareTo(a.owner_name));
                          });
                        },
                        child: Row(
                          children: [
                            Text("Owner"),
                             Align(
                                alignment: Alignment.center,
                                child: Icon(
                                  isAscendingName ? Icons.arrow_drop_down : Icons.arrow_drop_up,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),

                     Expanded(
                      flex: 2,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            isAscendingDate = !isAscendingDate;
                            total_list.sort((a, b) => isAscendingDate ? a.shedule_time.compareTo(b.shedule_time) : b.shedule_time.compareTo(a.shedule_time));
                          });
                        },
                        child: Row(
                          children: [
                            Text("Scheduled"),
                            SizedBox(height: 4),
                             Align(
                                alignment: Alignment.center,
                                child: Icon(
                                  isAscendingDate ? Icons.arrow_drop_down : Icons.arrow_drop_up,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
   
       ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemCount: total_list.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          Shedule_modle model=total_list[index];
           return Container(
                height: 25, // Replace with your desired height
                padding: EdgeInsets.all(4),
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: Colors.grey[300],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [

                    
                     Expanded(
                      flex: 1,
                      child: Text((index + 1).toString()),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(model.owner_name),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(DateFormat('yyyy-MM-dd')
                          .format(DateTime.fromMillisecondsSinceEpoch(model.shedule_time))+" " +model.time),
                    ),
                  ],
                ),
              );
        }
       )
             
           

          ],
        ),
      ),

       floatingActionButton: FloatingActionButton(
        onPressed: () {
          showCustomDateRangePicker(
            context,
            dismissible: true,
            minimumDate: DateTime.now().subtract(const Duration(days: 1330)),
            maximumDate: DateTime.now().add(const Duration(days: 1330)),
            endDate: endDate,
            startDate: startDate,
            backgroundColor: Colors.white,
            primaryColor: Colors.green,
            onApplyClick: (start, end) async{
                if(startDate!=null && endDate!=null )
                {
                    sum=0;
                    total_list=[];
                    for (DateTime i = startDate; i.isBefore(endDate); i = i.add(Duration(days: 1))) {
                        String formattedDate = DateFormat('yyyy-MM-dd 00:00:00.000').format(i);
                        DateTime date = DateTime.parse(formattedDate);                      
                        print("formmatedate");
                        print(my_helper.shedule + date.millisecondsSinceEpoch.toString());
                        List<Shedule_modle> list=[];
                        list =  await praf_handler.get_shedule_list(my_helper.shedule + date.millisecondsSinceEpoch.toString());
                        for(int i=0;i<list.length;i++)
                        {
                          sum+=list[i].horse;
                          if(praf_handler.get_noti("noti"+list[i].owner_name+list[i].shedule_time.toString())!="1")
                            total_list.add(list[i]);
                        }
                    }
                    print(total_list);                 
                }
              setState(() {
                endDate = end;
                startDate = start;
                sum=sum;
              });
            },
            onCancelClick: () {
              setState(() {
                // endDate = null;
                // startDate = null;
              });
            },
          );
        },
        tooltip: 'choose date Range',
        child: const Icon(Icons.calendar_today_outlined, color: Colors.white),
      ),
    );
    
  }
  

}

