import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:location/location.dart';
import 'package:tracker/src/core/services/geolocation/location_service.dart';
import 'package:tracker/src/core/utils/common.dart';
import 'package:tracker/src/features/tracker/domain/entity/notification_entity.dart';
import 'package:tracker/src/features/tracker/domain/entity/tracker_entity.dart';
import 'package:tracker/src/features/tracker/domain/usecase/tracker_usecase.dart';

part 'tracker_event.dart';
part 'tracker_state.dart';

class TrackerBloc extends Bloc<TrackerEvent, TrackerState> {
  final TrackerUseCase _trackerUseCase;
  TrackerBloc(this._trackerUseCase) : super(TrackerLoading()) {
    on<TrackerStarted>(_onTrackerStarted);
    on<TrackerStopped>(_onTrackerStopped);
  }

  FutureOr<void> _onTrackerStarted(TrackerStarted event, Emitter<TrackerState> emit) async {
    if (state.location == null) emit(TrackerLoading());
    try {
      final permission = await LocationService.checkPermission();
      if (permission == PermissionStatus.granted || permission == PermissionStatus.grantedLimited) {
        location.enableBackgroundMode(enable: true);
        location.changeNotificationOptions(
          title: "Tracker",
          subtitle: "Tracking your location",
        );
        final List<geocoding.Placemark> placemark = await LocationService.getUserLocation(latitude: event.locationData.latitude, longitude: event.locationData.longitude);

        RemoteLocationDataEntity remoteLocationData = RemoteLocationDataEntity(
          latitude: event.locationData.latitude ?? 27.7172,
          longitude: event.locationData.longitude ?? 85.3240,
          address: getCurrentLocation(placemark),
          timestamp: DateTime.now().toString(),
        );
        await _trackerUseCase.saveTrackerLocation(uuid: "1234", remoteLocationData: remoteLocationData);
        // send notification to the user
        if (state.isNewOnline) {
          NotificationEntity notificationEntity = NotificationEntity(
            topic: "tracker",
            title: "Tracker is Online",
            body: "You can See Trcker location",
          );
          await _trackerUseCase.sendNotification(notificationEntity: notificationEntity);
        }
        emit(TrackerLoaded(location: event.locationData, placemark: placemark, isNewOnline: false));
      } else {
        emit(const TrackerError(error: 'Location permission denied'));
      }
    } catch (error) {
      emit(TrackerError(error: error.toString()));
    }
  }

  FutureOr<void> _onTrackerStopped(TrackerStopped event, Emitter<TrackerState> emit) {
    emit(TrackerLoading());
    emit(const TrackerLoaded());
  }
}
