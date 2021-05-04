import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';
import './05_00_settings.dart';
import './99_globals.dart' as globals;

final TextEditingController Controller01 = new TextEditingController();
var oil;

class Oil_Settings extends StatefulWidget {
  @override
  _Oil_Settings createState() {
    return new _Oil_Settings();
  }
}

class _Oil_Settings extends State<Oil_Settings> {

  get_value() async{
    var url = 'http://18.190.1.135/tmp/data.php';
    var data = {'request': '2', 'request_email' :globals.email};
    var response = await http.post(url, body: json.encode(data));
    var message = response.body;
    user = jsonDecode(message);
    print(user["oil"]);
    globals.oil = user["oil"];
  }

  get_value_2() async{
    oil = globals.oil;
    Controller01.text = oil;
  }

  update_value(var value) async{
    var url = 'http://18.190.1.135/tmp/input_management.php';
    var data = {'mode': '2', 'value': value,'input_email' :globals.email};
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
            title: Text('Oil consumption'),
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
                margin: const EdgeInsets.only(top: 10.0, bottom: 10.0, right: 10.0, left: 10.0),
                child: Row(
                  children: <Widget>[
                    new Expanded(
                      flex: 4,
                      child: new Text('Oil consumption', style: TextStyle(color: Colors.black, fontSize: 20.0,)),
                    ),
                    new Expanded(
                      flex: 3,
                      child: new TextFormField(
                        decoration: const InputDecoration(),
                        keyboardType: TextInputType.number,
                        controller: Controller01,
                        validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter some text';
                            }
                          },
                        ),
                    ),
                    new Expanded(
                      flex: 1,
                      child: new Text('L/km', style: TextStyle(color: Colors.black, fontSize: 20.0,)),
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
                      var tmp = Controller01.text;
                      var value = double.parse(tmp);
                      print(value);
                      update_value(tmp);
                    }
                ),
              ),
              new Container(
                margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: new Text('*This value can be found in your car manual.', style: TextStyle(color: Colors.black, fontSize: 17.5,)),
              ),
            ],
          ),
        )
    );
  }
}