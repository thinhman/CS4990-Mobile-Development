import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:mydailyhub/models/Notes.dart';
import 'package:mydailyhub/models/note_card_item.dart';

var cardAspectRatio = 12.0 / 16.0;
var widgetAspectRatio = cardAspectRatio * 1.2;

class CardScrollWidget extends StatelessWidget {
  var currentNote;
  var padding = 20.0;
  var verticalInset = 20.0;
  final List<Notes> myNotes;
  //List<Widget> setupNotes = [];

  CardScrollWidget({Key key, @required this.currentNote, @required this.myNotes});

  List<Widget> setNoteText(i){
      return[
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
              padding: const EdgeInsets.only(top: 15.0, bottom: 25.0, left: 15.0),
              child: Column(
                children: <Widget>[
                  Text(myNotes[i].title, style: TextStyle(fontFamily: "Montserrat", ),),
                  Text(myNotes[i].content, style: TextStyle(fontFamily: "Montserrat", ),),
                ],
              )

          ),
        ),
      ];
  }

  @override
  Widget build(BuildContext context) {
    return new AspectRatio(
      aspectRatio: 1.2,
      child: LayoutBuilder(builder: (context, constraints) {
        var width = constraints.maxWidth;
        var height = constraints.maxHeight;

        var safeWidth = width - 2 * padding;
        var safeHeight = height - 2 * padding;

        var heightOfPrimaryCard = safeHeight;
        var widthOfPrimaryCard = heightOfPrimaryCard * cardAspectRatio;

        var primaryCardLeft = safeWidth - widthOfPrimaryCard;
        var horizontalInset = primaryCardLeft;

        List<Widget> cardList = new List();

        for (var i = 0; i < myNotes.length; i++) {
          var delta = i - currentNote;
          bool isOnRight = delta > 0;

          var start = padding + max(primaryCardLeft - horizontalInset * -delta * (isOnRight ? 15 : 1), 0.0);

          var cardItem = Positioned.directional(
            textDirection: TextDirection.rtl,
            top: padding + verticalInset * max(-delta, 0.0),
            bottom: padding + verticalInset * max(-delta, 0.0),
            start: start,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.withOpacity(.3), width: .2,),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black26,
                          offset: Offset(3.0, 6.0),
                          blurRadius: 10.0)
                    ]
                ),
                child: AspectRatio(
                  aspectRatio: cardAspectRatio,
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Container(
                        color: Color(0xFFfdfd96),
                        child: Column(
                          children: <Widget>[
                            ...setNoteText(i),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
          cardList.add(cardItem);
        }
        return Stack(
          children: cardList,
        );
      }),
    );
  }
}