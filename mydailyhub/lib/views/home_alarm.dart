import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mydailyhub/models/alarm_Item.dart';
import 'package:mydailyhub/models/Alarms.dart';
import 'package:mydailyhub/views/add_Alarm.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeAlarmView extends StatefulWidget{
  @override
  _HomeAlarmState createState() => _HomeAlarmState();
}

class _HomeAlarmState extends State<HomeAlarmView>{
  String _timeString;

  List<Alarms> _myAlarms = [];
  List<Widget> _loadAllAlarms = [];
  SharedPreferences prefs;

  @override
  void initState(){
    super.initState();
    _timeString = _formatDateTime(DateTime.now());
    initPrefs();
  }

  initPrefs() async{
    prefs = await SharedPreferences.getInstance();
    setState(() {
      List<Alarms> temp = List<Alarms>.from(json.decode(prefs.getString("alarms") ?? "{}").map((x) => Alarms.fromJson(x)));
      if(temp != null) {
        _myAlarms = temp;
        _myAlarms.forEach((a) {
          _loadAllAlarms.add(
              InkWell(
                child: alarmItem(a.time, a.days, a.active),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddAlarm()));
                },
              )
          );
        });
      }
    });

  }

  List<Widget> addMyAlarms(){
    _myAlarms.forEach((a) {
      _loadAllAlarms.add(
          InkWell(
            child: alarmItem(a.time, a.days, a.active),
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddAlarm()));
            },
          )
      );
    });
    return _loadAllAlarms;
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('hh:mm').format(dateTime);
  }

  void savingAlarms() async{
    prefs = await SharedPreferences.getInstance();
    prefs.setString("alarms", notesToJson(_myAlarms));
  }

  String notesToJson(List<Alarms> data) =>
      json.encode(List<dynamic>.from(data.map((x) => toJson(x))));

  Map<String, dynamic> toJson(Alarms myAlarm) => {
    "id": myAlarm.id,
    "time": myAlarm.time,
    "days": myAlarm.days,
    "active": myAlarm.active,

  };

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: double.infinity,
      height: 450.0,
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 75.0, top: 25.0, bottom: 25.0),
            child: Container(
              width: double.infinity,
              height: 320.0,
              decoration: BoxDecoration(
                color: Color(0xFFfaecfb),
                border: Border.all(color: Colors.grey.withOpacity(.3), width: .2,),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(.5, 5),
                    blurRadius: 5.0,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 5.0),
                child: Text("Alarms",
                  style: TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: 30.0,
                  ),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 75.0,),
            child: Container(
              width: double.infinity,
              height: 320.0,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.withOpacity(.3), width: .2,),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(.5, 5),
                    blurRadius: 5.0,
                  ),
                ],
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: ListView(
                      children: <Widget>[
                        ..._loadAllAlarms.map((alarm) => InkWell(
                          child: alarm,
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => AddAlarm()));
                          },
                          onLongPress: (){
                            setState(() {
                              int index = 0;
                              index = _loadAllAlarms.indexOf(alarm);
                              _loadAllAlarms.removeAt(index);
                              _myAlarms.removeAt(index);
                              savingAlarms();
                            });

                          },
                        ),
                        ),

                      ],
                    ),
                  ),


                ],
              ),
            ),
          ),
        ],
      ),
    );

  }

}