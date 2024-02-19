part of 'tracker_bloc.dart';

abstract class TrackerEvent extends Equatable {
  const TrackerEvent();

  @override
  List<Object> get props => [];
}

class TrackerStarted extends TrackerEvent {
  final LocationData locationData;
  const TrackerStarted({required this.locationData});
}

class TrackerStopped extends TrackerEvent {}
