import 'package:galaxy_satwa/models/pet_model.dart';
import 'package:galaxy_satwa/models/user_model.dart';

class MedicalRecordModel {
  int? id;
  int? patientId;
  int? doctorId;
  int? petId;
  UserModel? doctor;
  PetModel? pet;
  String? date;
  String? symptom;
  String? diagnosis;
  String? action;
  String? recipe;

  MedicalRecordModel(
      {this.id,
      this.patientId,
      this.doctorId,
      this.petId,
      this.doctor,
      this.pet,
      this.date,
      this.symptom,
      this.diagnosis,
      this.action,
      this.recipe});

  factory MedicalRecordModel.fromJson(Map<String, dynamic> json) {
    return MedicalRecordModel(
      id: json['id'],
      patientId: json['patient_id'],
      doctorId: json['doctor_id'],
      petId: json['pet_id'],
      doctor: UserModel(
        name: json['doctor']['name'],
      ),
      pet: PetModel(
        name: json['pet']['name'],
        type: json['pet']['type'],
        image: json['pet']['image'],
      ),
      date: json['date'],
      symptom: json['symptom'],
      diagnosis: json['diagnosis'],
      action: json['action'],
      recipe: json['recipe'],
    );
  }
}
