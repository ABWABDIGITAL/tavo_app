class ApiConstants {
  ApiConstants._();
  
  static const String baseUrl = 'http://46.202.134.87:4321';
  static const String register = '/v1/api/auth/register';
  static const String login = '/v1/api/auth/login'; 
  static const String verifyOtp = '/v1/api/auth/verify-otp';
  static const String home = '/v1/api/home';
  static const String restaurants = '/v1/api/restaurant';
  static String restaurantDetails(String id) => '/v1/api/restaurant/$id';
   static String restaurantMenu(String id) => '/v1/api/restaurant/$id/menu';
}