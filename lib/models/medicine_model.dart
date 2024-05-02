class MedicineModel {
  int? id;
  String? code;
  String? name;
  int? stock;
  String? expiryDate;

  MedicineModel({this.id, this.code, this.name, this.stock, this.expiryDate});

  factory MedicineModel.fromJson(Map<String, dynamic> json) {
    return MedicineModel(
      id: json['id'],
      code: json['code'],
      name: json['name'],
      stock: json['stock'],
      expiryDate: json['expiry_date'],
    );
  }
}
