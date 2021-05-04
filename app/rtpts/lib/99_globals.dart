library my_prj.globals;

var carpark_place_url = 'https://api.data.gov.hk/v1/carpark-info-vacancy';
var carpark_vac_url = 'https://api.data.gov.hk/v1/carpark-info-vacancy?data=vacancy';

var carpark_place;
var carpark_vac;

var pick_mode;

var starting_points, destination;
var starting_points_tmp, destination_tmp;


var link_request;
var result;
var hr;
var lat_01, lng_01, lat_02, lng_02;

var time_c = 0;

var choice;

var type, oil, distance;

var email;
var reg;