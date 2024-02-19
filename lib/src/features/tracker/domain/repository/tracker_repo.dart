import 'package:tracker/src/core/network/data_state.dart';
import 'package:tracker/src/features/tracker/domain/entity/notification_entity.dart';
import 'package:tracker/src/features/tracker/domain/entity/tracker_entity.dart';

abstract class TrackerRepository {
  Future<DataState<void>> saveTrackerLocation({String? uuid, required RemoteLocationDataEntity remoteLocationData});
  Future<DataState<bool>> sendNotification({required NotificationEntity notificationEntity});
}
