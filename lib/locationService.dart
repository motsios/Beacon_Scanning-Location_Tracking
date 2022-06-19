import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart' as location;

class LocationClass {
  final double latitude;
  final double longitude;
  final double accuracy;
  LocationClass(this.latitude, this.longitude, this.accuracy);
}

class LocationService {
  static final LocationService locationService = LocationService._internal();
  location.Location _locationService = location.Location();
  location.PermissionStatus _permission;
  LocationClass currentLocation;
  Timer timer;
  factory LocationService() {
    return locationService;
  }

  LocationService._internal();

  updateLocation(loc) {
    currentLocation = setGPSlocation(loc.latitude, loc.longitude, loc.accuracy);
    resultFlutterToast(currentLocation);
  }

  resultFlutterToast(gpslocationNow) async {
    if (gpslocationNow != null) {
      Fluttertoast.showToast(
          msg:
              "New location tracking\nLatitude: ${gpslocationNow.latitude}\nLongitude: ${gpslocationNow.longitude}",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.green[900],
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  stopService() async {
    try {
      timer.cancel();
    } catch (e) {}
  }

  setGPSlocation(latitude, longitude, accuracy) {
    return LocationClass(latitude, longitude, accuracy);
  }

  initialize() async {
    bool serviceStatus = await _locationService.serviceEnabled();
    if (serviceStatus) {
      try {
        _permission = await _locationService.requestPermission();
        if (_permission == location.PermissionStatus.granted) {
          geolocator.Position locationFromGeolocator;
          locationFromGeolocator =
              await geolocator.Geolocator.getCurrentPosition();

          LocationClass object;
          object = LocationClass(
            locationFromGeolocator.latitude,
            locationFromGeolocator.longitude,
            locationFromGeolocator.accuracy,
          );
          updateLocation(object);
          timer = Timer.periodic(Duration(milliseconds: 5000), (Timer t) async {
            locationFromGeolocator =
                await geolocator.Geolocator.getCurrentPosition(
                    desiredAccuracy: geolocator.LocationAccuracy.high);

            LocationClass object;
            object = LocationClass(
              locationFromGeolocator.latitude,
              locationFromGeolocator.longitude,
              locationFromGeolocator.accuracy,
            );
            updateLocation(object);
          });
        }
      } catch (e) {}
    }
  }
}
