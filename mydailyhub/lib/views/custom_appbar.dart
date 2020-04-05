import 'package:flutter/material.dart';
import 'package:mydailyhub/home.dart';
import 'package:mydailyhub/maps_setup.dart';
import 'package:mydailyhub/select_tools.dart';
import 'package:mydailyhub/views/alarm_widget.dart';
import 'package:mydailyhub/views/calendar_page.dart';
import 'package:mydailyhub/views/note_page.dart';

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({ Key key }) : super(key: key);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> with SingleTickerProviderStateMixin{
  List<Widget> _tools = []; //add tool widgets here

  List<Widget> _tabPages = <Widget>[
    new MyHomePage(),
    new CalendarPage(),
    new NoteViewItem(),
    new AlarmItemView(),
    new NewTransitTimeView(),
  ];

  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: _tabPages.length, initialIndex: 0);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size(double.infinity, 200.0),
          child: SizedBox(
            height: 200,
            width: double.infinity,
            child: LayoutBuilder(
              builder: (cx, cy){
                double w = cy.maxWidth;

                return Stack(
                  children: <Widget>[
                    Container(
                      width: w * .9,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Color(0xFFf5c9c9),
                        border: Border.all(color: Colors.grey.withOpacity(.3), width: .2,),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            offset: Offset(.5, 5),
                            blurRadius: 5.0,
                          ),
                        ],
                      ),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 45.0),
                          child: TabBar(
                            controller: _tabController,
                            isScrollable: true,
                            tabs: <Tab>[
                              Tab(
                                child: Text("Home",
                                  style: TextStyle(
                                    fontFamily: "Montserrat",
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w400,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black12,
                                        offset: Offset(.5, 5),
                                        blurRadius: 5.0,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Tab(
                                child: Text("Calendar",
                                  style: TextStyle(
                                    fontFamily: "Montserrat",
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w400,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black12,
                                        offset: Offset(.5, 5),
                                        blurRadius: 5.0,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Tab(
                                child: Text("Notes",
                                  style: TextStyle(
                                    fontFamily: "Montserrat",
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w400,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black12,
                                        offset: Offset(.5, 5),
                                        blurRadius: 5.0,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Tab(
                                child: Text("Alarm",
                                  style: TextStyle(
                                    fontFamily: "Montserrat",
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w400,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black12,
                                        offset: Offset(.5, 5),
                                        blurRadius: 5.0,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Tab(
                                child: Text("Maps",
                                  style: TextStyle(
                                    fontFamily: "Montserrat",
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w400,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black12,
                                        offset: Offset(.5, 5),
                                        blurRadius: 5.0,
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ),


                      ),



                    ),
//                  Align(
//                    alignment: Alignment.topRight,
//                    child:
//                  ),

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
//                          child: MenuSelector(
//                            menus: ["Home", "Calendar", "Notes", "Alarm", "Maps"],
//                            currentPage: 0,
//                          ),
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
                                  _tools.add(_newTool);

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
        ),


        body: TabBarView(
          controller: _tabController,
          children: _tabPages,
        ),
      );

  }

}