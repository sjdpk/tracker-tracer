import 'package:tracker/src/core/network/data_state.dart';
import 'package:tracker/src/features/tracker/domain/entity/notification_entity.dart';
import 'package:tracker/src/features/tracker/domain/entity/tracker_entity.dart';
import 'package:tracker/src/features/tracker/domain/repository/tracker_repo.dart';

class TrackerUseCase {
  final TrackerRepository _trackerRepository;
  TrackerUseCase(this._trackerRepository);

  Future<DataState<void>> saveTrackerLocation({String? uuid, required RemoteLocationDataEntity remoteLocationData}) {
    return _trackerRepository.saveTrackerLocation(uuid: uuid, remoteLocationData: remoteLocationData);
  }

  Future<DataState<bool>> sendNotification({required NotificationEntity notificationEntity}) {
    return _trackerRepository.sendNotification(notificationEntity: notificationEntity);
  }
}
