class UserModel {
  int? id;
  String? name;
  String? email;
  String? role;
  String? dateOfBirth;
  String? address;
  String? gender;
  String? phone;
  String? image;

  UserModel(
      {this.id,
      this.name,
      this.email,
      this.role,
      this.dateOfBirth,
      this.address,
      this.gender,
      this.phone,
      this.image});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      dateOfBirth: json['date_of_birth'],
      address: json['address'],
      gender: json['gender'],
      phone: json['phone'],
      image: json['image'],
    );
  }
}
