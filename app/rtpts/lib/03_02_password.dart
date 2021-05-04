import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';
import 'package:toast/toast.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import './03_Login.dart';
import './03_01_register.dart';
import './99_globals.dart' as globals;
import './991_auth.dart';

final TextEditingController Controller01 = new TextEditingController();
final TextEditingController Controller02 = new TextEditingController();

class pass extends StatefulWidget {
  @override
  _pass createState() {
    return new _pass();
  }
}

class _pass extends State<pass> {

  password_check() async {
    var password = Controller01.text;
    var repassword = Controller02.text;
    var email = globals.reg;
    print(email);

    var url = 'http://18.190.1.135/tmp/reg.php';
    var data = {'email': email, 'password': password, 'repassword': repassword};
    var response = await http.post(url, body: json.encode(data));

    // Getting Server response into variable.
    var message = jsonDecode(response.body);
    print(message);
    if (message == 1) {
      bool ok = await showDeleteConfirmDialog1(1);
      if (ok == null) {
        Controller01.text = '';
        Controller02.text = '';
        Navigator.of(context).pop();
        //Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new Login()));
      }
    }
    else if (message == 2){
      showDeleteConfirmDialog1(2);
    }
    else if (message == 3){
      showDeleteConfirmDialog1(3);
    }
    else if (message == 4){
      showDeleteConfirmDialog1(4);
    }
    else if (message == 5){
      showDeleteConfirmDialog1(5);
    }
  }

  Future<bool> showDeleteConfirmDialog1(var int) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        if (int == 1) {
          return AlertDialog(
            title: Text("Success"),
            content: Text("The account is created, now we will redirect you to login page. Please login."),
            actions: <Widget>[
              FlatButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                }, // 关闭对话框
              ),
            ],
          );
        }
        else if (int == 2){
          return AlertDialog(
            title: Text("Error"),
            content: Text("Information null."),
            actions: <Widget>[
              FlatButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                }, // 关闭对话框
              ),
            ],
          );
        }
        else if (int == 3){
          return AlertDialog(
            title: Text("Error"),
            content: Text("Your entered Password and re-password are not the same."),
            actions: <Widget>[
              FlatButton(
                child: Text("OK"),
                onPressed: () => Navigator.of(context).pop(), // 关闭对话框
              ),
            ],
          );
        }
        else if (int == 4){
          return AlertDialog(
            title: Text("Error"),
            content: Text("Connect database failed."),
            actions: <Widget>[
              FlatButton(
                child: Text("OK"),
                onPressed: () => Navigator.of(context).pop(), // 关闭对话框
              ),
            ],
          );
        }
        else if (int == 5){
          return AlertDialog(
            title: Text("Error"),
            content: Text("Register fail."),
            actions: <Widget>[
              FlatButton(
                child: Text("OK"),
                onPressed: () => Navigator.of(context).pop(), // 关闭对话框
              ),
            ],
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return new WillPopScope(
        onWillPop: () async {
          Controller01.text = '';
          Controller02.text = '';
          Navigator.of(context).pop();
          //Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new Login()));
        },
        child: new Scaffold(
          appBar: new AppBar(
            leading: IconButton(icon:Icon(Icons.arrow_back),
              onPressed:() {
                Controller01.text = '';
                Controller02.text = '';
                Navigator.of(context).pop();
                //Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new Login()));
              },
            ),
            actions: <Widget>[
              new InkWell(
                onTap: () {
                  password_check();
                },
                child: new Container(
                  color: Color.fromARGB(0, 0, 0, 1),
                  padding: EdgeInsets.only(right: 5.0, left: 20.0, top: 5.0, bottom: 5.0),
                  margin: EdgeInsets.only(right: 10.0, top: 15.0),
                  child: new Text('Next', style: TextStyle(fontSize: 20.0,),),
                ),
              )
            ],
          ),
          body: new Column(
            children: <Widget>[
              new Container (
                child: new Column(
                  children: <Widget>[
                    new Container(
                      width: width,
                      margin: const EdgeInsets.only(top: 15.0, bottom: 15.0, left: 15.0),
                      child: new Text('Enter your password', style: TextStyle(fontSize: 25.0,),),
                    ),
                    new Container(
                      width: width,
                      margin: const EdgeInsets.only(left: 15.0, bottom: 15.0, right: 15.0),
                      child: TextFormField(
                        decoration: const InputDecoration(hintText: 'Enter password',),
                        obscureText: true,
                        keyboardType: TextInputType.visiblePassword,
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
                      width: width,
                      margin: const EdgeInsets.only(top: 15.0, bottom: 15.0, left: 15.0),
                      child: new Text('Re-enter your password', style: TextStyle(fontSize: 25.0,),),
                    ),
                    new Container(
                      width: width,
                      margin: const EdgeInsets.only(left: 15.0, bottom: 15.0, right: 15.0),
                      child: TextFormField(
                        decoration: const InputDecoration(hintText: 'Re-enter password',),
                        obscureText: true,
                        keyboardType: TextInputType.visiblePassword,
                        controller: Controller02,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
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