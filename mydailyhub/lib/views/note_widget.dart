import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mydailyhub/models/Notes.dart';
import 'package:mydailyhub/views/card_scroll_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeNoteItem extends StatefulWidget{
  @override
  _HomeNoteState createState() => _HomeNoteState();
}

class _HomeNoteState extends State<HomeNoteItem>{
  var _currentNote;
  List<Notes> _allNotes = [];
  SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    initPrefs();

  }

  initPrefs() async{
    prefs = await SharedPreferences.getInstance();
    setState(() {
      List<Notes> temp = List<Notes>.from(json.decode(prefs.getString("notes")).map((x) => Notes.fromJson(x)));
      if(temp != null) {
        _allNotes = temp;
      }else{
        _allNotes.add(Notes(_allNotes.length, "Untitled..", ""));
      }
    });

    _currentNote = _allNotes.length - 1;

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

  @override
  Widget build(BuildContext context) {

    PageController controller = PageController(initialPage: _allNotes.length);
    controller.addListener(() {
      setState(() {
        _currentNote = controller.page;
      });
    });

    return Container(
      width: double.infinity,
      child: LayoutBuilder(
        builder: (cx, cy){

          return Stack(
            children: <Widget>[
              Container(
                height: 350,
                width: double.infinity,
                child:
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 90.0),
                    child: Container(
                      height: 450,
                      width: double.infinity,
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
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0, top: 5.0),
                        child: Text("Notes",
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
                padding: const EdgeInsets.only(left: 10, top: 50.0,),
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: LayoutBuilder(
                            builder: (cx, cy){
                              return Stack(
                                children: <Widget>[
                                  CardScrollWidget(currentNote: _currentNote, myNotes: _allNotes,),
                                  Positioned.fill(
                                    child: PageView.builder(
                                      itemCount: _allNotes.length,
                                      controller: controller,
                                      reverse: true,
                                      itemBuilder: (context, index) {
                                        return Container();
                                        //notesCard(context);
                                      },
                                    ),
                                  ),
                                ],
                              );
                            }),
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

}