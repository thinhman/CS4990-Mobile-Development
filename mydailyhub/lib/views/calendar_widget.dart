import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class CalendarItem extends StatefulWidget{
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<CalendarItem>{
  TextEditingController _eventController;
  CalendarController _calendarController;
  List<dynamic> _selectedEvents;
  Map<DateTime, List<dynamic>> _events;
  SharedPreferences prefs;

  @override
  void initState(){
    super.initState();
    _eventController = TextEditingController();
    _calendarController = CalendarController();
    _selectedEvents = [];
    _events= {};
    initPrefs();
  }

  initPrefs() async{
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _events = Map<DateTime, List<dynamic>>.from(decodeMap(json.decode(prefs.getString("events") ?? "{}")));
    });

  }

  Map<String, dynamic> encodeMap(Map<DateTime, dynamic> map) {
    Map<String, dynamic> newMap = {};
    map.forEach((key, value) {
      newMap[key.toString()] = map[key];
    });
    return newMap;
  }

  Map<DateTime, dynamic> decodeMap(Map<String, dynamic> map) {
    Map<DateTime, dynamic> newMap = {};
    map.forEach((key, value) {
      newMap[DateTime.parse(key)] = map[key];
    });
    return newMap;
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      width: double.infinity,
      child: LayoutBuilder(
        builder: (cx, cy){
          return Stack(
            children: <Widget>[
              Container(
                height: 325,
                width: double.infinity,
                child:
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 90),
                    child: Container(
                      height: 325,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color(0xFFf8e1da),
                        border: Border.all(color: Colors.grey.withOpacity(.3), width: .2,),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey[200],
                            offset: Offset(.5, 5),
                            blurRadius: 5.0,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0, top: 5.0),
                        child: Text("Calendar",
                          style: TextStyle(
                            fontFamily: "Montserrat",
                            fontSize: 30.0,
                          ),
                        ),
                      ),

                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 50.0, bottom: 50.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.withOpacity(.3), width: .2,),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[500],
                        offset: Offset(.5, 5),
                        blurRadius: 5.0,
                      ),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      TableCalendar(
                        events: _events,
                        initialCalendarFormat: CalendarFormat.month,
                        calendarStyle: CalendarStyle(
                          todayColor: Colors.orange,
                          todayStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: Colors.white,
                          ),
                          selectedColor: Colors.blue,
                        ),
                        headerStyle: HeaderStyle(
                          centerHeaderTitle: true,
                          formatButtonDecoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          formatButtonTextStyle: TextStyle(
                            color: Colors.white,
                          ),
                          formatButtonShowsNext: false,
                        ),
                        onDayLongPressed: (date, events){
                          _showAddDialog();
                        },
                        onDaySelected: (date, events) {
                          setState(() {
                            _selectedEvents = events;
                            if(_selectedEvents.length == 0){
                              _selectedEvents.add("No Events...");
                            }
                          });
                          //print(date.toIso8601String());
                        },
                        builders: CalendarBuilders(
                          selectedDayBuilder: (context, date, events) => Container(
                            margin: const EdgeInsets.all(4.0),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10.0),
                              //shape: BoxShape.circle,
                            ),
                            child: Text(
                              date.day.toString(),
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        calendarController: _calendarController,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 25.0, bottom: 25.0, left: 10.0, right: 10.0),
                        child: Container(
                          width: double.infinity,
                          height: 200.0,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: ListView(
                                    children: <Widget>[
                                      ..._selectedEvents.map((event) => Card(
                                          child: ListTile(
                                            title: Text(event),
                                            onLongPress: (){
                                              setState(() {
                                                _selectedEvents.remove(event);
                                                _events.remove(event);
                                                prefs.setString("events", json.encode(encodeMap(_events)));
                                              });
                                            },
                                          )
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                              ),


                            ],
                          ),
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

    );
  }

  _showAddDialog(){
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: TextField(
            controller: _eventController,

          ),
          actions: <Widget>[
            FlatButton(
              child: Text("Save"),
              onPressed: (){
                if(_eventController.text.isEmpty) return;
                if(_events[_calendarController.selectedDay] != null){
                  _events[_calendarController.selectedDay].add(_eventController.text);
                }else{
                  _events[_calendarController.selectedDay] = [_eventController.text];
                }
                prefs.setString("events", json.encode(encodeMap(_events)));
                _eventController.clear();
                setState(() {
                  _selectedEvents = _events[_calendarController.selectedDay];
                });
                Navigator.pop(context);
              },
            )
          ],
        )
    );

  }

}