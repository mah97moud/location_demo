import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_demo/location_cubit.dart';
import 'package:location_demo/location_state.dart';
import 'package:location_demo/locations_screen.dart';

class MyLocation extends StatefulWidget {
  const MyLocation({Key? key}) : super(key: key);

  @override
  _MyLocationState createState() => _MyLocationState();
}

class _MyLocationState extends State<MyLocation> {
  // LatLng _initialcameraposition = LatLng(0.5937, 0.9629);

  double _width = 0.0;
  List locations = [];

  @override
  void initState() {
    super.initState();
    // getLocation();
  }

  @override
  void dispose() {
    // _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var cubit = LocationCubit.get(context);
    return Scaffold(
      body: BlocConsumer<LocationCubit, LocationState>(
        builder: (context, state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: double.infinity,
              ),
              GestureDetector(
                onTap: () {
                  cubit.getLocation();
                  cubit.startTimer();
                  cubit.isStop = false;

                  setState(() {
                    _width = 200.0;
                    print(cubit.dutration);
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
                duration: Duration(minutes: cubit.dutration),
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
                  if (cubit.currentPosition != null)
                    Text(
                      'lang' + cubit.currentPosition!.latitude.toString(),
                    ),
                  if (cubit.currentPosition != null)
                    Text(
                      'long' + cubit.currentPosition!.longitude.toString(),
                    ),
                ],
              ),
              const SizedBox(
                height: 20.0,
              ),
              Text(
                '${cubit.start}',
              ),
            ],
          );
        },
        listener: (_, state) {
          if (cubit.isStop == false) {
            cubit.moreLocation(state, context);
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          cubit.navTo(context);
        },
        child: const CircleAvatar(
          backgroundColor: Colors.red,
          radius: 35.0,
          child: Text(
            'stop',
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
        ),
      ),
    );
  }
}
