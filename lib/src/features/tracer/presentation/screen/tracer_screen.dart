import 'package:ed_screen_recorder/ed_screen_recorder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:tracker/src/core/resources/colors.dart';
import 'package:tracker/src/core/services/firebase/firebase.dart';
import 'package:tracker/src/core/services/geolocation/location_service.dart';
import 'package:tracker/src/features/tracker/domain/entity/tracker_entity.dart';
import 'package:tracker/src/features/tracker/presentation/widget/reload_btn.dart';

class TracerScreen extends StatelessWidget {
  TracerScreen({super.key});
  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              LocalNotificationService.show(title: "Tracker is Offline", body: "We will update you once Tracker's back online.");
            }

            return mapWidget(context, remoteLocationData, isOffline: isOffline);
          }

          return reloadBtn(context);
        },
      ),
    );
  }

  FlutterMap mapWidget(BuildContext context, RemoteLocationDataEntity remoteLocationData, {bool isOffline = false}) {
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
                Icons.circle,
                size: 40,
                color: Colors.blue,
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: currentLocationWidget(remoteLocationData.address, isOffline: isOffline),
        ),

        // align booton right floating button move map to curren position
        Align(
          alignment: Alignment.bottomRight,
          child: Container(
            margin: const EdgeInsets.only(bottom: 120, right: 20),
            child: FloatingActionButton(
              onPressed: () {
                _mapController.move(LatLng(remoteLocationData.latitude as double, remoteLocationData.longitude as double), 17.0);
              },
              child: const Icon(Icons.my_location),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: GestureDetector(
            onTap: () async {
              final Size size = MediaQuery.sizeOf(context);
              await EdScreenRecorder().startRecordScreen(
                fileName: "tracer-screen",
                width: size.width ~/ 1,
                height: size.height ~/ 1,
                audioEnable: true,
              );
            },
            child: Container(
              height: 30,
              decoration: BoxDecoration(
                color: AppColor.error,
                shape: BoxShape.circle,
                border: Border.all(color: AppColor.primary, width: 2),
              ),
              margin: const EdgeInsets.fromLTRB(0, 64, 20, 0),
              padding: const EdgeInsets.all(4),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.fiber_manual_record_rounded, color: isOffline ? Colors.red : Colors.green),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Container currentLocationWidget(String address, {bool isOffline = false}) {
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
          Flexible(
            child: Text(
              "Tracker ${isOffline ? "Last" : "Current"} Location",
              overflow: TextOverflow.visible,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
