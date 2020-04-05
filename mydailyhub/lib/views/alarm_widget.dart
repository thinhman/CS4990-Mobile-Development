import 'package:flutter/material.dart';
import 'package:mydailyhub/select_tools.dart';
import 'package:intl/intl.dart';
import 'package:mydailyhub/views/menu_selector.dart';

class AlarmItemView extends StatefulWidget{
  @override
  _AlarmItemViewState createState() => _AlarmItemViewState();
}

class _AlarmItemViewState extends State<AlarmItemView>{
  String _timeString;

  @override
  void initState(){
    super.initState();
    //myNotes = Notes(null);
    _timeString = _formatDateTime(DateTime.now());

  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('hh:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.white,
          child:  SingleChildScrollView(
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
                                  iconSize: 50,
                                  color: Colors.grey[200],
                                  icon: Icon(Icons.add),
                                  onPressed: () async {
                                    Widget _newTool;
                                    _newTool = await Navigator.push(context, MaterialPageRoute(builder: (context) => NewToolsView()));
                                    if(_newTool != null){
                                      setState(() {
                                        //_tools.add(_newTool);
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

                Container(
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
                                color: Colors.grey[200],
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
    );

  }

}