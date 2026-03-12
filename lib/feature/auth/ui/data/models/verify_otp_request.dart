class VerifyOtpRequest {
  final String countryCode;
  final String phone;
  final String otp;

  VerifyOtpRequest({
    required this.countryCode,
    required this.phone,
    required this.otp,
  });

  Map<String, dynamic> toJson() {
    return {
      'countryCode': countryCode,
      'phone': phone,
      'otp': otp,
    };
  }
}