// lib/data/models/plant_model.dart

/// Model data untuk tanaman.
/// Gambar diakses via endpoint: GET /plants/{id}/image
class PlantModel {
  const PlantModel({
    this.id,
    required this.nama,
    this.gambar = '',
    this.pathGambar = '',
    required this.deskripsi,
    required this.manfaat,
    required this.efekSamping,
  });

  final String? id;
  final String nama;

  /// URL endpoint gambar: GET /plants/{id}/image
  final String gambar;

  /// Path relatif file di server
  final String pathGambar;

  final String deskripsi;
  final String manfaat;
  final String efekSamping;

  static const String _baseUrl =
      'https://pam-2026-p4-ifs23021-be.marshalll.fun:8080';

  factory PlantModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as String?;
    final pathGambar = json['pathGambar'] as String? ?? '';

    // Bangun URL gambar dari endpoint /plants/{id}/image
    String gambar = '';
    if (id != null && id.isNotEmpty && pathGambar.isNotEmpty) {
      gambar = '$_baseUrl/plants/$id/image';
    }

    return PlantModel(
      id: id,
      nama: json['nama'] as String? ?? '',
      gambar: gambar,
      pathGambar: pathGambar,
      deskripsi: json['deskripsi'] as String? ?? '',
      manfaat: json['manfaat'] as String? ?? '',
      efekSamping: json['efekSamping'] as String? ?? '',
    );
  }

  PlantModel copyWith({
    String? id,
    String? nama,
    String? gambar,
    String? pathGambar,
    String? deskripsi,
    String? manfaat,
    String? efekSamping,
  }) {
    return PlantModel(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      gambar: gambar ?? this.gambar,
      pathGambar: pathGambar ?? this.pathGambar,
      deskripsi: deskripsi ?? this.deskripsi,
      manfaat: manfaat ?? this.manfaat,
      efekSamping: efekSamping ?? this.efekSamping,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is PlantModel &&
              runtimeType == other.runtimeType &&
              id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'PlantModel(id: $id, nama: $nama)';
}