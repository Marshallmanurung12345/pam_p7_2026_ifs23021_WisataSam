// lib/core/constants/api_constants.dart

class ApiConstants {
  ApiConstants._();

  static const String baseUrl =
      'https://pam-2026-p4-ifs23021-be.marshalll.fun:8080';

  // Plants
  static const String plants = '/plants';
  static String plantById(String id) => '/plants/$id';

  // Wisata — backend p4 punya alias /wisata → /destinations
  static const String wisata = '/wisata';
  static String wisataById(String id) => '/wisata/$id';
}