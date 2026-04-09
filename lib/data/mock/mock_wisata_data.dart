import '../models/wisata_model.dart';

class MockWisataData {
  MockWisataData._();

  static const List<WisataModel> items = [
    WisataModel(
      id: 'mock-tomok',
      nama: 'Desa Wisata Tomok',
      deskripsi:
          'Destinasi budaya di tepi Danau Toba yang dikenal dengan rumah adat Batak, pertunjukan seni, dan pusat suvenir.',
      lokasi: 'Tomok, Samosir',
      kategori: 'Budaya',
      tipsKunjungan:
          'Datang pagi atau sore agar lebih nyaman berjalan kaki dan sempat melihat pertunjukan budaya lokal.',
    ),
    WisataModel(
      id: 'mock-siallagan',
      nama: 'Huta Siallagan',
      deskripsi:
          'Kompleks desa batu bersejarah dengan kursi persidangan raja dan penjelasan adat Batak yang masih terjaga.',
      lokasi: 'Ambarita, Samosir',
      kategori: 'Sejarah',
      tipsKunjungan:
          'Gunakan pemandu lokal supaya penjelasan sejarah situs lebih jelas dan konteks budayanya tidak terlewat.',
    ),
    WisataModel(
      id: 'mock-pasir-putih',
      nama: 'Pantai Pasir Putih Parbaba',
      deskripsi:
          'Pantai air tawar populer dengan hamparan pasir putih, cocok untuk santai, berenang, dan menikmati panorama danau.',
      lokasi: 'Parbaba, Samosir',
      kategori: 'Alam',
      tipsKunjungan:
          'Bawa pakaian ganti dan hindari jam siang terik jika ingin menikmati pantai lebih lama.',
    ),
  ];

  static WisataModel? findById(String id) {
    for (final item in items) {
      if (item.id == id) {
        return item;
      }
    }
    return null;
  }
}
