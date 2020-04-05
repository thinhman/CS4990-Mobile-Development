import 'dart:convert';
import 'package:flutter_config/flutter_config.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:mydailyhub/maps_setup.dart';
import 'package:mydailyhub/models/Commute.dart';
import 'package:mydailyhub/pop_with_result.dart';
import 'package:mydailyhub/views/menu_selector.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapsPage extends StatefulWidget{
  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  List<Commute> _myCommute =[];
  List<Widget> _myRoutes = [];
  SharedPreferences prefs;

  @override
  void initState(){
    super.initState();
    initPrefs();
  }

  initPrefs() async{
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
                                  currentPage: 4,
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
                                icon: Icon(Icons.map),
                                onPressed: () async {
                                  Commute myCommute;
                                  myCommute = await _awaitCommuteTime(context);
                                  if(myCommute != null){
                                    setState(() {
                                      _myCommute.add(myCommute);
                                      _myRoutes.add(buildCommuteTool(context, myCommute));
                                      savingRoute();
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
                            "My Routes",
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
                                    ..._myRoutes.map((routes) => InkWell(
                                      child: routes,
                                      onLongPress: (){
                                        setState(() {
                                          int index = 0;
                                          index = _myRoutes.indexOf(routes);
                                          _myRoutes.removeAt(index);
                                          _myCommute.removeAt(index);
                                          savingRoute();
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

  Widget buildCommuteTool(BuildContext context, Commute myCommute) {
    return Card(
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
                      child: Text("Google Maps", style: new TextStyle(fontSize: 25.0),),
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
    );
  }

  Future<Commute> _awaitCommuteTime(BuildContext context) async {
    PopWithResults popResult;
    await Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewTransitTimeView())).then((results) {
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
    //WidgetsFlutterBinding.ensureInitialized();
    await FlutterConfig.loadEnvVariables();
    var key = FlutterConfig.get('API_KEY');
    //String time;
    print("Start request ...");
    http.Response response = await http.get("https://maps.googleapis.com/maps/api/distancematrix/json?origins=$origins&destinations=$destination&key=$key&departure_time=now");
    var resObj = jsonDecode(response.body);  //Map<String, Dynamic>
    var time = resObj['rows'][0]['elements'][0]['duration_in_traffic']['text'];
    return time;
  }

}