import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';

import './06_place.dart';
import './06_02.dart';

import './99_globals.dart';


class place_take extends StatefulWidget {
  @override
  _place_take createState() {
    return new _place_take();
  }
}

class _place_take extends State<place_take> {

  @override
  Widget build(BuildContext context) {

    var searchBloc = SearchBloc();

    return new WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
      },
        child: new Scaffold(
          appBar: new AppBar(
              title: Text('Secrching distance'),
          ),
          body: Container(
            child: ListView.separated(
              itemCount: 5,
              itemBuilder: (BuildContext context, int index) {
                return Text('5');
              },
              separatorBuilder: (BuildContext context, int index) => Divider(),
            )
          ),
        ),
    );
  }

}