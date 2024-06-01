class ScheduleModel {
  int? id;
  String? date;
  String? category;
  String? status;

  ScheduleModel({
    this.id,
    this.date,
    this.category,
    this.status,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      id: json['id'],
      date: json['date'],
      category: json['category'],
      status: json['status'],
    );
  }
}
