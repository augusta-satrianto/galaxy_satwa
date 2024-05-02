class AttendanceModel {
  int? id;
  int? userId;
  String? date;
  String? checkIn;
  String? checkOut;

  AttendanceModel(
      {this.id, this.userId, this.date, this.checkIn, this.checkOut});

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      id: json['id'],
      userId: json['user_id'],
      date: json['date'],
      checkIn: json['check_in'],
      checkOut: json['check_out'],
    );
  }
}
