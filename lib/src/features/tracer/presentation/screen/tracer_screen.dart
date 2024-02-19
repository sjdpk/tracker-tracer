import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:tracker/src/core/services/firebase/firebase.dart';
import 'package:tracker/src/core/services/geolocation/location_service.dart';
import 'package:tracker/src/core/utils/common.dart';
import 'package:tracker/src/features/tracker/domain/entity/tracker_entity.dart';
import 'package:tracker/src/features/tracker/presentation/bloc/tracker/tracker_bloc.dart';
import 'package:tracker/src/features/tracker/presentation/widget/reload_btn.dart';

class TracerScreen extends StatelessWidget {
  TracerScreen({super.key});
  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BlocBuilder<TrackerBloc, TrackerState>(builder: (context, state) {
        if (state is TrackerLoaded) {
          String address = getCurrentLocation(state.placemark);
          return currentLocationWidget(address);
        }
        return const Offstage();
      }),
      body: StreamBuilder(
        stream: LocationService().getUserLocationTrackDetailByUUId(uuid: "1234").onValue,
        builder: (context, snapshot) {
          bool offlineNotificationSend = false;

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            Object? data = (snapshot.data!).snapshot.value;
            Map<String, dynamic> locationData = {};

            if (data is Map<Object?, Object?>) {
              data.forEach((key, value) {
                if (key is String) {
                  locationData[key] = value;
                }
              });
            }

            RemoteLocationDataEntity remoteLocationData = RemoteLocationDataEntity.fromJson(locationData);

            // Calculate the time difference
            DateTime currentTime = DateTime.now();
            DateTime lastUpdatedTime = DateTime.parse(remoteLocationData.timestamp);
            Duration difference = currentTime.difference(lastUpdatedTime);

            // Check if the time difference exceeds 1 minute
            bool isOffline = difference.inMinutes > 1;

            // Trigger notification if it's offline and notification hasn't been sent yet
            if (isOffline && !offlineNotificationSend) {
              offlineNotificationSend = true;
              LocalNotificationService.show(title: "Tracker is Offline", body: "Tracker is offline for more than 1 minute");
            }

            return mapWidget(remoteLocationData);
          }

          return reloadBtn(context);
        },
      ),
    );
  }

  FlutterMap mapWidget(RemoteLocationDataEntity remoteLocationData) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialZoom: 17.0,
        maxZoom: 19.0,
        minZoom: 8.0,
        initialCenter: LatLng(remoteLocationData.latitude as double, remoteLocationData.longitude as double),
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
        MarkerLayer(
          markers: [
            Marker(
              point: LatLng(remoteLocationData.latitude as double, remoteLocationData.longitude as double),
              child: const Icon(
                Icons.location_on_outlined,
                size: 40,
                color: Colors.blue,
              ),
            ),
          ],
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
              "Tracker Current Location",
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
