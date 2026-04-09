// lib/data/models/wisata_model.dart

/// Model data untuk Wisata Samosir
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
  });

  final String? id;
  final String nama;
  final String gambar;
  final String pathGambar;
  final String deskripsi;
  final String lokasi;
  final String kategori;
  final String tipsKunjungan;

  factory WisataModel.fromJson(Map<String, dynamic> json) {
    return WisataModel(
      id: json['id'] as String?,
      nama: json['nama'] as String? ?? '',
      gambar: json['gambar'] as String? ?? '',
      pathGambar: json['pathGambar'] as String? ?? '',
      deskripsi: json['deskripsi'] as String? ?? '',
      lokasi: json['lokasi'] as String? ?? '',
      kategori: json['kategori'] as String? ?? '',
      tipsKunjungan: json['tipsKunjungan'] as String? ?? '',
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
