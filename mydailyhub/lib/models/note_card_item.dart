import 'package:flutter/material.dart';
import 'package:mydailyhub/models/Notes.dart';
import 'package:mydailyhub/views/edit_notes_view.dart';

class NoteItem extends StatelessWidget{
  Notes myNotes;
  NoteItem({Key key,  @required this.myNotes}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return notesCard(context);
  }

  Widget notesCard(context){


    List<Widget> setNoteText(){
      if(myNotes.content == null || myNotes.content == ""){
        return [
          Padding(
            padding: const EdgeInsets.only(right: 8.0, top: 50.0),
            child: Icon(Icons.add_circle_outline, color: Colors.black54, size: 50.0,),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 25.0),
            child: Text("Click To Add Notes", style: TextStyle(color: Colors.black54, fontSize: 20.0),),
          ),
        ];
      } else{
        return[
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 25.0, left: 15.0),
              child: Column(
                children: <Widget>[
                  Text(myNotes.title, style: TextStyle(fontFamily: "Montserrat", ),),
                  Text(myNotes.content, style: TextStyle(fontFamily: "Montserrat", ),),
                ],
              )

            ),
          ),


        ];
      }
    }

    return Hero(
      tag: "Notes-$myNotes.tag",
      transitionOnUserGestures: true,
      child: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: Container(
          height: 200,
          width: 350,
          color: Color(0xFFfdfd96),
          child: InkWell(
            onTap: () async{
              //Notes modified;

              myNotes = await Navigator.push(context, MaterialPageRoute(builder: (context) => EditNotesView(myNotes: myNotes,)));
              //myNotes.title = modified.title;
              //myNotes.content = modified.content;
              setNoteText();
            },
            child: Column(
              children: <Widget>[
                ...setNoteText(),

              ],
            ),

          ),
        ),
      ),
    );

  }
}

