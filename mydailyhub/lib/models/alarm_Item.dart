import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget alarmItem(hour, days, active){

  return Padding(
    padding: EdgeInsets.all(17.0),
    child: Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(hour, style: TextStyle(
                    color: Colors.black,
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,

                  ),
                ),
                Row(
                  children: <Widget>[
                    ...days.map((d) => Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Text(d.toString(), style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w600
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ],
            ),
            CupertinoSwitch(
              value: active,
              onChanged: (bool val) {
                print(val);
              },
              activeColor: Color(0xff65D1BA),
            ),
          ],
        ),
        SizedBox(height: 10.0,),
        SizedBox(
          height: 1.0,
          width: double.maxFinite,
          child: Container(
            color: Colors.black26,
          ),
        )
      ],
    ),
  );
}