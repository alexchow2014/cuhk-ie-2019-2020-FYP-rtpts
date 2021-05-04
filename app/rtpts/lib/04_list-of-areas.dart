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
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui';

import './03_login.dart';
import './05_00_settings.dart';
import './06_place.dart';

import '99_globals.dart' as globals;

var carpark_place, carpark_vac;

class Area_display extends StatefulWidget {
  @override
  _Area_display createState() => _Area_display();
}

class _Area_display extends State<Area_display> {
  GoogleMapController mapController;
  Set<Marker> markers = {};
  Map<MarkerId, Marker> markerss = <MarkerId, Marker>{};
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
    var i; var max = carpark_place['results'].length;
    for (i = 0; i < max; i++) {
      int num;
      var place = LatLng(carpark_place['results'][i]['latitude'], carpark_place['results'][i]['longitude']);
      var tmp = carpark_vac['results'][i]['privateCar'][0]['vacancy'];
      if (!(tmp is int)) {num = int.parse(tmp);}
      else {num = tmp;}

      MarkerId id = MarkerId('$i');

      await markers.add(Marker(
        markerId: MarkerId('$i'),
        position: place,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
        onTap: () {
          _onClicked(id.value);
        },
      ));
      if (num == -1) {
        await markers.add(Marker(
          markerId: MarkerId('$i'),
          position: place,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet),
          onTap: () {
            _onClicked(id.value);
          },
        ));
      }
      else if (num == 0) {
        await markers.add(Marker(
          markerId: MarkerId('$i'),
          position: place,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          onTap: () {
            _onClicked(id.value);
          },
        ));
      }
      else if (num <= 10 && num > 0) {
        await markers.add(Marker(
          markerId: MarkerId('$i'),
          position: place,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
          onTap: () {
            _onClicked(id.value);
          },
        ));
      }
      else {
        await markers.add(Marker(
          markerId: MarkerId('$i'),
          position: place,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          onTap: () {
            _onClicked(id.value);
          },
        ));
      }
    }
    //print(markers);
    print("Markers finished");
  }
  void _onClicked(var i) {
    print(i);
    var num = int.parse(i);
    var name = carpark_place['results'][num]['name'];
    //var URL_image = carpark_place['results'][num]['renditionUrls']['carpark_photo'];
    var URL = carpark_place['results'][num]['website'];

    var tel = carpark_place['results'][num]['contactNo'];
    var vacancy = carpark_vac['results'][num]['privateCar'][0]['vacancy'];
    if (vacancy == -1) {vacancy = 'N/A';}
    double width = MediaQuery.of(context).size.width;
    if (URL == '') {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return SingleChildScrollView(
              child: Container(
                width: double.infinity,
                height: 200,
                color: Colors.white,
                margin: EdgeInsets.only(left: 5.0, top: 5.0, right: 5.0, bottom: 5.0),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: <Widget>[
                          new Container(
                            margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
                            height: 40,
                            alignment: Alignment.topLeft,
                            child: Text('$name', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 20),),
                          ),
                          new Container(
                            child: Row(
                              children: <Widget>[
                                new Expanded(
                                  flex: 5,
                                  child: new Container(
                                    margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
                                    height: 40,
                                    alignment: Alignment.centerLeft,
                                    child: Text('Vacancy', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 20),),
                                  ),
                                ),
                                new Expanded(
                                  flex: 1,
                                  child: new Container(
                                    margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
                                    height: 40,
                                    alignment: Alignment.topRight,
                                    child: Text('$vacancy', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 30),),
                                  ),
                                ),

                              ],
                            ),
                          ),
                          new Container(
                            child: Row(
                              children: <Widget>[
                                new InkWell(
                                  onTap: () {
                                    launch("tel://$tel");
                                  },
                                  child: new Container(
                                    color: Color.fromARGB(0, 0, 0, 1),
                                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                                    margin: EdgeInsets.only(left: 20.0, top: 5.0, right: 20.0, bottom: 10.0),
                                    width: width/2 - 40.0,
                                    child: Icon(Icons.phone, size: 42.0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),),
            );
          }
      );
    }
    else {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return SingleChildScrollView(
              child: Container(
                width: double.infinity,
                height: 200,
                color: Colors.white,
                margin: EdgeInsets.only(left: 5.0, top: 5.0, right: 5.0, bottom: 5.0),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: <Widget>[
                          new Container(
                            margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
                            height: 40,
                            alignment: Alignment.topLeft,
                            child: Text('$name', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 20),),
                          ),
                          new Container(
                            child: Row(
                              children: <Widget>[
                                new Expanded(
                                  flex: 5,
                                  child: new Container(
                                    margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
                                    height: 40,
                                    alignment: Alignment.centerLeft,
                                    child: Text('Vacancy', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 20),),
                                  ),
                                ),
                                new Expanded(
                                  flex: 1,
                                  child: new Container(
                                    margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
                                    height: 40,
                                    alignment: Alignment.topRight,
                                    child: Text('$vacancy', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 30),),
                                  ),
                                ),

                              ],
                            ),
                          ),
                          new Container(
                            child: Row(
                              children: <Widget>[
                                new InkWell(
                                  onTap: () {
                                    launch("tel://$tel");
                                  },
                                  child: new Container(
                                    color: Color.fromARGB(0, 0, 0, 1),
                                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                                    margin: EdgeInsets.only(left: 20.0, top: 5.0, right: 10.0, bottom: 10.0),
                                    width: width/2 - 40.0,
                                    child: Icon(Icons.phone, size: 42.0),
                                  ),
                                ),
                                new InkWell(
                                  onTap: () {
                                    _launchURL(URL);
                                  },
                                  child: new Container(
                                    color: Color.fromARGB(0, 0, 0, 1),
                                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                                    margin: EdgeInsets.only(left: 20.0, top: 5.0, right: 10.0, bottom: 10.0),
                                    width: width/2 - 40.0,
                                    child: Icon(Icons.web, size: 42.0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),),
            );
          }
      );
    }
  }

  _launchURL(var url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
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
    double height = MediaQuery.of(context).size.height;
    print(height-175);
    return new WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop();
        },
        child: new Scaffold(
          appBar: new AppBar(
            title: Text('Carpark details'),
            leading: IconButton(icon:Icon(Icons.arrow_back),
              onPressed:() {
                Navigator.of(context).pop();
              },
            )
          ),
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
                        Navigator.pop(context);
                        Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new Place()));
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
          body: new Column(
            children: <Widget>[
              new Container(
                height: height - 175,
                child: GoogleMap(
                  zoomGesturesEnabled:true,  //縮放手勢
                  onMapCreated: _onMapCreated,
                  markers: markers,
                  mapType: MapType.normal,
                  compassEnabled: true,  //指北針
                  initialCameraPosition: CameraPosition(
                      target: LatLng(22.3, 114.1),  //中心點座標
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
        )
    );
  }
}