class SignUpModel {
  SignUpModel({
    required this.name,
    required this.phone,
    required this.email,
    required this.password,
  });
  String name;
  String phone;
  String email;
  String password;

  //Convert the Object to json so we can store
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    //f_name means first name
    data['f_name'] = name;
    data['phone'] = phone;
    data['email'] = email;
    data['password'] = password;
    return data;
  }
}
