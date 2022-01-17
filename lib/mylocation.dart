import 'package:flutter/material.dart';
import 'package:location/location.dart';

class MyLocation extends StatefulWidget {
  const MyLocation({Key? key}) : super(key: key);

  @override
  _MyLocationState createState() => _MyLocationState();
}

class _MyLocationState extends State<MyLocation> {
  LocationData? _currentPosition;
  String? _address, _dateTime;
  Location location = Location();
  // LatLng _initialcameraposition = LatLng(0.5937, 0.9629);

  int _dutration = 1;
  double _width = 0.0;
  List locations = [];

  @override
  void initState() {
    super.initState();
    getLocation();
  }

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

    _currentPosition = await location.getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: double.infinity,
          ),
          GestureDetector(
            onTap: () {
              for (int i = 0; i <= 60; i = i + 5) {
                getLocation();

                print(locations);
                print(_currentPosition);
                print(i);
              }
              setState(() {
                _width = 200.0;
                print(_dutration);
              });
            },
            child: const CircleAvatar(
              radius: 35.0,
              child: Text(
                'Find',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          AnimatedContainer(
            duration: Duration(minutes: _dutration),
            width: _width,
            height: 20.0,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Column(
            children: [
              if (_currentPosition != null)
                Text(
                  'lang' + _currentPosition!.latitude.toString(),
                ),
              if (_currentPosition != null)
                Text(
                  'long' + _currentPosition!.longitude.toString(),
                ),
            ],
          ),
          SizedBox(
            height: 20.0,
          ),
        ],
      ),
    );
  }
}
