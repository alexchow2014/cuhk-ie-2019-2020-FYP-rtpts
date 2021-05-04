import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


import './01_mainpage.dart';
import './05_01_car-type-settings.dart';
import './05_02_oil-settings.dart';
import './05_03_searching-distance-settings.dart';
import './99_globals.dart' as globals;

Map<String, dynamic> user;

class Settings extends StatefulWidget {
  @override
  _Settings createState() {
    return new _Settings();
  }
}

class _Settings extends State<Settings> {

  @override
  Widget build(BuildContext context) {

    return new WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop();
          Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new Homepage()));
        },
        child: new Scaffold(
          appBar: new AppBar(title: Text('Settings'),),
          body: new Column(
            children: <Widget>[
              new Container(
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new Car_Settings()));
                  },
                  child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: Icon(Icons.directions_car, size: 40.0,),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Container(
                            child: Text("Car type", style: TextStyle(color: Colors.black, fontSize: 25.0,)),
                          ),
                        ),
                      ]
                  ),
                ),
                margin: const EdgeInsets.only(top: 10.0 ,left: 10.0, right: 10.0, bottom: 10.0),
              ),
              new Container(
                color: Color.fromRGBO(204, 204, 204, 1.0),
                height: 1.0,
                margin: const EdgeInsets.only(top: 5.0 ,left: 15.0, right: 15.0, bottom: 5.0),
              ),
              new Container(
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new Oil_Settings()));
                  },
                  child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: Image.asset('./assets/oil.svg', height: 45.0,),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Container(
                            child: Text("Oil consumption", style: TextStyle(color: Colors.black, fontSize: 25.0,)),
                          ),
                        ),
                      ]
                  ),
                ),
                margin: const EdgeInsets.only(top: 10.0 ,left: 10.0, right: 10.0, bottom: 10.0),
              ),
              new Container(
                color: Color.fromRGBO(204, 204, 204, 1.0),
                height: 1.0,
                margin: const EdgeInsets.only(top: 5.0 ,left: 15.0, right: 15.0, bottom: 5.0),
              ),
              new Container(
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new Secrch_Settings()));
                  },
                  child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Container(
                            child: Icon(Icons.search, size: 40.0,),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Container(
                            child: Text("Searching distance", style: TextStyle(color: Colors.black, fontSize: 25.0,)),
                          ),
                        ),
                      ]
                  ),
                ),
                margin: const EdgeInsets.only(top: 10.0 ,left: 10.0, right: 10.0, bottom: 10.0),
              ),

            ],
          ),
        )
    );
  }
}