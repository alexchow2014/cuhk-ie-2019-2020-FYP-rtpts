import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/widgets.dart';
import 'package:toast/toast.dart';

import './99_globals.dart' as globals;

double _value = 10;
double _lowerValue = 1;
double _upperValue = 20;

class Secrch_Settings extends StatefulWidget {
  @override
  _Secrch_Settings createState() {
    return new _Secrch_Settings();
  }
}

class _Secrch_Settings extends State<Secrch_Settings> {
  get_value() async{
    var url = 'http://18.190.1.135/tmp/data.php';
    var data = {'request': '3', 'request_email' :globals.email};
    var response = await http.post(url, body: json.encode(data));
    var message = response.body;
    var user = jsonDecode(message);
    print(user["distance"]);
    globals.distance = user["distance"];

  }

  get_value_2() {
    print(globals.distance);
    _value = double.parse(globals.distance);
  }

  update_value(var value) async{
    var url = 'http://18.190.1.135/tmp/input_management.php';
    var data = {'mode': '3', 'value': value,'input_email' :globals.email};
    var response = await http.post(url, body: json.encode(data));
    var message = jsonDecode(response.body);
    print(message);
    if (message == '1') {
      Toast.show("Success to upadte the car type.", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
      Navigator.of(context).pop();
    }
    else {
      Toast.show("Error in update. Please try again.", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
    }
  }

  @override
  void initState(){
    get_value().then((result) {
      setState(() {
        get_value_2();
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () async {
          get_value_2();
          Navigator.of(context).pop();
        },
        child: new Scaffold(
          appBar: new AppBar(
            title: Text('Secrching distance'),
            leading: IconButton(icon:Icon(Icons.arrow_back),
              onPressed:() {
                get_value_2();
                Navigator.of(context).pop();
              },
            )
          ),
          body: new Column(
            children: <Widget>[
              new Container(
                  margin: const EdgeInsets.only(top: 30.0, bottom: 10.0, right: 10.0, left: 10.0),
                  child: new Slider(
                    value: _value.toDouble(),
                    min: 1.0,
                    max: 20.0,
                    divisions: 19,
                    activeColor: Colors.red,
                    inactiveColor: Colors.black,
                    onChanged: (double newValue) {
                      setState(() {
                        _value = newValue;
                      });
                    },
                  )

              ),
              new Container(
                margin: const EdgeInsets.only(top: 10.0, bottom: 10.0, right: 10.0, left: 10.0),
                child: Row(
                  children: <Widget>[
                    new Expanded(
                        flex: 2,
                        child: new Container(
                          alignment: Alignment.centerRight,
                          child: new Text('Secrching distance = ', style: TextStyle(color: Colors.black, fontSize: 20.0,)),
                        )
                    ),
                    new Expanded(
                        flex: 1,
                        child: new Text('$_value'+' km', style: TextStyle(color: Colors.black, fontSize: 20.0,)),
                    ),
                  ],
                ),
              ),
              new Container(
                alignment: Alignment.centerRight,
                margin: const EdgeInsets.only(top: 10.0, bottom: 10.0, right: 25.0),
                child: new RaisedButton(
                    child: Text("Update", style: TextStyle(fontSize: 17.5,)),
                    onPressed: () {
                      var value = _value.round();
                      print(value);
                      update_value(value);
                    }
                ),
              ),
              new Container(
                margin: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10.0),
                child: new Text('*This value is controlling the secrching distance of the parking area form the destination your decide.', style: TextStyle(color: Colors.black, fontSize: 17.5,)),
              ),
            ],
          ),
        )
    );
  }
}