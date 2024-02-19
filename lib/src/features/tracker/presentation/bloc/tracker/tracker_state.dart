part of 'tracker_bloc.dart';

abstract class TrackerState extends Equatable {
  final LocationData? location;
  final List<geocoding.Placemark>? placemark;
  final String? error;
  final bool isNewOnline;
  const TrackerState({this.location, this.placemark, this.error, this.isNewOnline = true});
  @override
  List<Object?> get props => [
        location,
        placemark,
        error,
        isNewOnline,
      ];
}

class TrackerLoading extends TrackerState {}

class TrackerLoaded extends TrackerState {
  const TrackerLoaded({super.location, super.placemark, super.isNewOnline});
}

class TrackerError extends TrackerState {
  const TrackerError({super.error});
}
