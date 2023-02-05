class UserModel {
  UserModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.orderCount,
  });

  int? id;
  String? name;
  String? email;
  String? phone;
  int? orderCount;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['f_name'],
      email: json['email'],
      phone: json['phone'],
      orderCount: json['order_count'],
    );
  }
}
