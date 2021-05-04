import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:rtpts/03_login.dart';
import 'dart:async';
import 'package:toast/toast.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import './03_login.dart';
import './03_02_password.dart';
import './99_globals.dart' as globals;


final TextEditingController Controller01 = new TextEditingController();

class reg extends StatefulWidget {
  @override
  _reg createState() {
    return new _reg();
  }
}

class _reg extends State<reg> {

  email_check() async {
    var email = Controller01.text;

    var url = 'http://18.190.1.135/tmp/reg_check.php';
    var data = {'email': email};
    var response = await http.post(url, body: json.encode(data));
    var message = jsonDecode(response.body);

    if (message == 1){
      print(email);
      globals.reg = email;
      Controller01.text = '';
      //print(globals.reg_email);
      Navigator.of(context).pop();
      Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new pass()));
    }
    else if (message == 2){
      showDeleteConfirmDialog1(2);
    }
    else if (message == 3){
      bool ok = await showDeleteConfirmDialog1(3);
      if (ok == null) {
        Controller01.text = null;
        globals.reg = null;
        Navigator.of(context).pop();
        //Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new Login()));
      }
    }
    else if (message == 4){
      showDeleteConfirmDialog1(4);
    }
  }

  Future<bool> showDeleteConfirmDialog1(var int) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        if (int == 2) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Connect server failed"),
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
            content: Text("Your entered email address is registered. Now we will redirect you to login screen."),
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
        else if (int == 4){
          return AlertDialog(
            title: Text("Error"),
            content: Text("Email is null."),
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
    print(height);
    return new WillPopScope(
        onWillPop: () async {
          Controller01.text = '';
          globals.reg = null;
          Navigator.of(context).pop();
          //Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new Login()));
        },
        child: new Scaffold(
          appBar: new AppBar(
            leading: IconButton(icon:Icon(Icons.arrow_back),
              onPressed:() {
                Controller01.text = '';
                globals.reg = null;
                Navigator.of(context).pop();
                //Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new Login()));
              },
            ),
            actions: <Widget>[
              new InkWell(
                onTap: () {
                  email_check();
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
                      child: new Text('Tell us your email address', style: TextStyle(fontSize: 25.0,),),
                    ),
                    new Container(
                      width: width,
                      margin: const EdgeInsets.only(left: 15.0, bottom: 15.0, right: 15.0),
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
                  ],
                ),
              ),
            ],
          ),
        )
    );
  }
}