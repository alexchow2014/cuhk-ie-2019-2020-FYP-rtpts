import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rtpts/03_01_register.dart';
import 'package:toast/toast.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';


import './01_mainpage.dart';
import './03_01_register.dart';
import './99_globals.dart' as globals;
import './991_auth.dart';

final TextEditingController Controller01 = new TextEditingController();
final TextEditingController Controller02 = new TextEditingController();
final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
var snackBar = SnackBar(content: new Text('Error: Invalid Email or Password'), duration: new Duration(seconds: 10),);

class Login extends StatefulWidget {
  @override
  _Login createState() {
    return new _Login();
  }
}

class _Login extends State<Login> {

  signIn() async {
    var email = Controller01.text;
    var password = Controller02.text;
    print(Controller01.text);
    print(Controller02.text);

    var url = 'http://18.190.1.135/tmp/get_d.php';
    var data = {'email': email, 'password' : password};
    var response = await http.post(url, body: json.encode(data));

    // Getting Server response into variable.
    var message = jsonDecode(response.body);
    print(message);
    if (message == '1') {
      globals.email = email;
      Navigator.of(context).pop();
      Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new Homepage()));
    }
    else {
      Toast.show("Error: Invalid Email or Password", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
    }
  }


  DateTime _lastPressedAt;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height / 3.5;
    return new WillPopScope(
        onWillPop: () {
          if (_lastPressedAt == null || DateTime.now().difference(_lastPressedAt) > Duration(seconds: 1)) {
            _lastPressedAt = DateTime.now();
            Toast.show("Cilck again to exit", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
          }
          else {
            SystemNavigator.pop();
          }
        },
        child: new Scaffold(
          key: scaffoldKey,
          backgroundColor: Colors.white,
          resizeToAvoidBottomPadding: true,
          body: new Stack(
            fit: StackFit.expand,
            children: <Widget>[
              new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Container(
                    child: new Image.asset("assets/login.jpg"),
                  ),
                ],
              ),
              new SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(top: height, left: 20.0, right: 20.0),
                  child: new Container(
                    width: double.infinity,
                    height: 425.0,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(204, 204, 204, 1),
                            offset: Offset(0.0, 15.0),
                            blurRadius: 25.0,
                          ),
                          BoxShadow(
                            color: Color.fromRGBO(204, 204, 204, 1),
                            offset: Offset(0.0, -10.0),
                            blurRadius: 25.0,
                          ),
                        ]
                    ),
                    child: Column(
                        children: <Widget>[
                          new Container(
                            margin: const EdgeInsets.only(top: 15.0),
                            child: new Text('Login', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0,),),
                          ),
                          new Container(
                            margin: const EdgeInsets.only(top: 15.0, right: 300.0),
                            child: new Text('Email', style: TextStyle(fontSize: 17.5,),),
                          ),
                          new Container(
                            margin: const EdgeInsets.only(top: 5.0, left: 15, right: 25),
                            width: 350,
                            child: TextFormField(
                              decoration: const InputDecoration(hintText: 'Email',),
                              keyboardType: TextInputType.emailAddress,
                              controller: Controller01,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                            ),
                          ),
                          new Container(
                            margin: const EdgeInsets.only(top: 15.0, right: 265.0),
                            child: new Text('Password', style: TextStyle(fontSize: 17.5,),),
                          ),
                          new Container(
                            margin: const EdgeInsets.only(top: 5.0, left: 15, right: 25),
                            width: 350,
                            child: TextFormField(
                              obscureText: true,
                              decoration: const InputDecoration(hintText: 'Password',),
                              keyboardType: TextInputType.emailAddress,
                              controller: Controller02,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                            ),
                          ),
                          new Container(
                            margin: const EdgeInsets.only(top: 25.0, left: 200.0),
                            width: 125.0,
                            height: 50.0,
                            child: RaisedButton(
                                child: Text("Sign In", style: TextStyle(fontSize: 17.5,)),
                                onPressed: () {
                                  signIn();
                                }
                            ),
                          ),
                          new Container(
                            child: InkWell(
                              onTap: () {

                              },
                              child: Text("Forgot password?", style: TextStyle(color: Colors.blue, fontSize: 15.0,)),
                            ),
                            margin: const EdgeInsets.only(top: 20.0, left: 210.0),

                          ),
                          new Container(
                            child: InkWell(
                              onTap: () {
                                //Navigator.of(context).pop();
                                Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new reg()));
                              },
                              child: Text("No account? Register here.", style: TextStyle(color: Colors.blue, fontSize: 15.0,)),
                            ),
                            margin: const EdgeInsets.only(top: 5.0, left: 150.0),
                          ),
                        ]
                    ),
                  ),
                ),
              ),
            ],

          ),
        )
    );
  }
}