import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mydailyhub/models/Alarms.dart';

class AddAlarm extends StatefulWidget {
  AddAlarm({Key key, this.editAlarm}) : super(key: key);
  final Alarms editAlarm;

  @override
  _AddAlarmState createState() => _AddAlarmState(editAlarm);
}

class _AddAlarmState extends State<AddAlarm> {
  Map<String, bool> _days = {"Sun": false, "Mon": false, "Tue": false, "Wed": false, "Thu": false, "Fri": false, "Sat": false};
  String _time;
  String _id;
  final now = new DateTime.now();

  TimeOfDay _selectedTime;
  ValueChanged<TimeOfDay> selectTime;

  _AddAlarmState(Alarms editAlarm){
    if(editAlarm != null){
      print("true");
      _id = editAlarm.id;
      editAlarm.days.forEach((d){
        _days[d] = true;
      });
      _time = editAlarm.time;
      _selectedTime = new TimeOfDay(hour: int.parse(_time.substring(0,2) ), minute: int.parse(_time.substring(3) ));
    }else{
      _id = "test";
    }
  }

  @override
  void initState() {
    super.initState();
    initTime();
  }
  initTime(){
    if(_time == null){
      _time = _formatDateTime(DateTime.now());
      _selectedTime = new TimeOfDay(hour: int.parse(_time.substring(0,2) ), minute: int.parse(_time.substring(3) ));
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('hh:mm').format(dateTime);
  }


  Widget circleDay(day, context, selected){
    return
      Container(
        width: 50.0,
        height: 50.0,
        decoration: BoxDecoration(
            color: (selected)?Theme.of(context).accentColor:Colors.transparent,
            borderRadius: BorderRadius.circular(100.0)
        ),
        child: Padding(
          padding: EdgeInsets.all(6.0),
          child: Center(
            child: Text(
              day,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 19.0,
              ),
            ),
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffd8efea),
        //backgroundColor: Color(0xff1B2C57),
        appBar: AppBar(
          backgroundColor: Color(0xff1B2C57),
        ),
        body: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Container(
                child: Column(
                  children: <Widget>[
                    Container(
                        width: MediaQuery.of(context).size.width *.9,
                        height: MediaQuery.of(context).copyWith().size.height / 3,
                        child: CupertinoDatePicker(
                          initialDateTime: DateTime(now.year, now.month, now.day, _selectedTime.hour, _selectedTime.minute),
                          onDateTimeChanged: (DateTime newdate) {
                            _time = _formatDateTime(newdate);
                            //print(newdate);
                          },
                          use24hFormat: false,
                          minuteInterval: 1,
                          mode: CupertinoDatePickerMode.time,
                        )
                    ),
                    SizedBox(height: 30.0,),
//                  new GestureDetector(
//                    child: Text(
//                      _time,
//                      //_selectedTime.format(context),
//                      style: TextStyle(
//                        fontSize: 30.0,
//                        fontWeight: FontWeight.bold,
//                        color: Colors.white,
//                      ),
//                    ),
//                    onTap: () {
//                      _selectTime(context);
//                      _time = _selectedTime.format(context);
//                    },
//                  ),
                    Container(
                      color: Colors.white,
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 30.0,),
                          Padding(
                            padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                GestureDetector(
                                  child: circleDay('Mon', context, _days["Mon"]),
                                  onTap: (){
                                    setState(() {
                                      _days["Mon"] = ! _days["Mon"];
                                    });
                                  },
                                ),
                                GestureDetector(
                                  child: circleDay('Tue', context, _days["Tue"]),
                                  onTap: (){
                                    setState(() {
                                      _days["Tue"] = ! _days["Tue"];
                                    });
                                  },
                                ),
                                GestureDetector(
                                  child: circleDay('Wed', context, _days["Wed"]),
                                  onTap: (){
                                    setState(() {
                                      _days["Wed"] = ! _days["Wed"];
                                    });
                                  },
                                ),
                                GestureDetector(
                                  child: circleDay('Thu', context, _days["Thu"]),
                                  onTap: (){
                                    setState(() {
                                      _days["Thu"] = ! _days["Thu"];
                                    });
                                  },
                                ),
                                GestureDetector(
                                  child: circleDay('Fri', context, _days["Fri"]),
                                  onTap: (){
                                    setState(() {
                                      _days["Fri"] = ! _days["Fri"];
                                    });
                                  },
                                ),
                                GestureDetector(
                                  child: circleDay('Sat', context, _days["Sat"]),
                                  onTap: (){
                                    setState(() {
                                      _days["Sat"] = ! _days["Sat"];
                                    });
                                  },
                                ),
                                GestureDetector(
                                  child: circleDay('Sun', context, _days["Sun"]),
                                  onTap: (){
                                    setState(() {
                                      _days["Sun"] = ! _days["Sun"];
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 15.0, right: 15.0),
                            child: Column(
                              children: <Widget>[
                                SizedBox(height: 60.0,),
                                SizedBox(height: 2.0, child: Container(color: Colors.black87,),),
                                ListTile(
                                  leading: Icon(Icons.notifications_none, color: Colors.black87,),
                                  title: Text('Alarm Notification', style: TextStyle(color: Colors.black87, fontSize: 20.0)),
                                ),
                                SizedBox(height: 2.0, child: Container(color: Colors.black87,),),
                                ListTile(
                                  leading: Icon(Icons.check_box, color: Colors.black87,),
                                  title: Text('Vibrate', style: TextStyle(color: Colors.black87, fontSize: 20.0)),
                                ),
                                SizedBox(height: 2.0, child: Container(color: Colors.black87,),),
                                SizedBox(height: 30.0,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.only(bottom: 25.0),
                                        child: Container(
                                          height: 75,
                                          width: 80,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(0xFFf5c9c9),
                                            border: Border.all(color: Colors.grey.withOpacity(.3), width: .2,),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey[300],
                                                offset: Offset(.5, 5),
                                                blurRadius: 5.0,
                                              ),
                                            ],
                                          ),
                                          child: IconButton(
                                            iconSize: 70,
                                            color: Colors.grey[200],
                                            icon: Icon(
                                              Icons.delete,
                                              size: 20.0,
                                              color:Theme.of(context).accentColor,
                                            ),
                                            onPressed: () =>  Navigator.of(context).pop(),

                                          ),

                                        ),
                                      ),
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.only(right: 15.0),
                                      child: Align(
                                        alignment: Alignment.bottomRight,
                                        child: FlatButton(
                                            color: Theme.of(context).accentColor,
                                            child: Text('Save', style: TextStyle(color: Colors.white)),
                                            onPressed: () {
                                              List<String> _activeDays = [];
                                              _days.forEach((key, value){
                                                if(_days[key] == true){
                                                  _activeDays.add(key.toString());
                                                }
                                              });
                                              Navigator.of(context).pop(Alarms(_id, _time, _activeDays, true));
                                            }
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                              ],
                            ),
                          )

                        ],
                      ),
                    ),




                  ],
                ),
              )
          ),
        ),

    );
  }

//  Future<void> _selectTime(BuildContext context) async {
//    final TimeOfDay picked =  await showTimePicker(
//        context: context,
//        initialTime: _selectedTime
//    );
//    setState(() {
//      _selectedTime = picked;
//    });
//  }
}