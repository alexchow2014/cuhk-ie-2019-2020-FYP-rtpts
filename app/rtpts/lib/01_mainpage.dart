import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:flutter/services.dart';

import './03_login.dart';
import './04_list-of-areas.dart';
import './05_00_settings.dart';
import './06_place.dart';

class Homepage extends StatefulWidget {
  @override
  _Homepage createState() {
    return new _Homepage();
  }
}

class _Homepage extends State<Homepage> {
  DateTime _lastPressedAt;

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () async {
          if (_lastPressedAt == null || DateTime.now().difference(_lastPressedAt) > Duration(seconds: 1)) {
            _lastPressedAt = DateTime.now();
            Toast.show("Cilck again to exit", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
          }
          else {
            SystemNavigator.pop();
          }

        },
        child: new Scaffold(
          appBar: new AppBar(),
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
                  new ListTile(
                      title: new Text("Available parking areas"),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new Area_display()));
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
                      title: new Text("Sign Out"),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new Login()));
                      }
                  ),
                ],
              )
          ),
          body: new GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.0
            ),
            children: <Widget>[
              new Stack(
                children: <Widget>[
                  new GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new Place()));
                    },
                    child: new Container(
                      color: new Color.fromRGBO(255, 0, 153, 0.5),
                      padding: EdgeInsets.all(7.5),
                      margin: EdgeInsets.all(5),
                      child: new Column(
                          children: [
                            Expanded(
                              flex: 8,
                              child: new Image.asset('assets/parking_icon_c.png',
                                width: 75.0,
                                alignment: Alignment.center,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text('Find Parking Area',
                                style: new TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ]
                      ),
                    ),
                  ),
                ],
              ),
              /*
              new Stack(
                children: <Widget>[
                  new GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new Login()));
                    },
                    child: new Container(
                      color: new Color.fromRGBO(68, 150, 62, 1),
                      padding: EdgeInsets.all(7.5),
                      margin: EdgeInsets.all(5),
                      child: new Column(
                          children: [
                            Expanded(
                                flex: 8,
                                child: Container(
                                  alignment: Alignment.topCenter,
                                  child: new Icon(Icons.account_box, size: 90.0),
                                )
                            ),
                            Expanded(
                              flex: 2,
                              child: Text('Account',
                                style: new TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ]
                      ),
                    ),
                  ),
                ],
              ),
              */
              new Stack(
                children: <Widget>[
                  new GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new Settings()));
                    },
                    child: new Container(
                      color: new Color.fromRGBO(255, 208, 0, 1),
                      padding: EdgeInsets.all(7.5),
                      margin: EdgeInsets.all(5),
                      child: new Column(
                          children: [
                            Expanded(
                                flex: 8,
                                child: Container(
                                  alignment: Alignment.center,
                                  child: new Icon(Icons.settings, size: 80.0),
                                )
                            ),
                            Expanded(
                              flex: 2,
                              child: Text('Settings',
                                style: new TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ]
                      ),
                    ),
                  ),
                ],
              ),
              new Stack(
                children: <Widget>[
                  new GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new Area_display()));
                    },
                    child: new Container(
                      color: new Color.fromRGBO(22, 209, 219, 1),
                      padding: EdgeInsets.all(7.5),
                      margin: EdgeInsets.all(5),
                      child: new Column(
                          children: [
                            Expanded(
                                flex: 8,
                                child: Container(
                                  alignment: Alignment.center,
                                  child: new Icon(Icons.place, size: 80.0),
                                )
                            ),
                            Expanded(
                              flex: 2,
                              child: Text('Avilable Area',
                                style: new TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ]
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
    );
  }
}

/*Logged In*/
class Homepage_login extends StatefulWidget {
  @override
  _Homepage_login createState() {
    return new _Homepage_login();
  }
}

class _Homepage_login extends State<Homepage_login> {
  DateTime _lastPressedAt;

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () async {
          if (_lastPressedAt == null || DateTime.now().difference(_lastPressedAt) > Duration(seconds: 1)) {
            _lastPressedAt = DateTime.now();
            Toast.show("Cilck again to exit", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
            return false;
          }
          return true;
        },
        child: new Scaffold(
          appBar: new AppBar(),
          drawer: new Drawer(
              child: new ListView(
                children: <Widget>[
                  new UserAccountsDrawerHeader(
                    accountName: Text('Alex'),
                    accountEmail: Text('alexchow2014@gmail.com'),
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
                        //Navigator.pop(context);
                        //Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new place()));
                      }
                  ),
                  new ListTile(
                      title: new Text("Sign Out"),
                      onTap: () {
                        //Navigator.pop(context);
                        //Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new place()));
                      }
                  ),
                ],
              )
          ),
          body: new GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.0
            ),
            children: <Widget>[
              new Stack(
                children: <Widget>[
                  new GestureDetector(
                    onTap: () {
                      //Navigator.pop(context);
                      //.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new place()));
                    },
                    child: new Container(
                      color: new Color.fromRGBO(255, 0, 153, 0.5),
                      padding: EdgeInsets.all(7.5),
                      margin: EdgeInsets.all(5),
                      child: new Column(
                          children: [
                            Expanded(
                              flex: 8,
                              child: new Image.asset('assets/parking_icon_c.png',
                                width: 75.0,
                                alignment: Alignment.center,
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Text('Find Parking Area',
                                style: new TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ]
                      ),
                    ),
                  ),
                ],
              ),
              new Stack(
                children: <Widget>[
                  new GestureDetector(
                    onTap: () {
                      //Navigator.pop(context);
                      //.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new place()));
                    },
                    child: new Container(
                      color: new Color.fromRGBO(68, 150, 62, 1),
                      padding: EdgeInsets.all(7.5),
                      margin: EdgeInsets.all(5),
                      child: new Column(
                          children: [
                            Expanded(
                                flex: 8,
                                child: Container(
                                  alignment: Alignment.topCenter,
                                  child: new Icon(Icons.account_box, size: 90.0),
                                )
                            ),
                            Expanded(
                              flex: 2,
                              child: Text('Account',
                                style: new TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ]
                      ),
                    ),
                  ),
                ],
              ),
              new Stack(
                children: <Widget>[
                  new GestureDetector(
                    onTap: () {
                      //Navigator.pop(context);
                      //.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new place()));
                    },
                    child: new Container(
                      color: new Color.fromRGBO(255, 208, 0, 1),
                      padding: EdgeInsets.all(7.5),
                      margin: EdgeInsets.all(5),
                      child: new Column(
                          children: [
                            Expanded(
                                flex: 8,
                                child: Container(
                                  alignment: Alignment.center,
                                  child: new Icon(Icons.settings, size: 80.0),
                                )
                            ),
                            Expanded(
                              flex: 2,
                              child: Text('Settings',
                                style: new TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ]
                      ),
                    ),
                  ),
                ],
              ),
              new Stack(
                children: <Widget>[
                  new GestureDetector(
                    onTap: () {
                      //Navigator.pop(context);
                      //.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new place()));
                    },
                    child: new Container(
                      color: new Color.fromRGBO(22, 209, 219, 1),
                      padding: EdgeInsets.all(7.5),
                      margin: EdgeInsets.all(5),
                      child: new Column(
                          children: [
                            Expanded(
                                flex: 8,
                                child: Container(
                                  alignment: Alignment.center,
                                  child: new Icon(Icons.place, size: 80.0),
                                )
                            ),
                            Expanded(
                              flex: 2,
                              child: Text('Avilable Area',
                                style: new TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ]
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
    );
  }
}