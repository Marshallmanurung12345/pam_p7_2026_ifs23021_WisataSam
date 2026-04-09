// lib/core/constants/api_constants.dart

/// Konstanta untuk konfigurasi API
class ApiConstants {
  ApiConstants._();

  /// Base URL API backend (Plants + Wisata Samosir)
  /// Ganti ke localhost jika testing lokal:
  /// static const String baseUrl = 'http://localhost:8000';
  static const String baseUrl =
      'https://pam-2026-p4-ifs23021-be.marshalll.fun:8080';

  // ── Plants ──
  static const String plants = '/plants';
  static String plantById(String id) => '/plants/$id';

  // ── Wisata Samosir ──
  // Backend menyediakan alias /wisata → /destinations
  static const String wisata = '/wisata';
  static String wisataById(String id) => '/wisata/$id';
}
