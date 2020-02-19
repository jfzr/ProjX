import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'httpServ.dart';
import 'report.dart';

class GMap extends StatefulWidget{

  @override
  State<GMap> createState() => GMapState();
}

class GMapState extends State<GMap>{

  Completer<GoogleMapController> _controller = Completer();

  List<Report> allReports;
  Position _currentPosition;
  List<Marker> markers = [];

  @override
  void initState() {
    super.initState();
    _getCurrentLocationAndData();

    //_getData();
  }

  _getData() {
    assert (_currentPosition != null);
    HttpService httpServ = HttpService();
    Future<List<Report>> reports = httpServ.getReportsByCoor(_currentPosition.latitude, _currentPosition.longitude);
    reports.then((value) {
      setState(() {
        allReports = value;
        print('Report values set: $value');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print('Values for map: $_currentPosition, $allReports');
    if(_currentPosition == null)
      return Scaffold(
          body: Row(
            children: <Widget>[
              CircularProgressIndicator(
                backgroundColor: Colors.green,
              ),
            ],
          )
      );

    return Scaffold(
      appBar: AppBar(title: Text('Mapa de reportes')),
      body: GoogleMap(
        //mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: LatLng(_currentPosition.latitude, _currentPosition.longitude),
          zoom: 14,
        ),
        markers: Set.from(markers),
        onMapCreated: (GoogleMapController controller){
          _controller.complete(controller);
        },
      ),
    );
  }

  _getCurrentLocationAndData() {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        if (_currentPosition != null){
          print('Posicion Obtenida');
          markers.add(Marker(
              markerId: MarkerId("Yo"),
              draggable: false,
              position: LatLng(_currentPosition.latitude, _currentPosition.longitude),
          ));
          _getData();
        }
      });
    }).catchError((e) {
      print(e);
    });
  }

}