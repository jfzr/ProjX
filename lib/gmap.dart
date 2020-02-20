import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    /*_getData();
    _createMarkersReports();*/
  }

  @override
  Widget build(BuildContext context) {
    print('Values for map: $_currentPosition, $allReports');
    if(_currentPosition == null || allReports == null)
      return Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(
                backgroundColor: Colors.green,
              ),
            ],
          )
      );

    if(markers.length < allReports.length +1){
      _createMarkersReports();
      return Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(
                backgroundColor: Colors.green,
              ),
              Text('Cargando Reportes')
            ],
          )
      );
    }

    print('Creating map');


    return Scaffold(
      appBar: AppBar(title: Text('Mapa de reportes')),
      body: GoogleMap(
        //mapType: MapType.normal,
        zoomGesturesEnabled: true,
        initialCameraPosition: CameraPosition(
          target: LatLng(_currentPosition.latitude, _currentPosition.longitude),
          zoom: 13,
        ),
        markers: Set.from(markers),
        onMapCreated: (GoogleMapController controller){
          _controller.complete(controller);
        },
      ),
    );
  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png)).buffer.asUint8List();
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
  _getCurrentLocationAndData() {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        if (_currentPosition != null){
          print('Posicion Obtenida');
          getBytesFromAsset('assets/womanpin.png', 100).then((pin){
            setState(() {
              markers.add(Marker(
                markerId: MarkerId("Yo"),
                draggable: false,
                position: LatLng(_currentPosition.latitude, _currentPosition.longitude),
                icon: BitmapDescriptor.fromBytes(pin),
              ));
            });
          });
          _getData();
          print('-----------------');
         //_createMarkersReports();
        }
      });
    }).catchError((e) {
      print(e);
    });
  }

  _createMarkersReports() {
    if (allReports ==null)
      return;

    allReports.forEach((repo) {
      String pinType = 'assets';
      switch(repo.status){
        case 'EXPERIMENTADO':{pinType = '$pinType/pin1.png';}
        break;
        case 'TESTIGO':{pinType = '$pinType/pin2.png';}
        break;
        case 'RIESGO':{pinType = '$pinType/pin3.png';}
        break;
      }
      getBytesFromAsset(pinType, 100).then((pin){
        setState(() {
          markers.add(
              Marker(
                markerId: MarkerId(repo.id.toString()),
                draggable: false,
                position: LatLng(repo.latitude, repo.longitude),
                icon: BitmapDescriptor.fromBytes(pin),
              )
          );
        });
      });

    }
    );
  }

}