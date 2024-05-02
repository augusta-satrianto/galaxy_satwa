import 'package:galaxy_satwa/models/pet_model.dart';
import 'package:galaxy_satwa/models/user_model.dart';

class AppointmentModel {
  int? id;
  UserModel? patient;
  UserModel? doctor;
  PetModel? pet;
  String? date;
  String? time;
  String? status;

  AppointmentModel({
    this.id,
    this.patient,
    this.doctor,
    this.pet,
    this.date,
    this.time,
    this.status,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'],
      patient: UserModel(
        name: json['patient']['name'],
      ),
      doctor: UserModel(
        name: json['doctor']['name'],
      ),
      pet: PetModel(
        name: json['pet']['name'],
        type: json['pet']['type'],
        image: json['pet']['image'],
      ),
      date: json['date'],
      time: json['time'],
      status: json['status'],
    );
  }
}
