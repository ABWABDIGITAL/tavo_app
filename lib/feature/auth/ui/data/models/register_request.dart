class RegisterRequest {
  final String name;
  final String countryCode;
  final String phone;
  final String email;

  RegisterRequest({
    required this.name,
    required this.countryCode,
    required this.phone,
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'countryCode': countryCode,
      'phone': phone,
      'email': email,
    };
  }
}