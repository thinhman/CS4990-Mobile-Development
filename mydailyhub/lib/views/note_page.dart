import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mydailyhub/models/Notes.dart';
import 'package:mydailyhub/views/edit_notes_view.dart';
import 'package:mydailyhub/views/menu_selector.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NoteViewItem extends StatefulWidget{
  @override
  _NoteViewState createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteViewItem>{
  var _currentNote;
  List<Notes> _allNotes = [];
  Notes _myNotes;
  SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _currentNote = 0;
    //_myNotes = Notes(_allNotes.length, "Untitled..", "");
    initPrefs();
  }

  initPrefs() async{
    prefs = await SharedPreferences.getInstance();
    setState(() {
      List<Notes> temp = List<Notes>.from(json.decode(prefs.getString("notes") ?? "{}").map((x) => Notes.fromJson(x)));
      if(temp != null) {
        _allNotes = temp;
      }else{
        _allNotes.add(Notes(_allNotes.length, "Untitled..", ""));
      }
    });

  }

  void savingNotes(){
    prefs.setString("notes", notesToJson(_allNotes));
  }

  String notesToJson(List<Notes> data) =>
      json.encode(List<dynamic>.from(data.map((x) => toJson(x))));

  Map<String, dynamic> toJson(Notes myNotes) => {
    "tag": myNotes.tag,
    "title": myNotes.title,
    "content": myNotes.content,
  };



  Widget notesCard(context, note){

    List<Widget> setNoteText(){
      return[
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(top: 15.0, bottom: 25.0, left: 15.0),
            child: Text(note.title, style: TextStyle(fontFamily: "Montserrat", ),),
          ),
        ),

        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.only(top: 15.0, bottom: 25.0, left: 15.0),
            child: Text(note.content, style: TextStyle(fontFamily: "Montserrat", ),),
          ),
        ),



      ];
//      if(myNotes.content == null || myNotes.content == ""){
//        return [
//          Padding(
//            padding: const EdgeInsets.only(right: 8.0, top: 50.0),
//            child: Icon(Icons.add_circle_outline, color: Colors.black54, size: 50.0,),
//          ),
//          Padding(
//            padding: const EdgeInsets.only(top: 25.0),
//            child: Text("Click To Add Notes", style: TextStyle(color: Colors.black54, fontSize: 20.0),),
//          ),
//        ];
//      } else{
//        return[
//          Align(
//            alignment: Alignment.topLeft,
//            child: Padding(
//              padding: const EdgeInsets.only(top: 15.0, bottom: 25.0, left: 15.0),
//              child: Text(myNotes.title, style: TextStyle(fontFamily: "Montserrat", ),),
//            ),
//          ),
//
//          Text(myNotes.content, style: TextStyle(fontFamily: "Montserrat", ),)
//
//        ];
//      }
    }

    return Hero(
      tag: note.tag,
      transitionOnUserGestures: true,
      child: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: Container(
          height: 200,
          width: 350,
          color: Color(0xFFfdfd96),
          child: InkWell(
            child: Column(
              children: <Widget>[
                ...setNoteText(),

              ],
            ),
            onTap: () async{
              _myNotes = await Navigator.push(context, MaterialPageRoute(builder: (context) => EditNotesView(myNotes: note,)));
              //myNotes.title = modified.title;
              //myNotes.content = modified.content;
              setState(() {
                setNoteText();
              });

            },
          ),
        ),
      ),
    );

  }

  List<Widget> buildNotes(){
    if(_allNotes.length != null){
      return _allNotes.map((n){
        return notesCard(context, n);
      }).toList();
    }else{
      return [];
    }


  }

  @override
  Widget build(BuildContext context) {

    PageController controller = PageController(initialPage: 4);
    controller.addListener(() {
      setState(() {
        _currentNote = controller.page;
      });
    });

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
                                    currentPage: 2,
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
                              "My Notes",
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
                          padding: const EdgeInsets.only(top: 75.0, left: 25.0),
                          child: Container(
                            width: w * .9,
                            decoration: BoxDecoration(
                              color: Colors.white70,
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
                                Hero(
                                  tag: _allNotes.length,
                                  transitionOnUserGestures: true,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 15.0),
                                    child: Container(
                                      height: 200,
                                      width: 350,
                                      color: Color(0xFFfdfd96),
                                      child: InkWell(
                                        child: Column(
                                          children: <Widget>[
                                            Padding(
                                              padding: const EdgeInsets.only(right: 8.0, top: 30.0),
                                              child: Icon(Icons.add_circle_outline, color: Colors.black54, size: 50.0,),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(top: 25.0),
                                              child: Text("Click To Add Notes", style: TextStyle(color: Colors.black54, fontSize: 20.0),),
                                            ),

                                          ],
                                        ),
                                        onTap: () async{
                                          Notes newNote = Notes(_allNotes.length, "Untitled..", "");
                                          newNote = await Navigator.push(context, MaterialPageRoute(builder: (context) => EditNotesView(myNotes: newNote,)));
                                          //myNotes.title = modified.title;
                                          //myNotes.content = modified.content;
                                          if(newNote != null){
                                            setState(() {
                                              _allNotes.add(newNote);
                                              savingNotes();
                                            });
                                          }


                                        },
                                      ),
                                    ),
                                  ),
                                ),

                                ...buildNotes(),
                              ],
                            ),
                          ),
                        ),




                      ],
                    );
                  },
                ),

//                Container(
//                  width: double.infinity,
//                  child: LayoutBuilder(
//                    builder: (cx, cy){
//                      double w = cy.maxWidth;
//                      double h = cy.maxHeight;
//
//                      return Stack(
//                        children: <Widget>[
//                          Container(
//                            height: 350,
//                            width: double.infinity,
//                            child:
//                            Align(
//                              alignment: Alignment.topRight,
//                              child: Padding(
//                                padding: const EdgeInsets.only(left: 90.0),
//                                child: Container(
//                                  height: 450,
//                                  width: double.infinity,
//                                  decoration: BoxDecoration(
//                                    color: Color(0xffd8efea),
//                                    border: Border.all(color: Colors.grey.withOpacity(.3), width: .2,),
//                                    boxShadow: [
//                                      BoxShadow(
//                                        color: Colors.grey[200],
//                                        offset: Offset(.5, 5),
//                                        blurRadius: 5.0,
//                                      ),
//                                    ],
//                                  ),
//                                  child: Padding(
//                                    padding: const EdgeInsets.only(left: 20.0, top: 5.0),
//                                    child: Text("Notes",
//                                      style: TextStyle(
//                                        fontFamily: "Montserrat",
//                                        fontSize: 30.0,
//                                      ),
//                                    ),
//                                  ),
//
//                                ),
//                              ),
//                            ),
//                          ),
//
//                          Padding(
//                            padding: const EdgeInsets.only(left: 10, top: 50.0,),
//                            child: Container(
//                              child: Row(
//                                children: <Widget>[
//                                  Expanded(
//                                    child: LayoutBuilder(
//                                        builder: (cx, cy){
//                                          return Stack(
//                                            children: <Widget>[
//                                              CardScrollWidget(currentNote: _currentNote),
//                                              Positioned.fill(
//                                                child: PageView.builder(
//                                                  itemCount: 4,
//                                                  controller: controller,
//                                                  reverse: true,
//                                                  itemBuilder: (context, index) {
//                                                    return Container();
//                                                    //notesCard(context);
//                                                  },
//                                                ),
//                                              ),
//                                            ],
//                                          );
//                                        }),
//                                  ),
//
//                                ],
//                              ),
//                            ),
//
//                          ),
//                        ],
//                      );
//                    },
//                  ),
//
//                ),
              ],
            ),
          ),
        )
    );

  }



}