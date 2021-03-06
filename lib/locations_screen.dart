import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocode/geocode.dart';
import 'package:location_demo/location_cubit.dart';
import 'package:location_demo/location_state.dart';

class LocationsScreen extends StatelessWidget {
  const LocationsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = LocationCubit.get(context);
    var list = cubit.locationsList;

    return Scaffold(
      appBar: AppBar(
        title: Text('Locations List'),
      ),
      body: BlocConsumer<LocationCubit, LocationState>(
        builder: (context, state) {
          return ListView.separated(
            itemBuilder: (context, index) => locationItem(cubit, index),
            separatorBuilder: (context, index) => Container(
              height: 10.0,
            ),
            itemCount: cubit.locationsList.length,
          );
        },
        listener: (context, state) {},
      ),
    );
  }

  Widget locationItem(LocationCubit cubit, int index) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Cairo',
          ),
          Text(
            cubit.locationsList[index].latitude.toString(),
          ),
          ElevatedButton(
            onPressed: () {
              cubit.openLocation(cubit.locationsList[index].latitude,
                  cubit.locationsList[index].longitude);
            },
            child: const Text('Open Location'),
          ),
        ],
      ),
    );
  }
}
