import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:permission/permission.dart';
import 'package:google_map_polyline/google_map_polyline.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui';

import './08_result.dart';
import './08_01_Driving.dart';
import './99_globals.dart' as globals;

class transit extends StatefulWidget {
  @override
  _transitState createState() => _transitState();
}
class _transitState extends State<transit> {
  GoogleMapController mapController;

  final Set<Marker> markers = {};
  final Set<Polyline> polyline = {};
  List<LatLng> routeCoords = new List();
  var v001, v011;
  LatLng a1, b1;
  GoogleMapPolyline googleMapPolyline = new GoogleMapPolyline(apiKey: "AIzaSyBtc7zM4xHlXYI5MSBhNz-ovLaojoZqZB4");

  void getLocation() {
    print(globals.choice);
    var v01 = globals.result[globals.choice - 1]["latitude"];
    v001 = double.parse("$v01");
    var v11 = globals.result[globals.choice - 1]["longitude"];
    v011 = double.parse("$v11");
    a1 = LatLng(globals.lat_02, globals.lng_02);
    b1 = LatLng(v001, v011);
  }

  void Markers() {
    markers.add(Marker(
      markerId: MarkerId(b1.toString()),
      position: b1,
      icon: BitmapDescriptor.defaultMarker,
    ));
    markers.add(Marker(
      markerId: MarkerId(a1.toString()),
      position: a1,
      icon: BitmapDescriptor.defaultMarker,
    ));
    routeCoords.add(b1);
    routeCoords.add(a1);
  }

  void get_line() async{
    routeCoords = await googleMapPolyline.getCoordinatesWithLocation(
      origin: a1,
      destination: b1,
      mode: RouteMode.walking,
    );
  }

  void draw_line() async{
    await polyline.add(
        Polyline(
          polylineId: PolylineId('route1'),
          visible: true,
          points: routeCoords,
          color: Colors.blue,
          width: 5,
        )
    );
  }

  request() async {
    await getLocation();
    await Markers();
    await get_line();
    await draw_line();
    print("finished");
    return 1;
  }

  @override
  void initState(){
    super.initState();
    request().then((result) {
      print(result);
      setState(() {

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var Zoom;
    double width = MediaQuery.of(context).size.width;
    var time_tmp_01 = globals.result[globals.choice - 1]["transit_time"];
    var time_tmp1_01 = double.parse("$time_tmp_01")/60;
    var time_01 = time_tmp1_01.round();

    var vc01 = (v001 + globals.lat_02) / 2;
    var vc11 = (v011 + globals.lng_02) / 2;

    final LatLng c1 = LatLng(globals.lat_02, globals.lng_02);
    final LatLng _center = LatLng(vc01, vc11);

    /*
    print(globals.lat_02 - v001);
    if (globals.lat_02 - v001 >= 0) {
      if (globals.lat_02 - v001 <= 0.005) {Zoom = 13.0;}
      else if (globals.lat_02 - v001 <= 0.01) {Zoom = 12.0;}
      else if(globals.lat_02 - v001 <= 0.02){Zoom = 11.0;}
      else {Zoom = 10.0;}
    }
    else if (globals.lat_02 - v001 <= 0) {
      if (v001 -globals.lat_02 <= 0.005) {Zoom = 13.0;}
      else if (v001 -globals.lat_02 <= 0.01) {Zoom = 12.0;}
      else if (v001 -globals.lat_02 <= 0.02) {Zoom = 11.0;}
      else {Zoom = 10.0;}
    }

    if (globals.lng_02 - v011 >= 0){
      if (globals.lng_02 - v011 <= 0.05 && Zoom < 16.0) {Zoom = 16.0;}
      else if (globals.lng_02 - v011 <= 0.1 && Zoom < 15.0) {Zoom = 15.0;}
      else if (globals.lng_02 - v011 <= 0.2 && Zoom < 14.0) {Zoom = 14.0;}
      else if (globals.lng_02 - v011 > 0.2) {Zoom = 13.0;}
    }
    else if (globals.lng_02 - v011 <= 0){
      if (v011 - globals.lng_02 <= 0.05 && Zoom < 16.0) {Zoom = 16.0;}
      else if (v011 - globals.lng_02 <= 0.1 && Zoom < 15.0) {Zoom = 15.0;}
      else if (v011 - globals.lng_02 <= 0.2 && Zoom < 14.0) {Zoom = 14.0;}
      else if (v011 - globals.lng_02 > 0.2) {Zoom = 13.0;}
    }
    */

    void _onMapCreated(GoogleMapController controller) {
      mapController = controller;
      /*routeCoords = await googleMapPolyline.getCoordinatesWithLocation(
          origin: a1,
          destination: b1,
          mode: RouteMode.transit,
        );*/
      //sleep(const Duration(seconds:5));

    }

    _launchURL() async {
      var dn = globals.result[globals.choice - 1]["latitude"];
      var de = globals.result[globals.choice - 1]["longitude"];
      var url = 'https://www.google.com/maps/dir/?api=1&origin='+dn.toString()+','+de.toString()+'&destination='+globals.lat_02.toString()+','+globals.lng_02.toString()+'&travelmode=transit';
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    return WillPopScope(
      onWillPop: () {
        Navigator.of(context).pop();
      },
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text('Transit Route'), backgroundColor: Colors.green[700],
            leading: IconButton(icon:Icon(Icons.arrow_back),
              onPressed:() {
                Navigator.of(context).pop();
              },
            )
          ),
          body: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              new Container(
                margin: EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0, bottom: 10.0),
                width: width,
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Container(
                      alignment: Alignment(-1.0, 0.0),
                      width: width/2 - 10,
                      child: Icon(Icons.directions_transit, size: 45.0,),
                    ),
                    new Container(
                      alignment: Alignment(1.0, 0.0),
                      width: width/2 - 10,
                      child: Text('$time_01'+' mins', style: TextStyle(fontStyle: FontStyle.italic, fontSize: 25),textAlign: TextAlign.right,),
                    ),
                  ],
                ),
              ),
              new Container(
                height: 500,
                child: GoogleMap(
                  markers: markers,
                  polylines: polyline,
                  zoomGesturesEnabled: true,  //縮放手勢
                  onMapCreated: _onMapCreated,
                  mapType: MapType.normal,
                  compassEnabled: false,  //指北針
                  initialCameraPosition: CameraPosition(
                      target: _center,  //中心點座標
                      zoom: 14.0,  //Camera縮放尺寸，越近數值越大，越遠數值越小，預設為0
                      bearing: 0,  //Camera旋轉的角度，方向為逆時針轉動，預設為0
                      tilt: 0  //Camera侵斜角度
                  ),
                  //polylines: globals.result[globals.choice - 1]["transit_step"][0]["polyline"]["points"],
                ),
              ),
              new Container(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                margin: EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0, bottom: 10.0),
                width: width,
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new driving()));
                      },
                      child: new Container(
                        color: Color.fromARGB(0, 0, 0, 1),
                        padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                        margin: EdgeInsets.only(left: 10.0, top: 5.0, right: 20.0, bottom: 10.0),
                        width: width/2 - 40.0,
                        child: Icon(Icons.directions_car, size: 42.0),
                      ),
                    ),
                    new InkWell(
                      onTap: () {
                        _launchURL();
                      },
                      child: new Container(
                        color: Color.fromARGB(0, 0, 0, 1),
                        padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                        margin: EdgeInsets.only(left: 20.0, top: 5.0, right: 10.0, bottom: 10.0),
                        width: width/2 - 40.0,
                        child: Icon(Icons.navigation, size: 42.0),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );



  }
}
