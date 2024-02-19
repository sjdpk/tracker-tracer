import 'package:tracker/src/core/network/data_state.dart';
import 'package:tracker/src/features/tracker/data/datasource/remote/tracker_data_source.dart';
import 'package:tracker/src/features/tracker/domain/entity/notification_entity.dart';
import 'package:tracker/src/features/tracker/domain/entity/tracker_entity.dart';
import 'package:tracker/src/features/tracker/domain/repository/tracker_repo.dart';

class TrackerRepositoryImpl extends TrackerRepository {
  final RemoteTrackerDataSource _remoteTrackerDataSource;
  TrackerRepositoryImpl(this._remoteTrackerDataSource);
  // @desc : save user location in firebase realtime db
  // @param : uuid, RemoteLocationDataEntity
  @override
  Future<DataState<void>> saveTrackerLocation({String? uuid, required RemoteLocationDataEntity remoteLocationData}) async {
    try {
      await _remoteTrackerDataSource.saveTrackerLocation(uuid: uuid, remoteLocationData: remoteLocationData);
      return const DataSucessState(null);
    } catch (e) {
      return DataErrorState(e.toString());
    }
  }

  // @desc : send notification to the user
  // @param : NotificationEntity
  @override
  Future<DataState<bool>> sendNotification({required NotificationEntity notificationEntity}) async {
    try {
      final response = await _remoteTrackerDataSource.sendNotification(notificationEntity: notificationEntity);
      if (response.statusCode == 200) {
        return const DataSucessState(true);
      } else {
        final error = response.body.toString();
        return DataErrorState(error);
      }
    } catch (e) {
      return DataErrorState(e.toString());
    }
  }
}
