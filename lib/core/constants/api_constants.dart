// lib/core/constants/api_constants.dart

/// Konstanta untuk konfigurasi API
class ApiConstants {
  ApiConstants._();

  /// Base URL API backend (Plants + Wisata Samosir)
  static const String baseUrl =
      'https://pam-2026-p7-ifs23021.marshalll.fun:8080';

  // ── Plants (tetap dipertahankan) ──
  static const String plants = '/plants';
  static String plantById(String id) => '/plants/$id';

  // ── Wisata Samosir (baru) ──
  static const String wisata = '/wisata';
  static String wisataById(String id) => '/wisata/$id';
}
