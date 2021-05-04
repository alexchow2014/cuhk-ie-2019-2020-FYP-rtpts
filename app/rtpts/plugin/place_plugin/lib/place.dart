class Place{
  String name;
  String address;
  String formatedAddress;
  String placeId;
  double lat;
  double lng;

  Place(this.placeId, this.name, this.address);

  static List<Place> fromNative(List results) {
    return results.map((p)=>Place.fromJson(p)).toList();
  }

  factory Place.fromJson(Map<dynamic,dynamic> json) => Place(
    json['id'],
    json['name'],
    json['address'] != null ? json['address'] : ""
  );
}