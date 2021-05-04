import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import './05_00_settings.dart';
import './99_globals.dart' as globals;

String dropdownValue;
var type;

class Car_Settings extends StatefulWidget {
  @override
  _Car_Settings createState() {
    return new _Car_Settings();
  }
}

class _Car_Settings extends State<Car_Settings> {
  get_value() async{
    var url = 'http://18.190.1.135/tmp/data.php';
    var data = {'request': '1', 'request_email' :globals.email};
    var response = await http.post(url, body: json.encode(data));
    var message = response.body;
    user = jsonDecode(message);
    print(user["type"]);
    globals.type = user["type"];
  }

  get_value_2() async{
    type = globals.type;
    if (type == '1') {
      dropdownValue = 'Private car';
    }
    else if (type == '2') {
      dropdownValue = 'Motorcycle';
    }
    else if (type == '3') {
      dropdownValue = 'LGVs';
    }
    else if (type == '4') {
      dropdownValue = 'HGVs';
    }
    else if (type == '5') {
      dropdownValue = 'Others';
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

  update_value(var value) async{
    var url = 'http://18.190.1.135/tmp/input_management.php';
    var data = {'mode': '1', 'value': value,'input_email' :globals.email};
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
  Widget build(BuildContext context) {

    return new WillPopScope(
        onWillPop: () async {
          get_value_2();
          Navigator.of(context).pop();
        },
        child: new Scaffold(
          appBar: new AppBar(
            title: Text('Car type'),
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
                  alignment: Alignment.centerRight,
                  margin: const EdgeInsets.only(top: 10.0, bottom: 10.0, right: 20.0, left: 20.0),
                  child: Row(
                    children: <Widget>[
                      new Expanded(
                          flex: 1,
                          child: new Text('Car type', style: TextStyle(color: Colors.black, fontSize: 25.0,)),
                      ),
                      new Expanded(
                        flex: 1,
                        child: new Container(
                          width: 200,
                          child: DropdownButton<String>(
                            value: dropdownValue,
                            icon: Icon(Icons.arrow_downward),
                            iconSize: 25,
                            elevation: 0,
                            style: TextStyle(
                                color: Colors.deepPurple
                            ),
                            underline: Container(
                              height: 1,
                              color: Colors.deepPurpleAccent,
                            ),
                            onChanged: (String newValue) {
                              setState(() {
                                dropdownValue = newValue;
                                print(newValue);
                              });
                            },
                            items: <String>['Private car','Motorcycle','LGVs','HGVs','Others'].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: SizedBox(
                                  width: 160.0,
                                  child: Text(value, style: TextStyle(color: Colors.black, fontSize: 25.0,)),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
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
                      var tmp = 0;
                      if (dropdownValue == 'Private car') {
                        tmp = 1;
                      }
                      else if (dropdownValue == 'Motorcycle') {
                        tmp = 2;
                      }
                      else if (dropdownValue == 'LGVs') {
                        tmp = 3;
                      }
                      else if (dropdownValue == 'HGVs') {
                        tmp = 4;
                      }
                      else if (dropdownValue == 'Others') {
                        tmp = 5;
                      }
                      print(tmp);
                      update_value(tmp);
                    }
                ),
              ),
            ],
          ),
        )
    );
  }
}