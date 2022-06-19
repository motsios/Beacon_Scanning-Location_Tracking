import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'locationService.dart';
import 'package:fluttertoast/fluttertoast.dart';

StreamSubscription streamScanning;

class IbeaconService {
  startScanning() async {
    final regions = <Region>[];

    regions.add(Region(
        identifier: 'testing_beacon',
        proximityUUID: 'f7826da6-4fa2-4e98-8024-bc5b71e0893e',
        major: 34665,
        minor: 54103));

    streamScanning =
        flutterBeacon.monitoring(regions).listen((MonitoringResult result) {
      if (result.monitoringState.toString() == "MonitoringState.inside") {
        Fluttertoast.showToast(
            msg:
                "Beacon detected\nUUID: ${result.region.proximityUUID}\nMajor: ${result.region.major}\nMinor: ${result.region.minor}",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.green[900],
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }

  stopScanning() {
    var locationService = LocationService();
    locationService.stopService();
    streamScanning.cancel();
  }
}
