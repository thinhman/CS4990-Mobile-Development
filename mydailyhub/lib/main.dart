import 'package:flutter/material.dart';
import 'dart:core';
import 'home.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'My Daily Hub',
        home: MyHomePage(),
        //CustomAppBar(),
        //MyHomePage(),
      //NewToolsView(),
      //MyHomePage(),
    );
  }


}





