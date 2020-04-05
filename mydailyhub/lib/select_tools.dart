import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mydailyhub/maps_setup.dart';
import 'package:mydailyhub/models/Commute.dart';
import 'package:mydailyhub/pop_with_result.dart';
import 'package:mydailyhub/views/calendar_widget.dart';
import 'package:mydailyhub/views/home_alarm.dart';
import 'package:mydailyhub/views/note_widget.dart';

class NewToolsView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final _screenSize =  MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Select Tool'),
      ),

      body: ListView(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0,),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24.0),
              child: InkWell(
                onTap: () async {
                  Commute myCommute;
                  myCommute = await _awaitCommuteTime(context);
                  if(myCommute != null){
                    Navigator.of(context).pop(<String, Widget> {"map": buildCommuteTool(context, myCommute)});
                  }
                  else
                    Navigator.of(context).pop();

//                    (){
//                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewTransitTimeView())).then((results) {
//                    if (results is PopWithResults) {
//                      PopWithResults popResult = results;
//                      if (popResult.toPage == "select_tools") {
//                        //TODO do stuff
//                      } else{
//                        Navigator.of(context).pop(results);
//                      }
//                    }
//                  });
                },
                child: Container(
                  height: _screenSize.height / 4,
                  color: Colors.greenAccent[100],
                  child: new Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.bottomRight,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24.0),
                          child: FractionallySizedBox(
                            widthFactor: 0.80,
                            heightFactor: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.greenAccent[100],
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstATop),
                                  image: new NetworkImage(
                                    'https://images.unsplash.com/photo-1503221043305-f7498f8b7888?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=735&q=80',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      Positioned(
                        left: 20.0,
                        top: 20.0,
                        child: const Center(child: Text('Google Maps', style: TextStyle(fontSize: 30.0),)),
                      ),
                    ],
                  ),
                ),
              ) ,

            ),
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 20.0,),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24.0),
              child: InkWell(
                onTap: (){
                  Navigator.of(context).pop(<String, Widget> {"note": HomeNoteItem()});
                },
                child: Container(
                  height: _screenSize.height / 4,
                  color: Colors.yellow[200],
                  child: new Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.bottomRight,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24.0),
                          child: FractionallySizedBox(
                            widthFactor: 0.80,
                            heightFactor: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.yellow[200],
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstATop),
                                  image: new NetworkImage(
                                    'https://images.unsplash.com/photo-1441034281545-78296c3a6934?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=750&q=80',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      Positioned(
                        left: 20.0,
                        top: 20.0,
                        child: const Center(child: Text('Notes', style: TextStyle(fontSize: 30.0),)),
                      ),
                    ],
                  ),
                ),

              ),

            ),

          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24.0),
              child: InkWell(
                onTap: (){
                  Navigator.of(context).pop(<String, Widget> {"calendar": CalendarItem()});
                },
                child: Container(
                  height: _screenSize.height / 4,
                  color: Colors.pink[100],
                  child: new Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.bottomRight,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24.0),
                          child: FractionallySizedBox(
                            widthFactor: 0.80,
                            heightFactor: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.pink[100],
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstATop),
                                  image: new NetworkImage(
                                    'https://images.unsplash.com/photo-1543168256-4ae2229821f1?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=350&q=80',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      Positioned(
                        left: 20.0,
                        top: 20.0,
                        child: const Center(child: Text('Calendar', style: TextStyle(fontSize: 30.0),)),
                      ),
                    ],
                  ),

                ),
              ),

            ),
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24.0),
              child: InkWell(
                onTap: (){
                  Navigator.of(context).pop(<String, Widget> {"alarm": HomeAlarmView()});
                },
                child: Container(
                  height: _screenSize.height / 4,
                  color: Colors.deepPurpleAccent[100],
                  child: new Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.bottomRight,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24.0),
                          child: FractionallySizedBox(
                            widthFactor: 0.80,
                            heightFactor: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.deepPurpleAccent[100],
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.dstATop),
                                  image: new NetworkImage(
                                    'https://images.unsplash.com/photo-1549675584-c22bde15df72?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=752&q=80',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      Positioned(
                        left: 20.0,
                        top: 20.0,
                        child: const Center(child: Text('Alarms', style: TextStyle(fontSize: 30.0),)),
                      ),
                    ],
                  ),
                ),

              ),

            ),
          ),

        ],
      ),

//      Center(
//        child: Column(
//          mainAxisAlignment: MainAxisAlignment.center,
//          children: <Widget>[
//            RaisedButton(
//              child: Text("Google Maps"),
//              onPressed: (){
//                Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewTransitTimeView())).then((results) {
//                  if (results is PopWithResults) {
//                    PopWithResults popResult = results;
//                    if (popResult.toPage == "select_tools") {
//                      //TODO do stuff
//                    } else{
//                      Navigator.of(context).pop(results);
//                    }
//                  }
//                });
////                Navigator.push(
////                  context,
////                  MaterialPageRoute(builder: (context) => NewTransitTimeView()),
////                );
//              }
//            )
//          ],
//        ),
//      ),
    );
  }

  Widget buildCommuteTool(BuildContext context, Commute myCommute) {
    return new Container(
      width: double.infinity,
      height: 450.0,
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
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: <Widget>[
                                    //GOOGLE MAPS
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                                      child: Row(
                                        children: <Widget>[
                                          Text(myCommute.label, style: new TextStyle(fontSize: 30.0),),
                                          Spacer(),
                                        ],
                                      ),
                                    ),

                                    //TRANSIT TIME
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                                      child: Row(
                                        children: <Widget>[
                                          Text(myCommute.time, style: new TextStyle(fontSize: 24.0),),
                                        ],
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
}