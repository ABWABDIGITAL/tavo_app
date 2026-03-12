class AuthResponse {
  final bool success;
  final String? message;
  final String? token;
  final UserData? user;

  AuthResponse({
    required this.success,
    this.message,
    this.token,
    this.user,
  });

  factory AuthResponse.fromJson(dynamic json) {
    if (json is String) {
      return AuthResponse(
        success: false,
        message: json,
      );
    }
    
    if (json is! Map<String, dynamic>) {
      return AuthResponse(
        success: false,
        message: 'Invalid response format',
      );
    }

    return AuthResponse(
      success: json['success'] ?? json['status'] == true || json['status'] == 'success',
      message: json['message']?.toString(),
      token: json['token']?.toString() ?? json['data']?['token']?.toString(),
      user: json['user'] != null 
          ? UserData.fromJson(json['user']) 
          : json['data']?['user'] != null 
              ? UserData.fromJson(json['data']['user'])
              : null,
    );
  }
}

class UserData {
  final String? id;
  final String? name;
  final String? phone;
  final String? email;
  final String? countryCode;

  UserData({
    this.id,
    this.name,
    this.phone,
    this.email,
    this.countryCode,
  });

  factory UserData.fromJson(dynamic json) {
    if (json is! Map<String, dynamic>) {
      return UserData();
    }
    
    return UserData(
      id: json['id']?.toString() ?? json['_id']?.toString(),
      name: json['name']?.toString(),
      phone: json['phone']?.toString(),
      email: json['email']?.toString(),
      countryCode: json['countryCode']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'countryCode': countryCode,
    };
  }
}