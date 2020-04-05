import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:mydailyhub/models/Commute.dart';
import 'package:mydailyhub/models/HomeData.dart';
import 'package:mydailyhub/pop_with_result.dart';
import 'package:mydailyhub/select_tools.dart';
import 'package:mydailyhub/views/calendar_widget.dart';
import 'package:mydailyhub/views/home_alarm.dart';
import 'package:mydailyhub/views/menu_selector.dart';
import 'package:mydailyhub/views/note_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();

}

var cardAspectRatio = 12.0 / 16.0;
var widgetAspectRatio = cardAspectRatio * 1.2;

class _MyHomePageState extends State<MyHomePage> {
  List<Widget> _tools = []; //add tool widgets here
  SharedPreferences prefs;
  final Map<String, bool> _initHome = {"calendar": false, "note": false, "alarm": false, "map": false }; //add tool widgets here
  List<Commute> _myCommute =[];
  List<Widget> _myRoutes = [];

  @override
  void initState() {
    super.initState();
    initPrefs();
  }

  initMapPrefs() async{
    prefs = await SharedPreferences.getInstance();
    setState(() {
      List<Commute> temp = List<Commute>.from(json.decode(prefs.getString("routes") ?? "{}").map((x) => Commute.fromJson(x)));
      if(temp != null) {
        _myCommute = temp;
        _myCommute.forEach((c) {
          _myRoutes.add(buildCommuteTool(context, c));
        });
      }
    });

  }

  void savingRoute() async{
    prefs = await SharedPreferences.getInstance();
    prefs.setString("routes", routeToJson(_myCommute));
  }

  String routeToJson(List<Commute> data) =>
      json.encode(List<dynamic>.from(data.map((x) => toJson(x))));

  Map<String, dynamic> toJson(Commute myCommute) => {
    "label": myCommute.label,
    "time": myCommute.time,
    "startLocation": myCommute.startLocation,
    "endLocation": myCommute.endLocation,

  };

  initPrefs() async{
    prefs = await SharedPreferences.getInstance();
    //print(prefs.getString("initalHome"));
    if(prefs.getString("initalHome") != null){
      setState(() {
        HomeData temp = HomeData.fromJson(json.decode(prefs.getString("initalHome") ?? "{}"));
        if(temp != null) {
          _initHome["calendar"] = temp.calendar;
          _initHome["note"] = temp.note;
          _initHome["alarm"] = temp.alarm;
          _initHome["map"] = temp.map;
        }

        List<String> s = _initHome.keys.toList();
        s.forEach((str) {
          if(_initHome[str] == true){
            addTools(str);
          }
        });
      });
    }

  }

  void addTools(String s){
    if(s == "calendar"){
      _tools.add(CalendarItem());
    }else if( s == "note"){
      _tools.add(HomeNoteItem());
    }else if( s == "alarm"){
      _tools.add(HomeAlarmView());
    }else if(s == "map"){
      initMapPrefs();

    }

  }

  void savingTools() async{
    prefs = await SharedPreferences.getInstance();
    prefs.setString("initalHome", toolsToJson(_initHome));
  }

  String toolsToJson(Map<String, bool> data) =>
      json.encode(data);


  @override
  Widget build(BuildContext context) {

    // TODO: implement build
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
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
                        top: 25,
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
                                  child: PopupMenuButton<String> (
//                                    onSelected: deleteTool,
                                    itemBuilder: (BuildContext context){
                                      List<String> tool = [];
                                      _initHome.forEach((key, value){
                                        if(value){
                                          tool.add(key.toString());
                                        }
                                      });
                                      if(tool != null){
                                        return tool.map((t){
                                          return PopupMenuItem<String>(
                                            value: t,
                                            child: Text("delete " + t),
                                          );
                                        }).toList();
                                      }else
                                        return [];

                                    },
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 35.0),
                              child: MenuSelector(
                                menus: ["Home", "Calendar", "Notes", "Alarm", "Maps"],
                                currentPage: 0,
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
                              iconSize: 50,
                              color: Colors.grey[200],
                              icon: Icon(Icons.add),
                              onPressed: () async {
                                Map<String, Widget> newMap;
                                newMap = await Navigator.push(context, MaterialPageRoute(builder: (context) => NewToolsView()));
                                if(newMap != null){
                                  String temp = newMap.keys.elementAt(0);
                                  _initHome[temp] = true;
                                  setState(() {
                                    _tools.add(newMap.values.elementAt(0));
                                    //savingTools();
                                  });
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

            ..._tools,
          ],
        ),
      )
    );


  }

  Widget buildCommuteTool(BuildContext context, Commute myCommute) {
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
                        child: Text("Maps",
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
                padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 75.0,),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.withOpacity(.3), width: .2,),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(.5, 5),
                        blurRadius: 5.0,
                      ),
                    ],
                  ),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: ListView(
                          children: <Widget>[
                            ..._myRoutes.map((routes) => Card(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 25.0, left: 15.0, right: 15.0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 4,
                                      child: Column(
                                        children: <Widget>[
                                          //GOOGLE MAPS
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Padding(
                                              padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                                              child: Text(myCommute.label, style: new TextStyle(fontSize: 25.0),),
                                            ),
                                          ),

                                          //TRANSIT TIME
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Padding(
                                              padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                                              child: Text(myCommute.time, style: new TextStyle(fontSize: 24.0),),
                                            ),
                                          ),

                                          //FROM ~ TO
                                          Padding(
                                            padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                                            child: Row(
                                              children: <Widget>[
                                                Text(myCommute.startLocation + " ~ ", style: new TextStyle(fontSize: 16.0),),
                                                Text(myCommute.endLocation, style: new TextStyle(fontSize: 16.0),),
                                                Spacer(),
                                              ],
                                            ),
                                          ),


                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        children: <Widget>[
                                          IconButton(
                                            icon: Icon(Icons.near_me),
                                            onPressed: (){

                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.refresh),
                                            onPressed: () async {
                                              String newTime = await _getTravelTime(myCommute.startLocation, myCommute.endLocation);
                                              setState(() {
                                                myCommute.time = newTime;
                                                int index = 0;
                                                index = _myCommute.indexOf(myCommute);
                                                _myCommute.elementAt(index).time = newTime;
                                                _myRoutes.removeAt(index);
                                                _myRoutes.add(buildCommuteTool(context, myCommute));
                                                savingRoute();
                                              });
                                            },
                                          ),
                                        ],
                                      ),

                                    ),



                                  ],
                                ),
                              ),
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
          );
        },
      ),

    );

  }

  void deleteTool(String tool){
    _initHome[tool] = false;
    savingTools();
    setState(() {
      if(tool == "calendar"){
        _tools.remove(_tools.indexOf(CalendarItem()));
      }else if( tool == "note"){
        _tools.remove(_tools.indexOf(HomeNoteItem()));
      }else if( tool == "alarm"){
        _tools.remove(_tools.indexOf(HomeAlarmView()));
      }
    });


  }

  Future<Commute> _awaitCommuteTime(BuildContext context) async {
    PopWithResults popResult;
    await Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewToolsView())).then((results) {
      popResult = results as PopWithResults;

    });

    if (popResult != null) {
      return popResult.results.values.toList()[0];
      //print(popResult.results.values.toList()[0].time);
    }else {
      return null;
    }
  }

  Future<String> _getTravelTime(String origins, String destination) async {
    //String time;
    print("Start request ...");
    await FlutterConfig.loadEnvVariables();
    var key = FlutterConfig.get('API_KEY');
    http.Response response = await http.get("https://maps.googleapis.com/maps/api/distancematrix/json?origins=$origins&destinations=$destination&key=$key&departure_time=now");
    var resObj = jsonDecode(response.body);  //Map<String, Dynamic>
    var time = resObj['rows'][0]['elements'][0]['duration_in_traffic']['text'];
    return time;
  }

}



