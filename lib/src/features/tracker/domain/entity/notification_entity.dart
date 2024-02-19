class NotificationEntity {
  final String topic;
  final String title;
  final String body;
  final Map<String, dynamic>? data;
  NotificationEntity({
    required this.topic,
    required this.title,
    required this.body,
    this.data,
  });

  Map<String, dynamic> toJson() {
    return {
      "to": "/topics/$topic",
      "notification": {
        "title": title,
        "body": body,
        "data": data ?? {}
      },
    };
  }
}
