class LoginRequest {
  final String countryCode;
  final String phone;

  LoginRequest({
    required this.countryCode,
    required this.phone,
  });

  Map<String, dynamic> toJson() {
    return {
      'countryCode': countryCode,
      'phone': phone,
    };
  }
}