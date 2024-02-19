import 'package:firebase_database/firebase_database.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:location/location.dart';
import 'package:tracker/src/features/tracker/domain/entity/tracker_entity.dart';

Location location = Location();

class LocationService {
  DatabaseReference database = FirebaseDatabase.instance.ref("LOCATION_DB");

  /// check permission
  /// @desc :  Check the current status of the location services.
  static Future<PermissionStatus> checkPermission() async {
    bool serviceEnabled;
    PermissionStatus permission;

    // Test if location services are enabled.
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await location.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await location.requestPermission();
      if (permission == PermissionStatus.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == PermissionStatus.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }
    return permission;
  }

// @desc: get human readable address from lat long
  static Future<List<geocoding.Placemark>> getUserLocation({double? latitude, double? longitude}) async {
    late double lat;
    late double long;

    if (latitude == null || longitude == null) {
      final LocationData position = await location.getLocation();
      lat = position.latitude!;
      long = position.longitude!;
    } else {
      lat = latitude;
      long = longitude;
    }

    return await geocoding.placemarkFromCoordinates(lat, long);
  }

  Future<bool> checkUserExistance({required String userId}) async {
    final DatabaseEvent databaseEvent = await database.child(userId).once();
    bool isExists = databaseEvent.snapshot.exists;
    return isExists;
  }

  DatabaseReference getUserLocationTrackDetailByUUId({required String uuid}) {
    return FirebaseDatabase.instance.ref("LOCATION_DB/$uuid");
  }

  RemoteLocationDataEntity? getRemoteLocationData(String serviceProviderId) {
    RemoteLocationDataEntity? remoteLocationData;
    DatabaseReference reference = getUserLocationTrackDetailByUUId(uuid: serviceProviderId);
    reference.onValue.listen(
      (event) {
        if (event.snapshot.value != null) {
          // Data is available
          Map<dynamic, dynamic>? locationData = event.snapshot.value as Map<dynamic, dynamic>?;
          if (locationData != null) {
            final RemoteLocationDataEntity data = RemoteLocationDataEntity.fromJson(locationData as Map<String, dynamic>);
            remoteLocationData = data;
          }
        }
      },
    );
    return remoteLocationData;
  }
}
