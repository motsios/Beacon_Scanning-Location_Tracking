import 'package:flutter/material.dart';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:BeaconGPSLocation/locationService.dart';
import 'dart:async';
import 'package:BeaconGPSLocation/scanBeaconService.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'package:flutter_blue/flutter_blue.dart';

var ibeacon = IbeaconService();
StreamController cntrlrGPSLocation = StreamController.broadcast();
bool start = false;
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Beacons scanning and location tracking',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Beacons scanning and location tracking'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            !start
                ? Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Text(
                      '1. Enable Bluetooth and Gps!\n\n2. Press START to scan beacons and tracking yours location',
                      style: TextStyle(fontSize: 25.0, color: Colors.white),
                      textAlign: TextAlign.center,
                    ))
                : Text(
                    "Location or the detected beacon will appear on your screen",
                    style: TextStyle(fontSize: 25.0, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
            SizedBox(height: 50),
            SizedBox(height: 30),
            !start
                ? FlatButton(
                    onPressed: () async {
                      final FlutterBlue _flutterBlue = FlutterBlue.instance;
                      final bool bluetoothStatus = await _flutterBlue.isOn;
                      Location location = Location();

                      bool locationStatus;
                      locationStatus = await location.serviceEnabled();
                      if (bluetoothStatus == false || locationStatus == false) {
                        Fluttertoast.cancel();
                        Fluttertoast.showToast(
                            msg: "Enable GPS and Bluetooth",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.red[900],
                            textColor: Colors.white,
                            fontSize: 16.0);
                      } else {
                        setState(() {
                          start = true;
                        });

                        await flutterBeacon.initializeScanning;
                        await ibeacon.startScanning();
                        var locationService = LocationService();
                        locationService.initialize();

                        Fluttertoast.cancel();
                        Fluttertoast.showToast(
                            msg:
                                "Location or the detected beacon will appear on your screen",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            backgroundColor: Colors.blue[900],
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }
                    },
                    color: Colors.blue[900],
                    child: Text('START', style: TextStyle(color: Colors.white)))
                : FlatButton(
                    onPressed: () async {
                      ibeacon.stopScanning();
                      setState(() {
                        start = false;
                      });
                      Fluttertoast.cancel();
                      Fluttertoast.showToast(
                          msg: "Stopped scanning beacons and location tracking",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          backgroundColor: Colors.red[900],
                          textColor: Colors.white,
                          fontSize: 16.0);
                    },
                    color: Colors.red[900],
                    child: Text('STOP', style: TextStyle(color: Colors.white)))
          ],
        ),
      ),
    );
  }
}
