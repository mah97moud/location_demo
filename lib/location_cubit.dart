import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocode/geocode.dart';
import 'package:location/location.dart';
import 'package:location_demo/location_state.dart';
import 'package:location_demo/locations_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit() : super(InitState());

  static LocationCubit get(context) => BlocProvider.of(context);

  LocationData? currentPosition;
  // String? _address, _dateTime;
  Location location = Location();

  getLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();

    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    currentPosition = await location.getLocation();
    locationsList.add(currentPosition);
    emit(LoadingState());
  }

  Timer? _timer;
  int start = 60;
  int dutration = 1;

  void startTimer() {
    Duration oneMin = Duration(seconds: dutration);
    _timer = Timer.periodic(
      oneMin,
      (Timer timer) {
        if (start == 0) {
          emit(StartStateStart());
          timer.cancel();
        } else {
          emit(StartStatefinal());
          start--;
        }
      },
    );
  }

  List locationsList = [];

  Future<void> moreLocation(state, context) async {
    if (state is StartStateStart) {
      getLocation();
      start = 60;
      startTimer();
      print(currentPosition);

      locationsList.add(currentPosition);
      print(locationsList[0].longitude);

      Address add = await locationName(
          locationsList[0].latitude, locationsList[0].longitude);
      print(add.city);
    }
  }

  Future<Address> locationName(latitude, longitude) async {
    GeoCode geoCode = GeoCode();
    return await geoCode.reverseGeocoding(
      latitude: latitude,
      longitude: longitude,
    );
  }

  bool isStop = false;
  navTo(context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LocationsScreen(),
      ),
    );
    isStop = true;
    emit(StopState());
  }

  Future<void> openLocation(double latitude, double longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }
}
