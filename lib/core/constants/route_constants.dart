// lib/core/constants/route_constants.dart

class RouteConstants {
  RouteConstants._();

  static const String home = '/';

  // ── Plants (tetap dipertahankan) ──
  static const String plants = '/plants';
  static const String plantsAdd = '/plants/add';
  static String plantsDetail(String id) => '/plants/$id';
  static String plantsEdit(String id) => '/plants/$id/edit';

  // ── Wisata Samosir (baru) ──
  static const String wisata = '/wisata';
  static const String wisataAdd = '/wisata/add';
  static String wisataDetail(String id) => '/wisata/$id';
  static String wisataEdit(String id) => '/wisata/$id/edit';

  static const String profile = '/profile';
}
