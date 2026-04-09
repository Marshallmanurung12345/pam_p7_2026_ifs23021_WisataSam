import '../models/plant_model.dart';

class MockPlantData {
  MockPlantData._();

  static const List<PlantModel> items = [
    PlantModel(
      id: 'mock-lidah-buaya',
      nama: 'Lidah Buaya',
      deskripsi:
          'Tanaman sukulen yang umum dimanfaatkan untuk perawatan kulit dan mudah dibudidayakan di iklim tropis.',
      manfaat:
          'Membantu melembapkan kulit, menenangkan iritasi ringan, dan sering dipakai sebagai bahan perawatan rambut.',
      efekSamping:
          'Penggunaan berlebihan pada kulit sensitif bisa memicu iritasi; konsumsi oral tanpa pengawasan tidak disarankan.',
    ),
    PlantModel(
      id: 'mock-jahe',
      nama: 'Jahe',
      deskripsi:
          'Rimpang herbal populer dengan aroma khas yang sering digunakan untuk minuman hangat dan olahan tradisional.',
      manfaat:
          'Dapat membantu meredakan mual, menghangatkan tubuh, dan mendukung kenyamanan pencernaan.',
      efekSamping:
          'Konsumsi berlebihan dapat menyebabkan perut tidak nyaman pada sebagian orang.',
    ),
    PlantModel(
      id: 'mock-kunyit',
      nama: 'Kunyit',
      deskripsi:
          'Tanaman rimpang berwarna kuning oranye yang banyak digunakan sebagai bumbu dan bahan jamu.',
      manfaat:
          'Sering dimanfaatkan untuk membantu menjaga daya tahan tubuh dan mendukung respons antiinflamasi alami.',
      efekSamping:
          'Pemakaian berlebihan bisa memicu gangguan lambung pada orang yang sensitif.',
    ),
  ];

  static PlantModel? findById(String id) {
    for (final item in items) {
      if (item.id == id) {
        return item;
      }
    }
    return null;
  }
}
