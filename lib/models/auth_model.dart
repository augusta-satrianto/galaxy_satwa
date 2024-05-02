class AuthModel {
  int id;
  String name;
  String role;
  String token;
  String image;
  String? emailVerifiedAt;

  AuthModel({
    required this.id,
    required this.name,
    required this.role,
    required this.token,
    required this.image,
    this.emailVerifiedAt,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
        id: json['user']['id'],
        name: json['user']['name'],
        role: json['user']['role'],
        image: json['user']['image'],
        token: json['token'],
        emailVerifiedAt: json['user']['email_verified_at']);
  }
}
