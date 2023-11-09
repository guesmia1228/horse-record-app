class User_model{
  late String id,name,email,phone,address;

  User_model({required this.id, required this.name, required this.email, required this.phone, required this.address});

  factory User_model.fromJson(Map<dynamic, dynamic> json) {
    return User_model(
      id: json["id"],
      name: json["name"],
      email: json["email"],
      phone: json["phone"],
      address: json["address"],
    );
  }

  Map<dynamic, dynamic> toJson() {
    return {
      "id": this.id,
      "name": this.name,
      "email": this.email,
      "phone": this.phone,
      "address": this.address,
    };
  }

//
} 