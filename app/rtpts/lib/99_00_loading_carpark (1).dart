import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '99_globals.dart' as globals;
import './04_list-of-areas.dart';

class loading_carpark extends StatefulWidget {
  @override
  _loading_carpark_State createState() => _loading_carpark_State();
}

class _loading_carpark_State extends State<loading_carpark> {
  Future<String> request() async {
/*
    var response_01, response_02;

    response_01 = await http.get(Uri.encodeFull(globals.carpark_place_url), headers:{"Accept":"application/json"});


    try {
      response_02 = await http.get(Uri.encodeFull(globals.carpark_vac_url), headers:{"Accept":"application/json"});
    }
    on Exception catch(error) {

    }

    var response_de_place = json.decode(response_01.body);
    globals.carpark_place = response_de_place;
    print("finished");
    //var response_de_vac = json.decode(response_02.body);
    //globals.carpark_vac = response_de_vac;
*/
    Navigator.of(context).pop();
    Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new Area_display()));
  }


  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () async => false,
        child: MaterialApp(
            home: Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.blue,
                ),
                body: Container(
                  alignment: Alignment(0.0, 0.0),
                  child: new Container(
                    child: new CircularProgressIndicator(),
                  ),
                )
            )
        )
    );

  }
}