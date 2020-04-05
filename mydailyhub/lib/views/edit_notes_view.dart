import 'package:flutter/material.dart';
import 'package:mydailyhub/models/Notes.dart';

class EditNotesView extends StatefulWidget{
  final Notes myNotes;
  EditNotesView({Key key, @required this.myNotes});
  @override
  _EditNotesViewState createState() => _EditNotesViewState();

}

class _EditNotesViewState extends State<EditNotesView> {

  TextEditingController _notesController;
  TextEditingController _titleController;
  Notes _myNotes;

  @override
  void initState(){
    super.initState();
    _notesController = new TextEditingController(text: widget.myNotes.content);
    _titleController = new TextEditingController(text: widget.myNotes.title);
    _myNotes = widget.myNotes;

  }

  @override
  Widget build(BuildContext context) {


    // TODO: implement build
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Color(0xFFfdfd96),
        child: Hero(
          tag: "Notes-$widget.tag",
          transitionOnUserGestures: true,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  buildHeading(context),
                  buildNotesText(context),
                  buildSubmitButton(context),
                ],
              ),
            ),
          ),
        ),

      ),
    );
  }

  Widget buildHeading(context){
    return Material(
      color: Color(0xFFfdfd96),
      child: Padding(
        padding: const EdgeInsets.only(left:20.0, top: 10.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                maxLines: 1,
                controller: _titleController,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Title',
                ),
                cursorColor: Colors.black,
                style: TextStyle(color: Colors.black),
              ),
            ),
            FlatButton(
              child: Icon(Icons.close, color: Colors.black, size: 30.0,),
              onPressed: (){
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      ),
    );
  }

  Widget buildNotesText(context){
    return Material(
      color: Color(0xFFfdfd96),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: TextField(
          maxLines: null,
          controller: _notesController,
          decoration: InputDecoration(
            border: InputBorder.none,
          ),
          cursorColor: Colors.black,
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  Widget buildSubmitButton(context){

    return Material(
      color: Color(0xFFfdfd96),
      child: RaisedButton(
        child: Text("Save"),
        color: Colors.greenAccent,
        onPressed: ()async{
//          String content = _notesController.text;
//          Navigator.pop(context, content);
          setState(() {
            _myNotes.title = _titleController.text;
            _myNotes.content = _notesController.text;
            Navigator.pop(context, _myNotes);
          });


        },
      ),
    );
  }
}