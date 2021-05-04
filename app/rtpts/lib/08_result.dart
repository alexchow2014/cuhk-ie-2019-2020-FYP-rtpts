import 'package:flutter/material.dart';
import 'dart:ui';

import './01_mainpage.dart';
import './02_place-input.dart';

import './08_01_Driving.dart';
import './08_02_Transit.dart';
import './99_globals.dart' as globals;

class Result extends StatefulWidget {
  @override
  _resultState createState() => _resultState();
}
class _resultState extends State<Result> {
  @override
  Widget build(BuildContext context) {
    var price_tmp_01 = globals.result[0]["total_fee"];
    var price_tmp1_01 = double.parse("$price_tmp_01");
    var price_01 = price_tmp1_01.round();

    var price_tmp_02 = globals.result[1]["total_fee"];
    var price_tmp1_02 = double.parse("$price_tmp_02");
    var price_02 = price_tmp1_02.round();

    var price_tmp_03 = globals.result[2]["total_fee"];
    var price_tmp1_03 = double.parse("$price_tmp_03");
    var price_03 = price_tmp1_03.round();

    var time_tmp_01 = globals.result[0]["total_time"];
    var time_tmp1_01 = double.parse("$time_tmp_01")/60;
    var time_01 = time_tmp1_01.round();

    var time_tmp_02 = globals.result[1]["total_time"];
    var time_tmp1_02 = double.parse("$time_tmp_02")/60;
    var time_02 = time_tmp1_02.round();

    var time_tmp_03 = globals.result[2]["total_time"];
    var time_tmp1_03 = double.parse("$time_tmp_03")/60;
    var time_03 = time_tmp1_03.round();

    print(globals.starting_points);
    print(globals.destination);

    return WillPopScope(
        onWillPop: () {
          Navigator.of(context).pop();
          Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new Homepage()));
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('Select your choice'), backgroundColor: Colors.pinkAccent,
            leading: IconButton(icon:Icon(Icons.arrow_back),
                onPressed:() {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new Homepage()));
                },
              )
          ),
          body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 5.0, top: 10.0, right: 5.0, bottom: 10.0),
                    child: Column(
                      children: <Widget>[
                        new Container(
                          margin: EdgeInsets.only(bottom: 10.0),
                          child: new Row(
                            children: <Widget>[
                              new Icon(Icons.place, size: 30.0),
                              new Flexible(
                                child: Text(globals.starting_points_tmp ,style: TextStyle(fontStyle: FontStyle.italic, fontSize: 20),textAlign: TextAlign.left,),
                              ),
                            ],
                          ),
                        ),
                        new Container(
                          child: Icon(Icons.arrow_downward, size: 45.0),
                        ),
                        new Container(
                          margin: EdgeInsets.only(top: 10.0),
                          child: new Row(
                            children: <Widget>[
                              new Icon(Icons.place, size: 30.0),
                              new Flexible(
                                child: Text(globals.destination_tmp ,style: TextStyle(fontStyle: FontStyle.italic, fontSize: 20),textAlign: TextAlign.left,),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.red,
                    height: 2.5,
                  ),
                  InkWell(
                    onTap: () {
                      globals.choice = 1;
                      Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new driving()));
                    },
                    child: new Container(
                        color: Color.fromARGB(0, 0, 0, 1),
                        padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                        margin: EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0, bottom: 10.0),
                        child: Column(
                            children: <Widget>[
                              new Container(
                                child: Row(
                                    children: <Widget>[
                                      Expanded(
                                          child: Container(
                                            alignment: Alignment.topLeft,
                                            child: Text('Shortest Time', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 30),),
                                          )
                                      ),
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.topRight,
                                          child: Text('\$'+ '$price_01', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 30),),
                                        ),
                                      ),
                                    ]
                                ),
                              ),
                              new Container(
                                alignment: Alignment.topRight,
                                child: Text('$time_01'+' mins', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 30),),
                              ),
                            ]
                        )
                    ),
                  ),
                  Container(
                    color: Colors.red,
                    height: 2.5,
                  ),
                  InkWell(
                    onTap: () {
                      globals.choice = 2;
                      Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new driving()));
                    },
                    child: new Container(
                        color: Color.fromARGB(0, 0, 0, 1),
                        padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                        margin: EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0, bottom: 10.0),
                        child: Column(
                            children: <Widget>[
                              new Container(
                                child: Row(
                                    children: <Widget>[
                                      Expanded(
                                          child: Container(
                                            alignment: Alignment.topLeft,
                                            child: Text('Cheapest Fee', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 30),),
                                          )
                                      ),
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.topRight,
                                          child: Text('\$'+'$price_02', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 30),),
                                        ),
                                      ),
                                    ]
                                ),
                              ),
                              new Container(
                                alignment: Alignment.topRight,
                                child: Text('$time_02'+' mins', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 30),),
                              ),
                            ]
                        )
                    ),
                  ),
                  Container(
                    color: Colors.red,
                    height: 2.5,
                  ),
                  InkWell(
                    onTap: () {
                      globals.choice = 3;
                      Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new driving()));
                    },
                    child: new Container(
                        color: Color.fromARGB(0, 0, 0, 1),
                        padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                        margin: EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0, bottom: 10.0),
                        child: Column(
                            children: <Widget>[
                              new Container(
                                child: Row(
                                    children: <Widget>[
                                      Expanded(
                                          child: Container(
                                            alignment: Alignment.topLeft,
                                            child: Text('Best Choices', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 30),),
                                          )
                                      ),
                                      Expanded(
                                        child: Container(
                                          alignment: Alignment.topRight,
                                          child: Text('\$'+'$price_03', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 30),),
                                        ),
                                      ),
                                    ]
                                ),
                              ),
                              new Container(
                                alignment: Alignment.topRight,
                                child: Text('$time_03'+' mins', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 30),),
                              ),
                            ]
                        )
                    ),
                  ),
                  Container(
                    color: Colors.red,
                    height: 2.5,
                  ),
                ],
              )
          ),
        )
    );
  }
}