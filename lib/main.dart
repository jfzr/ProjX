import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:projx_v01/gmap.dart';
import 'package:projx_v01/httpServ.dart';
import 'package:projx_v01/report.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(ProjX());

class ProjX extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ProjX',
      home: HomePage(),
      routes: <String, WidgetBuilder>{
        '/report': (BuildContext context) => new ReportWidget(),
        '/home': (BuildContext context) => new HomePage(),
        '/gmap': (BuildContext context) => new GMap(),
      },
    );
  }
}

class HomePage extends StatelessWidget {

  HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    //TOP AREA
    Widget topButtons = Row(
      children: <Widget>[
        Container( //BT button
          padding: const EdgeInsets.all(25),
          child: Align(
            child: _buildTopButtonBT(Colors.blueAccent, Colors.white, Icons.announcement, 'Pair device'),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(25),
          //alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTopButtonCall(Colors.yellowAccent, Colors.yellowAccent, Icons.announcement, 'YELLOW ALARM'),
              _buildTopButtonVideo(Colors.redAccent, Colors.redAccent, Icons.error, 'RED ALARM')
            ],
          ),
        )
      ],
    );


    //////////MAP AREA ///////////
    Widget mapArea = Container( decoration: BoxDecoration(
        border:  Border.all(
          color: Colors.lightBlue,
          width: 5.0,
          style: BorderStyle.solid,
        )
    ),
        //color: Colors.redAccent,
        child: _miniHeatMap(context)
    );

    ////////REPORT AREA////////
    mainBottomSheet(BuildContext context){
      showModalBottomSheet(
          context: context,
          builder: (BuildContext context){
            return Column(
              children: <Widget>[
                _createTile(context, 'Experimentado', Icons.face, "EXPERIMENTADO"),
                _createTile(context, 'Testigo', Icons.camera, "TESTIGO"),
                _createTile(context, 'Riesgo', Icons.announcement, "RIESGO")
              ],
            );
          }
      );
    }

    RaisedButton _reportButton(BuildContext context){
      return RaisedButton.icon(
        onPressed: () => mainBottomSheet(context),
        icon: Icon(Icons.add_comment),
        label: Text('Reportar un evento'),
      );
    }

    Widget reportArea = Center(
      child: Column(
        children: <Widget>[
          _reportButton(context)
        ],
      ),
    );


    ///////////////BROADCAST ALERT BUTTON///////////////
    Widget broadcastAlertButton = Center(
      child: RaisedButton.icon(
          onPressed: () {},
          icon: Icon(Icons.all_out),
          label: Text("Broadcast Alert")
      ),
    );

    //////////////Social N////////////
    Widget socialN = Center(
      child:  RaisedButton.icon(
          onPressed: () {},
          icon: Icon(Icons.face),
          label: Text("Connect to Social Networks")
      ),
    );

    ////////Settings button//////
    Widget settings = Container(
        alignment: Alignment.bottomRight,
        child: FlatButton.icon(
            onPressed: () {
             /* HttpService httpServ = HttpService();
              httpServ.getReportsByCoor(37.432997, -122.045528);*/
            },
            color: Colors.indigoAccent,
            icon: Icon(Icons.settings),
            label: Text("Settings",
              style: TextStyle(
                  fontSize: 9
              ),
            )
        )
    );


    ///////////////Main Structure/////////////////
    return Scaffold(
      appBar: AppBar(
          title: Text('ProjX')
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          topButtons,
          mapArea,
          SizedBox(height: 10),
          reportArea,
          SizedBox(height: 10),
          broadcastAlertButton,
          SizedBox(height: 10),
          socialN,
          Divider(
            thickness: 1.5,
            color: Colors.black26,
          ),
          SizedBox(height: 10),
          settings
        ],
      ),
    );
  }
///////////////Main Structure -- END/////////////////
  Column _miniHeatMap(BuildContext context){
    return Column(
      children: <Widget>[
        GestureDetector(
          child:  Image(
            image: AssetImage('assets/map0.jpg'),
          ),
          onTap: (){

            Navigator.pushNamed(context, '/gmap');
          },
        )
      ],
    );


  }
/////HOME CLASS END/////

  Column _buildTopButtonCall(Color color, Color bg,IconData icon, String label){
    return Column(
      children: <Widget>[
        IconButton(
          onPressed: _launchURL,
          icon: Icon(icon, color: color),
        ),
        Container(
          margin: const EdgeInsets.only(top: 8),
          color: bg,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
        )
      ],
    );
  }

  Column _buildTopButtonVideo(Color color, Color bg,IconData icon, String label){
    return Column(
      children: <Widget>[
        IconButton(
          onPressed: (){},
          icon: Icon(icon, color: color),
        ),
        Container(
          margin: const EdgeInsets.only(top: 8),
          color: bg,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
        )
      ],
    );
  }

  Column _buildTopButtonBT (Color color, Color bg,IconData icon, String label){
    return Column(
      children: <Widget>[
        IconButton(
          onPressed: (){},
          icon: Icon(icon, color: color),
        ),
        Container(
          margin: const EdgeInsets.only(top: 8),
          color: bg,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
        )
      ],
    );
  }



  _launchURL() async {
    launch("tel://911");


    /*android_intent.Intent()
      ..setAction(android_action.Action.ACTION_DIAL)
      ..setData(Uri(scheme: "tel", path: "012732768"))
      ..startActivity().catchError((e) => print(e));*/
  }

  _pairMode(){

  }
}



ListTile _createTile(BuildContext context, String name, IconData icon, String type){
  return ListTile(
    leading: Icon(icon),
    title: Text(name),
    onTap: (){
      //Navigator.pop(context);
      //Navigator.of(context).pushNamed('/report');
      Navigator.pushNamed(context, '/report', arguments: type);
    },
  );
}


class ReportWidget extends StatefulWidget{
  /*final String type;

  const ReportWidget({Key key, this.type}) : super(key: key);*/

  @override
  State<StatefulWidget> createState() {
    return ReportState();
  }
}

class ReportState extends State<ReportWidget> {
  final _formKey = GlobalKey<FormState>();

  Position _currentPosition;

  @override
  Widget build(BuildContext context) {
    final String type = ModalRoute.of(context).settings.arguments;


    String info;

    return  Scaffold(
        appBar: AppBar(
          title: Text('Ingrese su reporte'),
        ),
        body:Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 25,),
              Column(
                children: <Widget>[
                  Text('Tipo de Reporte:'  + type,
                    style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),),
                  SizedBox(height: 15,),
                  Divider(height: 5, color: Colors.indigo,),
                  _currentPosition == null
                      ? CircularProgressIndicator()
                      : Text('Location: ' + _currentPosition.latitude.toString() + ' & ' + _currentPosition.longitude.toString()),
                  Padding(
                    padding: EdgeInsets.all(8),
                    child: RaisedButton.icon(
                      onPressed:() {
                        print('GPS request');
                        _getCurrentLocation();
                        /*print("GPS click!");
                          _getLocation().then((value){
                            setState(() {
                              data = value;
                            });
                          });*/
                      },
                      label: Text('GPS'),
                      icon: Icon(Icons.gps_fixed),
                    ),
                  ),
                  SizedBox(height: 15,),
                  Divider(height: 5, color: Colors.green,),
                  Text('Ingrese su reporte:'),
                  SizedBox(height: 10,),
                  //Text('Location: Lat${userLocation?.latitude}, Long: ${userLocation?.longitude}')
                ],
              ),
              TextFormField(
                validator: (value){
                  if (value.isEmpty){
                    return'Ingrese informacion';
                  } else {
                    info = value;
                  }
                  return null;
                },
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Builder(
                    builder: (context) => RaisedButton(
                      onPressed: (){
                        print("CLICK! ---<>< $info");
                        if (_formKey.currentState.validate()){
                          //print(data.longitude.toString() + " --------------------------------");
                          if (_currentPosition == null)
                            _getCurrentLocation();

                          Report report = Report(type, _currentPosition.longitude, _currentPosition.latitude, info);


                          HttpService httpServ = HttpService();
                          httpServ.postReport(report);

                          Scaffold.of(context)
                              .showSnackBar(SnackBar(content: Text('Reporte enviado')));

                        }
                      },
                      child: Text('Enviar'),
                    ),
                  )

              )
            ],
          ),
        )
    );
  }

  _getCurrentLocation() {
    final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
    }).catchError((e) {
      print(e);
    });
  }
}
