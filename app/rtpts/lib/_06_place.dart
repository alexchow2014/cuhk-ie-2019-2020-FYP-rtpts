import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';


import './01_mainpage.dart';
import './02_place-input.dart';
import './03_login.dart';
import './04_list-of-areas.dart';
import './05_00_settings.dart';
import './05_01_car-type-settings.dart';
import './05_02_oil-settings.dart';
import './05_03_searching-distance-settings.dart';

import '99_globals.dart' as globals;

var carpark_place, carpark_vac;

class Place extends StatefulWidget {
  @override
  _Place createState() => _Place();
}

class _Place extends State<Place> {
  GoogleMapController mapController;
  Set<Marker> markers = {};
  var response, response_02;

  request() async {
    await request_part_01();
    await request_part_02();
    await Markers();
    print("finished");
    return 1;
  }

  Future request_part_01() async {
    try {
      response = await http.get(Uri.encodeFull('https://api.data.gov.hk/v1/carpark-info-vacancy'), headers:{"Accept":"application/json"});
      var response_de_place = json.decode(response.body);
      carpark_place = response_de_place;
    }
    on Exception catch(error) {
      print("error 01");
      print(error);
    }
    print("1 finished");
    return 1;
  }
  Future request_part_02() async {
    try {
      response_02 = await http.get(Uri.encodeFull('https://api.data.gov.hk/v1/carpark-info-vacancy?data=vacancy'), headers:{"Accept":"application/json"});
      var response_de_vac = json.decode(response_02.body);
      carpark_vac = response_de_vac;
    }
    on Exception catch(error) {
      print("error 02");
      print(error);
    }
    print("2 finished");
  }
  Markers() async{
    var i; var max = carpark_place['results'].length;  var s = 0;
    for (i = 0; i < max; i++) {
      int num;
      var place = LatLng(carpark_place['results'][i]['latitude'], carpark_place['results'][i]['longitude']);
      var tmp = carpark_vac['results'][i]['privateCar'][0]['vacancy'];
      if (!(tmp is int)) {num = int.parse(tmp);}
      else {num = tmp;}

      if (num == -1) {
        await markers.add(Marker(
          markerId: MarkerId('$i'),
          position: place,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
          onTap: () {
            _onClicked();
          },
        ));
      }
      else if (num == 0) {
        await markers.add(Marker(
          markerId: MarkerId('$i'),
          position: place,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          onTap: () {
            _onClicked();
          },
        ));
      }
      else if (num <= 10 && num > 0) {
        await markers.add(Marker(
          markerId: MarkerId('$i'),
          position: place,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
          onTap: () {
            _onClicked();
          },
        ));
      }
      else {
        await markers.add(Marker(
          markerId: MarkerId('$i'),
          position: place,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          onTap: () {
            _onClicked();
          },
        ));
      }
      s++;
    }
    //print(markers);
    print("Markers finished");
  }

  void _onClicked() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: 200,
            color: Colors.white,
            child: Column(
              children: <Widget>[
                new Container(
                  child: Text('Test'),
                ),
              ],
            ),
          );
        }
    );
  }

  @override
  void initState() {
    super.initState();
    request().then((result) {
      print(result);
      setState(() {

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    void _onMapCreated(GoogleMapController controller) async{
      mapController = controller;
    }
    //request_part_01();
    return new WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop();
        },
        child: new Scaffold(
          resizeToAvoidBottomPadding: true,
          appBar: new AppBar(title: Text('Searching Parking Area'),backgroundColor: Colors.red,),
          drawer: new Drawer(
              child: new ListView(
                children: <Widget>[
                  new UserAccountsDrawerHeader(
                    accountName: null,
                    accountEmail: null,
                    decoration: new BoxDecoration(
                      image: new DecorationImage(
                        fit: BoxFit.fill,
                        image: new NetworkImage("https://images.unsplash.com/photo-1536599018102-9f803c140fc1?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1400&q=80"),
                      ),
                    ),
                  ),
                  new ListTile(
                      title: new Text("Start finding parking area"),
                      onTap: () {
                        //Navigator.pop(context);
                        //Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new place()));
                      }
                  ),
                  new ListTile(
                      title: new Text("Available parking areas"),
                      onTap: () {
                        //Navigator.pop(context);
                        //Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new place()));
                      }
                  ),
                  new Container(
                    margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                    height: 1.0,
                    color: Color.fromRGBO(0, 0, 0, 0.5),
                  ),
                  new ListTile(
                      title: new Text("Settings"),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new Settings()));
                      }
                  ),
                  new ListTile(
                      title: new Text("Login"),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new Login()));
                      }
                  ),
                ],
              )
          ),
          body: new Stack(
            fit: StackFit.expand,
            children: <Widget>[
              new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Container(
                    height: 625,
                    child: GoogleMap(
                      zoomGesturesEnabled:true,  //縮放手勢
                      onMapCreated: _onMapCreated,
                      markers: markers,
                      mapType: MapType.normal,
                      compassEnabled: true,  //指北針
                      initialCameraPosition: CameraPosition(
                          target: LatLng(22.5, 114.1),  //中心點座標
                          zoom: 10.0,  //Camera縮放尺寸，越近數值越大，越遠數值越小，預設為0
                          bearing: 0,  //Camera旋轉的角度，方向為逆時針轉動，預設為0
                          tilt: 0  //Camera侵斜角度
                      ),
                    ),
                  ),
                  new Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.only(top: 5.0, left: 10.0, bottom: 5.0),
                    height: 20,
                    child: Text('Vacancy status',style: new TextStyle(fontSize: 14,),),
                  ),
                  new Container(
                    margin: const EdgeInsets.only(left: 5.0, right: 5.0),
                    height: 35,
                    child: Row(
                      children: <Widget>[
                        new Expanded(
                          flex: 1,
                          child: new Container(
                            margin: const EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0, bottom: 5.0),
                            color: Color.fromRGBO(127, 0, 255, 1.0),
                          ),
                        ),
                        new Expanded(
                          flex: 2,
                          child: new Container(
                            margin: const EdgeInsets.only(top: 5.0, bottom: 5.0, left: 5.0),
                            child: Text('no data',style: new TextStyle(fontSize: 14,),),
                          ),
                        ),
                        new Expanded(
                          flex: 1,
                          child: new Container(
                            margin: const EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0, bottom: 5.0),
                            color: Color.fromRGBO(255, 0, 0, 1.0),
                          ),
                        ),
                        new Expanded(
                          flex: 2,
                          child: new Container(
                            margin: const EdgeInsets.only(top: 5.0, bottom: 5.0, left: 5.0),
                            child: Text('0',style: new TextStyle(fontSize: 14,),),
                          ),
                        ),
                        new Expanded(
                          flex: 1,
                          child: new Container(
                            margin: const EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0, bottom: 5.0),
                            color: Color.fromRGBO(255, 255, 0, 1.0),
                          ),
                        ),
                        new Expanded(
                          flex: 2,
                          child: new Container(
                            margin: const EdgeInsets.only(top: 5.0, bottom: 5.0, left: 5.0),
                            child: Text('1 to 10',style: new TextStyle(fontSize: 14,),),
                          ),
                        ),
                        new Expanded(
                          flex: 1,
                          child: new Container(
                            margin: const EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0, bottom: 5.0),
                            color: Color.fromRGBO(0, 255, 0, 1.0),
                          ),
                        ),
                        new Expanded(
                          flex: 2,
                          child: new Container(
                            margin: const EdgeInsets.only(top: 5.0, bottom: 5.0, left: 5.0),
                            child: Text('>10',style: new TextStyle(fontSize: 14,),),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              new SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                  child: new Container(
                    width: double.infinity,
                    height: 250.0,
                    decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 255, 255, 0.5),
                        borderRadius: BorderRadius.circular(5.0),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(204, 204, 204, 0.5),
                            offset: Offset(0.0, 15.0),
                            blurRadius: 25.0,
                          ),
                          BoxShadow(
                            color: Color.fromRGBO(204, 204, 204, 0.5),
                            offset: Offset(0.0, -10.0),
                            blurRadius: 25.0,
                          ),
                        ]
                    ),
                    child: Column(
                        children: <Widget>[

                        ]
                    ),
                  ),
                ),
              ),
            ],
          )
        )
    );
  }
}




