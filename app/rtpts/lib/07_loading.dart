import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_retry/http_retry.dart';
import 'dart:ui';

import 'package:rtpts/06_place.dart';
import './08_result.dart';
import './99_globals.dart' as globals;

final GlobalKey<ScaffoldState> homeScaffoldKey = new GlobalKey<ScaffoldState>();

class loading extends StatefulWidget {
  @override
  _loadingState createState() => _loadingState();
}

class _loadingState extends State<loading> {

  void _errorbar(var error){
    var snackBar;
    snackBar = SnackBar(content: Text('$error'));
    homeScaffoldKey.currentState.showSnackBar(snackBar);
  }

  Future<String> request() async {
    var response, response_de;

    globals.starting_points_tmp = globals.starting_points;
    globals.destination_tmp = globals.destination;
    /*
    try {
      response = await http.get(Uri.encodeFull(globals.link_request), headers:{"Accept":"application/json"});
    }
    on Exception catch(error) {
      print(error);
      _errorbar(error);
      Navigator.of(context).pop();
      Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new Place()));
    }
    */
    var client = new RetryClient(new http.Client());
    response = await client.read(globals.link_request);
    await client.close();
    print(response);

    try {
      response_de = json.decode(response);
    }
    on Exception catch(error) {
      print(error);
      _errorbar(error);
      Navigator.of(context).pop();
      Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new Place()));
    }

    globals.result = response_de;
    Navigator.of(context).pop();
    Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new Result()));
  }

  @override
  Widget build(BuildContext context) {
    request();
    return new WillPopScope(
        onWillPop: () async => false,
        child: MaterialApp(
            key: homeScaffoldKey,
            home: Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.pinkAccent,
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