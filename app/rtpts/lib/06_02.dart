import 'dart:async';

import 'package:place_plugin/place.dart';
import 'package:place_plugin/place_plugin.dart';

const googlePlaceApikey = "AIzaSyBtc7zM4xHlXYI5MSBhNz-ovLaojoZqZB4";

class SearchBloc{
  var _searchContainer = StreamController();

  SearchBloc(){
    PlacePlugin.initailize(googlePlaceApikey);
  }
  Stream get searchStream => _searchContainer.stream;

  void searchPlace(String keyword) {
    if(keyword.isNotEmpty) {
      _searchContainer.sink.add("searching_");
      PlacePlugin.search(keyword).then((result){
        _searchContainer.sink.add(result);
      }).catchError((e){

      });
    }
    else {
      _searchContainer.add([]);
    }
  }
}