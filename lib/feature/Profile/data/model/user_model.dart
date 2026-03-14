// lib/feature/profile/data/model/user_model.dart
class UserModel {
  final String id;
  final String name;
  final String? phone;
  final String? email;
  final String? image;

  UserModel({
    required this.id,
    required this.name,
    this.phone,
    this.email,
    this.image,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'],
      email: json['email'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
    };
  }

  UserModel copyWith({
    String? name,
    String? phone,
    String? email,
    String? image,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      image: image ?? this.image,
    );
  }
}