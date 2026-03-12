class SendOtpRequest {
  final String countryCode;
  final String phone;

  SendOtpRequest({
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