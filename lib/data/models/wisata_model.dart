// lib/data/models/wisata_model.dart

import '../../core/constants/api_constants.dart';

/// Model data untuk Wisata Samosir.
/// Gambar diakses via endpoint: GET /wisata/{id}/image
class WisataModel {
  const WisataModel({
    this.id,
    required this.nama,
    this.gambar = '',
    this.pathGambar = '',
    required this.deskripsi,
    required this.lokasi,
    required this.kategori,
    required this.tipsKunjungan,
    this.slug = '',
    this.hargaTiket = 0,
    this.kontak,
  });

  final String? id;
  final String nama;

  /// URL endpoint gambar: GET /wisata/{id}/image
  final String gambar;

  /// Path relatif file di server (dari backend)
  final String pathGambar;

  final String deskripsi;
  final String lokasi;
  final String kategori;

  /// Disimpan di kolom jamBuka di backend
  final String tipsKunjungan;

  final String slug;
  final int hargaTiket;
  final String? kontak;

  factory WisataModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as String?;
    final pathGambar = json['pathGambar'] as String? ?? '';

    // Gunakan endpoint /wisata/{id}/image sebagai URL gambar
    // karena backend melayani gambar via route, bukan file statis
    String gambar = '';
    if (id != null && id.isNotEmpty && pathGambar.isNotEmpty) {
      gambar = '${ApiConstants.baseUrl}/wisata/$id/image';
    }

    return WisataModel(
      id: id,
      nama: json['nama'] as String? ?? '',
      gambar: gambar,
      pathGambar: pathGambar,
      deskripsi: json['deskripsi'] as String? ?? '',
      lokasi: json['lokasi'] as String? ?? '',
      kategori: json['kategori'] as String? ?? '',
      tipsKunjungan: json['jamBuka'] as String? ??
          json['tipsKunjungan'] as String? ??
          '',
      slug: json['slug'] as String? ?? '',
      hargaTiket: (json['hargaTiket'] as num?)?.toInt() ?? 0,
      kontak: json['kontak'] as String?,
    );
  }

  WisataModel copyWith({
    String? id,
    String? nama,
    String? gambar,
    String? pathGambar,
    String? deskripsi,
    String? lokasi,
    String? kategori,
    String? tipsKunjungan,
    String? slug,
    int? hargaTiket,
    String? kontak,
  }) {
    return WisataModel(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      gambar: gambar ?? this.gambar,
      pathGambar: pathGambar ?? this.pathGambar,
      deskripsi: deskripsi ?? this.deskripsi,
      lokasi: lokasi ?? this.lokasi,
      kategori: kategori ?? this.kategori,
      tipsKunjungan: tipsKunjungan ?? this.tipsKunjungan,
      slug: slug ?? this.slug,
      hargaTiket: hargaTiket ?? this.hargaTiket,
      kontak: kontak ?? this.kontak,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is WisataModel &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'WisataModel(id: $id, nama: $nama)';
}