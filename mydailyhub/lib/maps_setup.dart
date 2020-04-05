import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mydailyhub/models/Commute.dart';
import 'package:mydailyhub/pop_with_result.dart';
import 'package:mydailyhub/select_tools.dart';
import 'package:mydailyhub/views/menu_selector.dart';

class NewTransitTimeView extends StatefulWidget {
  @override
  _TransitTimeState createState() => _TransitTimeState();

}

class _TransitTimeState extends State<NewTransitTimeView> {
  Commute myCommute = new Commute(null, null, null, null);

  @override
  Widget build(BuildContext context) {

    final TextEditingController _labelTextEditingController = new TextEditingController();
    final TextEditingController _startTextEditingController = new TextEditingController();
    final TextEditingController _endTextEditingController = new TextEditingController();


    return Scaffold(
      body: Container(
        width: double.infinity,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              //*********HEADER**********
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
                                icon: Icon(Icons.add),
                                onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => NewToolsView()));
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
              //*********HEADER**********
              Padding(
                padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.only( bottom: 25.0),
                        child: Text(
                          "Google Maps",
                          style: TextStyle(
                            fontSize: 35,
                            fontFamily: "Montserrat",
                          ),
                        ),
                      ),
                    ),


                    FlatButton(
                      onPressed: (){
                        //TODO
                      },
                      child: Text(
                        "Detect My Location",
                        style: TextStyle(fontSize: 24),
                      ),
                    ),

                    Container(
                      padding: EdgeInsets.only(left: 25.0, right: 25.0),
                      decoration: BoxDecoration(
                        color: Color(0xffd8efea),
                        border: Border.all(color: Colors.grey.withOpacity(.3), width: .2,),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey[400],
                            offset: Offset(.5, 5),
                            blurRadius: 5.0,
                          ),
                        ],
                      ),
                      child: Column(
                        children: <Widget>[
                          TextField(
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(),
                              labelText: 'Label',
                            ),
                            controller: _labelTextEditingController,
                          ),

                          TextField(
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(),
                              labelText: 'Start Address',
                            ),
                            controller: _startTextEditingController,
                            //onSubmitted: _submission,
                          ),

                          TextField(
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(),
                              labelText: 'End Address',
                            ),
                            controller: _endTextEditingController,
                          ),

                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: RaisedButton(
                                  child: Text("Add"),
                                  onPressed: () async {
                                    myCommute.label = _labelTextEditingController.text;
                                    myCommute.time = await _getTravelTime(_startTextEditingController.text, _endTextEditingController.text);
                                    myCommute.startLocation = _startTextEditingController.text;
                                    myCommute.endLocation = _endTextEditingController.text;
                                    Navigator.of(context).pop(
                                      PopWithResults(
                                        fromPage: "maps_setup",
                                        toPage: "home",
                                        results: {"pop_result": myCommute},
                                      ),
                                    );

                                    //Navigator.of(context).popUntil((route) => route.isFirst, myCommute);
                                  }),
                            ),
                          ),


                        ],

                      ),
                    )
                  ],

                ),
              ),

              //*********Body**********

            ],
          ),
        ),
      ),
    );
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