class CorrespondenceModel {
  int? id;
  String? doctorId;
  String? patientId;
  String? category;
  String? file;
  String? replyFile;
  DateTime? updatedAt;
  DateTime? createdAt;
  CorrespondenceModel({
    this.id,
    this.doctorId,
    this.patientId,
    this.category,
    this.file,
    this.replyFile,
    this.createdAt,
    this.updatedAt,
  });

  factory CorrespondenceModel.fromJson(Map<String, dynamic> json) {
    return CorrespondenceModel(
      id: json['id'],
      doctorId: json['doctor_id'],
      patientId: json['patient_id'],
      category: json['category'],
      file: json['file'],
      replyFile: json['reply_file'],
      updatedAt: DateTime.parse(json['updated_at']),
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
