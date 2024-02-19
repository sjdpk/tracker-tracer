class RemoteLocationDataEntity {
  final num latitude;
  final num longitude;
  final String timestamp;
  final String address;
  RemoteLocationDataEntity({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    required this.address,
  });
  factory RemoteLocationDataEntity.fromJson(Map<String, dynamic> json) {
    return RemoteLocationDataEntity(
      address: json['address'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      timestamp: json['timestamp'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'timestamp': timestamp,
    };
  }
}
