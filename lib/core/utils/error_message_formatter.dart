class ErrorMessageFormatter {
  ErrorMessageFormatter._();

  static String format(String rawMessage) {
    final message = rawMessage.trim();
    final normalized = message.toLowerCase();

    if (normalized.isEmpty) {
      return 'Terjadi kesalahan pada server. Silakan coba lagi.';
    }

    if (normalized.contains("serializer for class 'dataresponse' is not found")) {
      return 'Server backend belum siap memproses data. Perbaiki konfigurasi serialisasi di backend lalu coba lagi.';
    }

    if (normalized.contains('relation "destinations" does not exist')) {
      return 'Database backend belum siap. Tabel destinations belum tersedia.';
    }

    if (normalized.contains('request diblokir browser') ||
        normalized.contains('cors') ||
        normalized.contains('ssl')) {
      return 'Koneksi ke backend ditolak browser. Periksa CORS dan sertifikat SSL backend.';
    }

    if (normalized.contains('failed to fetch') ||
        normalized.contains('socketexception') ||
        normalized.contains('tidak bisa terhubung')) {
      return 'Backend tidak bisa dihubungi. Pastikan server aktif dan URL API benar.';
    }

    if (normalized.contains('kode: 500') ||
        normalized.contains('internal server error')) {
      return 'Terjadi kesalahan pada server backend. Periksa log server untuk detailnya.';
    }

    return message;
  }
}
