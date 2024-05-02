import 'package:galaxy_satwa/models/user_model.dart';

class PetModel {
  int? id;
  int? userId;
  String? name;
  String? category;
  String? type;
  String? old;
  String? color;
  String? gender;
  String? tatto;
  String? image;
  UserModel? user;

  PetModel(
      {this.id,
      this.userId,
      this.name,
      this.category,
      this.type,
      this.old,
      this.color,
      this.gender,
      this.tatto,
      this.image,
      this.user});

  factory PetModel.fromJson(Map<String, dynamic> json) {
    return PetModel(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      category: json['category'],
      type: json['type'],
      old: json['old'],
      color: json['color'],
      gender: json['gender'],
      tatto: json['tatto'],
      image: json['image'],
      user: json['user'] != null
          ? UserModel(
              name: json['user']['name'],
              address: json['user']['address'],
              phone: json['user']['phone'],
            )
          : null,
    );
  }
}

class PetCountModel {
  int? kucing;
  int? anjing;
  int? kelinci;
  int? burung;
  int? ular;
  int? hamster;
  PetCountModel({
    this.kucing,
    this.anjing,
    this.kelinci,
    this.burung,
    this.ular,
    this.hamster,
  });

  factory PetCountModel.fromJson(Map<String, dynamic> json) {
    return PetCountModel(
      kucing: json['kucing'],
      anjing: json['anjing'],
      kelinci: json['kelinci'],
      burung: json['burung'],
      ular: json['ular'],
      hamster: json['hamster'],
    );
  }
}
