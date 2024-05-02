class NotificationModel {
  int? id;
  int? userId;
  String? date;
  String? time;
  String? title;
  String? description;
  int? isRead;
  NotificationModel(
      {this.id,
      this.userId,
      this.date,
      this.time,
      this.title,
      this.description,
      this.isRead});

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
        id: json['id'],
        userId: json['user_id'],
        date: json['date'],
        time: json['time'],
        title: json['title'],
        description: json['description'],
        isRead: json['is_read']);
  }
}
