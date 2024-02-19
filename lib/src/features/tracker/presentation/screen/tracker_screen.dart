import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:tracker/src/config/router/app_routes.dart';
import 'package:tracker/src/core/resources/colors.dart';
import 'package:tracker/src/core/services/geolocation/location_service.dart';
import 'package:tracker/src/core/utils/common.dart';
import 'package:tracker/src/features/tracker/presentation/bloc/tracker/tracker_bloc.dart';
import 'package:tracker/src/features/tracker/presentation/widget/reload_btn.dart';

class TrackerScreen extends StatelessWidget {
  TrackerScreen({super.key});
  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    location.onLocationChanged.listen((LocationData currentLocation) {
      context.read<TrackerBloc>().add(TrackerStarted(locationData: currentLocation));
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.transparent,
        title: TextButton(
            onPressed: () {
              context.push(AppRoutesList.tracerScreen);
            },
            child: Text("Tracker")),
      ),
      bottomNavigationBar: BlocBuilder<TrackerBloc, TrackerState>(builder: (context, state) {
        if (state is TrackerLoaded) {
          String address = getCurrentLocation(state.placemark);
          return currentLocationWidget(address);
        }
        return const Offstage();
      }),
      body: BlocBuilder<TrackerBloc, TrackerState>(
        builder: (context, state) {
          if (state is TrackerLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TrackerLoaded) {
            return mapWidget(state);
          }
          return reloadBtn(context);
        },
      ),
    );
  }

  FlutterMap mapWidget(TrackerLoaded state) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialZoom: 17.0,
        maxZoom: 19.0,
        minZoom: 8.0,
        initialCenter: LatLng(state.location!.latitude!, state.location!.longitude!),
        keepAlive: true,
        interactionOptions: const InteractionOptions(
          enableMultiFingerGestureRace: true,
          flags: InteractiveFlag.doubleTapDragZoom | InteractiveFlag.doubleTapZoom | InteractiveFlag.drag | InteractiveFlag.flingAnimation | InteractiveFlag.pinchZoom,
        ),
        onPositionChanged: (position, hasGesture) {},
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        ),
        // Widget for displaying the current location marker
        CurrentLocationLayer(
          alignPositionOnUpdate: AlignOnUpdate.always,
          alignDirectionOnUpdate: AlignOnUpdate.once,
          style: const LocationMarkerStyle(
            marker: DefaultLocationMarker(
              child: Icon(Icons.navigation, color: Colors.white, size: 16),
            ),
            markerSize: Size(30, 30),
            markerDirection: MarkerDirection.heading,
          ),
          positionStream: const LocationMarkerDataStreamFactory().fromGeolocatorPositionStream(),
        ),
      ],
    );
  }

  Container currentLocationWidget(String address) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Flexible(
            child: Text(
              "Current Location",
              overflow: TextOverflow.visible,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Flexible(
            child: Text(
              address,
              overflow: TextOverflow.visible,
            ),
          ),
        ],
      ),
    );
  }
}
