import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mydailyhub/views/alarm_page.dart';
import 'package:mydailyhub/views/calendar_page.dart';
import 'package:mydailyhub/views/maps_page.dart';
import 'package:mydailyhub/views/note_page.dart';

class MenuSelector extends StatefulWidget{
  final List<String> menus;
  final int currentPage;
  MenuSelector({@required this.menus, @required this.currentPage});

  @override
  _MenuSelectorState createState() => new _MenuSelectorState();
}

class _MenuSelectorState extends State<MenuSelector> {

  int _currentIndex;
  bool _isSelected;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentPage;

  }

  List<Widget> _buildMenuList(){
    return widget.menus.map((menu){
      var index = widget.menus.indexOf(menu);
      _isSelected = _currentIndex == index;
      return Padding(
        padding: const EdgeInsets.only(right: 10.0, top: 15.0),
        child: GestureDetector(
          onTap: (){
            setState(() {
              if(index == 0){
                Navigator.of(context).popUntil((route) => route.isFirst);
              }else if(index == 1){

                Navigator.push(context, MaterialPageRoute(builder: (context) => CalendarPage()));

              }else if(index == 2){
                Navigator.push(context, MaterialPageRoute(builder: (context) => NoteViewItem()));

              }else if(index == 3){
                Navigator.push(context, MaterialPageRoute(builder: (context) => AlarmPage()));

              }else if(index == 4){
                Navigator.push(context, MaterialPageRoute(builder: (context) => MapsPage()));

              }


            });
          },
          child: Text(
              menu,
              style: TextStyle(
                color: _isSelected ? Colors.black : Colors.grey[100],
                fontSize: _isSelected ? 22 : 16,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.w700,
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
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      children: _buildMenuList(),
    );
  }

}