import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mydailyhub/models/alarm_Item.dart';
import 'package:mydailyhub/models/Alarms.dart';
import 'package:mydailyhub/views/add_Alarm.dart';
import 'package:mydailyhub/views/menu_selector.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlarmPage extends StatefulWidget{
  @override
  _AlarmPageState createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  List<Alarms> _myAlarms = [];
  List<Widget> _loadAllAlarms;
  SharedPreferences prefs;

  @override
  void initState(){
    super.initState();
    initPrefs();
  }

  initPrefs() async{
    _loadAllAlarms = [];
    prefs = await SharedPreferences.getInstance();
    setState(() {
      List<Alarms> temp = List<Alarms>.from(json.decode(prefs.getString("alarms") ?? "{}").map((x) => Alarms.fromJson(x)));
      if(temp != null) {
        Alarms _newAlarm = Alarms("","",[],false);
        Widget _tempAlarm;
        int index = 0;
        _myAlarms = temp;
        _myAlarms.forEach((a) {
          _tempAlarm = alarmItem(a.time, a.days, a.active);
          _loadAllAlarms.add(
              InkWell(
                child: _tempAlarm,
                onLongPress: (){
                  setState(() {
                    int index = 0;
                    index = _loadAllAlarms.length;
                    _loadAllAlarms.removeAt(index);
                    _myAlarms.removeAt(index);
                    savingAlarms();
                  });

                },
                onTap: ()async{
                  _newAlarm = await Navigator.push(context, MaterialPageRoute(builder: (context) => AddAlarm(editAlarm: _myAlarms.elementAt(index),)));
                  if(_newAlarm != null){
                    setState(() {
                      _myAlarms.elementAt(index).time = _newAlarm.time;
                      _myAlarms.elementAt(index).days = _newAlarm.days;
                      _myAlarms.elementAt(index).active = _newAlarm.active;
                      _tempAlarm = alarmItem(_newAlarm.time, _newAlarm.days, _newAlarm.active);
                      savingAlarms();
                    });
                  }


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
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.white,
        child: SingleChildScrollView(
          child:Column(
            children: <Widget>[
              SizedBox(
                height: 200,
                width: double.infinity,
                child: LayoutBuilder(
                  builder: (cx, cy){
                    double w = cy.maxWidth;

                    return Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topRight,
                          child: Container(
                            width: w * .9,
                            height: 120,
                            decoration: BoxDecoration(
                              color: Color(0xFFf5c9c9),
                              border: Border.all(color: Colors.grey.withOpacity(.3), width: .2,),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey[200],
                                  offset: Offset(.5, 5),
                                  blurRadius: 5.0,
                                ),
                              ],
                            ),
                          ),
                        ),

                        Positioned(
                          top: 30,
                          left: 25,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text("My Daily Hub",
                                    style: TextStyle(
                                      fontFamily: "Montserrat",
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30,
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(left: 100.0),
                                    child: Icon(Icons.more_vert),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 35.0),
                                child: MenuSelector(
                                  menus: ["Home", "Calendar", "Notes", "Alarm", "Maps"],
                                  currentPage: 3,
                                ),
                              ),


                            ],
                          ),
                        ),
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
                                iconSize: 40,
                                color: Colors.grey[200],
                                icon: Icon(Icons.alarm),
                                onPressed: () async {
                                  Alarms _newAlarm;
                                  _newAlarm = await Navigator.push(context, MaterialPageRoute(builder: (context) => AddAlarm()));
                                  if(_newAlarm != null){
                                    setState(() {
                                      _myAlarms.add(_newAlarm);
                                      int index = _myAlarms.length;
                                      Widget temp = alarmItem(_newAlarm.time, _newAlarm.days, _newAlarm.active);
                                      _loadAllAlarms.add(
                                          InkWell(
                                            child: temp,
                                            onTap: ()async{
                                              _newAlarm = await Navigator.push(context, MaterialPageRoute(builder: (context) => AddAlarm(editAlarm: _myAlarms.elementAt(index),)));
                                              if(_newAlarm != null){
                                                setState(() {
                                                  _myAlarms.elementAt(index).time = _newAlarm.time;
                                                  _myAlarms.elementAt(index).days = _newAlarm.days;
                                                  _myAlarms.elementAt(index).active = _newAlarm.active;
                                                  temp = alarmItem(_newAlarm.time, _newAlarm.days, _newAlarm.active);
                                                  savingAlarms();
                                                });

                                              }
                                            },
                                          )
                                      );

                                    });
                                    savingAlarms();
                                  }

                                },

                              ),

                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              LayoutBuilder(
                builder: (cx, cy){
                  double w = cy.maxWidth;

                  return Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 25.0, top: 15.0),
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xffd8efea),
                              border: Border.all(color: Colors.grey.withOpacity(.3), width: .2,),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  offset: Offset(.5, 5),
                                  blurRadius: 5.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 50.0, top: 25.0),
                          child: Text(
                            "My Alarms",
                            style: TextStyle(
                              fontSize: 35,
                              fontFamily: "Montserrat",
                              shadows: [
                                Shadow(
                                  blurRadius: 10.0,
                                  color: Colors.black26,
                                  offset: Offset(5.0, 5.0),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 75.0),
                          child: Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              color: Color(0xffd8efea),
                              border: Border.all(color: Colors.grey.withOpacity(.3), width: .2,),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  offset: Offset(.5, 5),
                                  blurRadius: 5.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0, top: 350.0),
                          child: Container(
                            width: w * .8,
                            height: 200,
                            decoration: BoxDecoration(
                              color: Color(0xffd8efea),
                              border: Border.all(color: Colors.grey.withOpacity(.3), width: .2,),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  offset: Offset(.5, 5),
                                  blurRadius: 5.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 100.0,),
                        child: Container(
                          width: double.infinity,
                          height: 320.0,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey.withOpacity(.3), width: .2,),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey[400],
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
                                    ..._loadAllAlarms,

                                  ],
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),


                    ],
                  );
                },
              ),



            ],
          ),
          //*********Body**********
        ),


      ),
    );
  }


}