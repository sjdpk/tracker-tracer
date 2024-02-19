import 'dart:convert';
import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:tracker/src/features/tracker/domain/entity/notification_entity.dart';
import 'package:http/http.dart' as http;
import 'package:tracker/src/features/tracker/domain/entity/tracker_entity.dart';

abstract class RemoteTrackerDataSource {
  Future<void> saveTrackerLocation({String? uuid, required RemoteLocationDataEntity remoteLocationData});
  Future<http.Response> sendNotification({required NotificationEntity notificationEntity});
}

class RemoteTrackerDataSourceImpl extends RemoteTrackerDataSource {
  final http.Client _client;
  RemoteTrackerDataSourceImpl(this._client);

  // @desc : save user location in firebase realtime db
  // @param : uuid, RemoteLocationDataEntity
  @override
  Future<void> saveTrackerLocation({String? uuid, required RemoteLocationDataEntity remoteLocationData}) async {
    DatabaseReference database = FirebaseDatabase.instance.ref("LOCATION_DB");
    await database.child(uuid ?? "1234").set(remoteLocationData.toJson());
  }

  // @desc : send notification to the user
  // @param : NotificationEntity
  // @return : http.Response
  @override
  Future<http.Response> sendNotification({required NotificationEntity notificationEntity}) async {
    final response = await _client.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: {
        HttpHeaders.authorizationHeader: 'key=AAAAUQrMWMo:APA91bEtaRoacDvRCRAR_EMvnhPJi7pcn_MCgRvKHV8Ld4n_wGk3iAUHB7OylA3iYQJctH3JtmCwdBu_MBXdqJLcsODhk91e5uLjlWToUfAVkzzH5yIJP5sbBbth65J6hRkH5aptNJXy',
        HttpHeaders.contentTypeHeader: 'application/json',
      },
      body: jsonEncode(notificationEntity.toJson()),
    );
    return response;
  }
}
