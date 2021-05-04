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
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:place_plugin/place.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/widgets.dart';


import './01_mainpage.dart';
import './07_loading.dart';

import '99_globals.dart' as globals;

var carpark_place, carpark_vac;

const kGoogleApiKey = "AIzaSyBtc7zM4xHlXYI5MSBhNz-ovLaojoZqZB4";
GoogleMapsPlaces _places_start = GoogleMapsPlaces(apiKey: kGoogleApiKey);
GoogleMapsPlaces _places_destnation = GoogleMapsPlaces(apiKey: kGoogleApiKey);


final TextEditingController Controller01 = new TextEditingController();
final TextEditingController Controller02 = new TextEditingController();
final TextEditingController Controller03 = new TextEditingController();
var lat_01, lat_02, lng_01, lng_02;
var time;
var starting_points, destination;
var oil, dis;

class Place extends StatefulWidget {
  @override
  _Place createState() => _Place();
}

class _Place extends State<Place> {
  GoogleMapController mapController;
  Set<Marker> markers = {};
  var response, response_02;

  final GlobalKey<ScaffoldState> homeScaffoldKey = new GlobalKey<ScaffoldState>();
  void _errorbar(var int){
    var snackBar;
    if (int == 1) {print("v");snackBar = SnackBar(content: Text('Invaild location on Strating Point or Destination'));}
    else if (int == 2) {print("v2");snackBar = SnackBar(content: Text('Invaild time'));}
    homeScaffoldKey.currentState.showSnackBar(snackBar);
  }

  request() async {
    await get_value();
    await request_part_01();
    await request_part_02();
    await Markers();
    print("finished");
    return 1;
  }

  get_value() async{
    var url = 'http://18.190.1.135/tmp/data.php';
    var data = {'request': '4', 'request_email' :globals.email};
    var response = await http.post(url, body: json.encode(data));
    var message = response.body;
    var user = jsonDecode(message);

    globals.oil = user["oil"];
    oil = user["oil"];
    globals.distance = user["distance"];
    dis = user["distance"];
    //print("A");
    //print(oil);
    //print(dis);
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
    var num = int.parse(i);
    var name = carpark_place['results'][num]['name'];
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

  void _ontap(var i) {
    globals.pick_mode = i;
    _autocomplete(i);
  }

  Future _autocomplete(int state) async {
    Prediction p = await PlacesAutocomplete.show(
        context: context,
        apiKey: kGoogleApiKey,
        mode: Mode.fullscreen, // Mode.fullscreen overlay
        language: "en-uk",
        components: [new Component(Component.country, "hk")]
    );
    displayPrediction(p, state);
  }

  @override
  void initState() {
    super.initState();
    request().then((result) {
      setState(() {

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    void _onMapCreated(GoogleMapController controller) async{
      mapController = controller;
    }
    double height = MediaQuery.of(context).size.height;
    var height_set = height - 325 - 175 + 80;
    print(globals.time_c);
    if (globals.time_c == 0) {
      Controller01.text = '';
      Controller02.text = '';
      Controller03.text = '';
      globals.starting_points = '';
      globals.destination = '';
      time = ''; lat_01 = ''; lat_02 = ''; lng_01 = ''; lng_02 = '';
      globals.time_c = 1;
    }

    return new WillPopScope(
        onWillPop: () async {
          Controller01.text = '';
          Controller02.text = '';
          Controller03.text = '';
          globals.starting_points = '';
          globals.destination = '';
          time = ''; lat_01 = ''; lat_02 = ''; lng_01 = ''; lng_02 = '';
          globals.time_c = 0;
          Navigator.of(context).pop();
          Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new Homepage()));
        },
        child: new Scaffold(
            resizeToAvoidBottomPadding: true,
            key: homeScaffoldKey,
            appBar: new AppBar(
              title: Text('Searching Parking Area'),backgroundColor: Colors.red,
              leading: IconButton(icon:Icon(Icons.arrow_back),
                onPressed:() {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new Homepage()));
                },
              )
            ),
            body: SingleChildScrollView(
                child: new Column(
                  children: <Widget>[
                    new Container(
                      height: 250,
                      child: new Column(
                          children: <Widget>[
                            new InkWell(
                                child: Container(
                                  margin: EdgeInsets.only(left: 10.0, top: 5.0, right: 10.0),
                                  child: new TextFormField(
                                    decoration: const InputDecoration(
                                      icon: Icon(Icons.place),
                                      hintText: 'Where are you now?',
                                    ),
                                    controller: Controller01,
                                    enabled: false,
                                  ),
                                ),
                                onTap: (){
                                  _ontap(1);
                                },
                            ),
                            new InkWell(
                              child: Container(
                                margin: EdgeInsets.only(left: 10.0, top: 5.0, right: 10.0),
                                child: new TextFormField(
                                  decoration: const InputDecoration(
                                    icon: Icon(Icons.place),
                                    hintText: 'Where are you go to?',
                                  ),
                                  controller: Controller02,
                                  enabled: false,
                                ),
                              ),
                              onTap: (){
                                _ontap(2);
                              },
                            ),
                            new Container(
                                margin: EdgeInsets.only(left: 10.0, top: 5.0, right: 10.0),
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    icon: Icon(Icons.access_time),
                                    hintText: 'How long that you want to park? (in hour)',
                                  ),
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                                  controller: Controller03,
                                )
                            ),
                            new Container(
                              alignment: Alignment.centerRight,
                              margin: const EdgeInsets.only(top: 5.0, bottom: 5.0, right: 25.0),
                              child: new RaisedButton(
                                  child: Text("Submit", style: TextStyle(fontSize: 17.5,)),
                                  onPressed: () {
                                    time = Controller03.text;
                                    if (lat_01 == '' || lat_02 == '' || lng_01 == '' || lng_02 == '' || time == '') {
                                      if (lat_01 == '' || lat_02 == '' || lng_01 == '' || lng_02 == '') {
                                        _errorbar(1);
                                      }
                                      else {
                                        _errorbar(2);
                                      }
                                    }
                                    else {
                                      globals.hr = time;
                                      globals.lat_01 = lat_01;
                                      globals.lat_02 = lat_02;
                                      globals.lng_01 = lng_01;
                                      globals.lng_02 = lng_02;
                                      globals.link_request = 'https://boiling-earth-49057.herokuapp.com/api?start_lat='+lat_01.toString()+'&start_lng='+lng_01.toString()+'&end_lat='+lat_02.toString()+'&end_lng='+lng_02.toString()+'&search_dis='+dis+'&oil_consumption='+oil+'&parking_hour='+time;
                                      globals.time_c = 0;
                                      globals.starting_points = starting_points;
                                      globals.destination = destination;
                                      Navigator.of(context).pop();
                                      Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new loading()));
                                    }
                                  }
                              ),
                            ),
                          ]
                      ),
                    ),
                    new Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new Container(
                          height: height_set,
                          child: GoogleMap(
                            zoomGesturesEnabled:true,
                            onMapCreated: _onMapCreated,
                            markers: markers,
                            mapType: MapType.normal,
                            compassEnabled: true,
                            initialCameraPosition: CameraPosition(
                                target: LatLng(22.375, 114.1),
                                zoom: 10.0,
                                bearing: 0,
                                tilt: 0
                            ),
                          ),
                        ),
                        new Container(
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.only(top: 0.0, left: 10.0, bottom: 5.0),
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
                  ],
                )
            ),
        )
    );
  }
}

Future<Null> displayPrediction(Prediction p, int state) async {
  if (p != null) {
    // get detail (lat/lng)
    PlacesDetailsResponse detail = await _places_start.getDetailsByPlaceId(p.placeId);
    final lat = detail.result.geometry.location.lat;
    final lng = detail.result.geometry.location.lng;

    if (state == 1) {
      lat_01 = lat;
      lng_01 = lng;
      Controller01.text = p.description;
      starting_points = p.description;
    }
    else if (state == 2) {
      lat_02 = lat;
      lng_02 = lng;
      Controller02.text = p.description;
      destination = p.description;
    }
  }
}