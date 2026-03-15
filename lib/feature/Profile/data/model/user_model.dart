// lib/feature/Profile/data/model/user_model.dart
class UserModel {
  final String id;
  final String name;
  final String? phone;
  final String? email;
  final String? image;

  const UserModel({
    required this.id,
    required this.name,
    this.phone,
    this.email,
    this.image,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    String? imageUrl;
    if (json['avatar'] is Map<String, dynamic>) {
      imageUrl = json['avatar']['url']?.toString();
    } else if (json['image'] != null) {
      imageUrl = json['image']?.toString();
    }

    return UserModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      phone: json['phone']?.toString(),
      email: json['email']?.toString(),
      image: imageUrl,
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
    String? id,
    String? name,
    String? phone,
    String? email,
    String? image,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      image: image ?? this.image,
    );
  }
}
