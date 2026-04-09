// lib/providers/wisata_provider.dart

import 'dart:io';
import 'package:flutter/foundation.dart';
import '../data/models/wisata_model.dart';
import '../data/services/wisata_repository.dart';

enum WisataStatus { initial, loading, success, error }

class WisataProvider extends ChangeNotifier {
  WisataProvider({WisataRepository? repository})
      : _repository = repository ?? WisataRepository();

  final WisataRepository _repository;

  WisataStatus _status = WisataStatus.initial;
  List<WisataModel> _wisataList = [];
  WisataModel? _selectedWisata;
  String _errorMessage = '';
  String _searchQuery = '';

  WisataStatus get status => _status;
  WisataModel? get selectedWisata => _selectedWisata;
  String get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;

  List<WisataModel> get wisataList {
    if (_searchQuery.isEmpty) return List.unmodifiable(_wisataList);
    return _wisataList
        .where((w) =>
    w.nama.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        w.lokasi.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        w.kategori.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  Future<void> loadWisata() async {
    _setStatus(WisataStatus.loading);
    final result = await _repository.getWisata();
    if (result.success && result.data != null) {
      _wisataList = List<WisataModel>.from(result.data!);
      _setStatus(WisataStatus.success);
    } else {
      _errorMessage = result.message;
      _setStatus(WisataStatus.error);
    }
  }

  Future<void> loadWisataById(String id) async {
    _setStatus(WisataStatus.loading);
    final result = await _repository.getWisataById(id);
    if (result.success && result.data != null) {
      _selectedWisata = result.data;
      _setStatus(WisataStatus.success);
    } else {
      _errorMessage = result.message;
      _setStatus(WisataStatus.error);
    }
  }

  Future<bool> addWisata({
    required String nama,
    required String deskripsi,
    required String lokasi,
    required String kategori,
    required String tipsKunjungan,
    File? imageFile,
    Uint8List? imageBytes,
    String imageFilename = 'image.jpg',
  }) async {
    _setStatus(WisataStatus.loading);
    final result = await _repository.createWisata(
      nama: nama,
      deskripsi: deskripsi,
      lokasi: lokasi,
      kategori: kategori,
      tipsKunjungan: tipsKunjungan,
      imageFile: imageFile,
      imageBytes: imageBytes,
      imageFilename: imageFilename,
    );
    if (result.success) {
      await loadWisata();
      return true;
    }
    _errorMessage = result.message;
    _setStatus(WisataStatus.error);
    return false;
  }

  Future<bool> editWisata({
    required String id,
    required String nama,
    required String deskripsi,
    required String lokasi,
    required String kategori,
    required String tipsKunjungan,
    File? imageFile,
    Uint8List? imageBytes,
    String imageFilename = 'image.jpg',
  }) async {
    _setStatus(WisataStatus.loading);
    final result = await _repository.updateWisata(
      id: id,
      nama: nama,
      deskripsi: deskripsi,
      lokasi: lokasi,
      kategori: kategori,
      tipsKunjungan: tipsKunjungan,
      imageFile: imageFile,
      imageBytes: imageBytes,
      imageFilename: imageFilename,
    );
    if (result.success) {
      await loadWisataById(id);
      return true;
    }
    _errorMessage = result.message;
    _setStatus(WisataStatus.error);
    return false;
  }

  Future<bool> removeWisata(String id) async {
    _setStatus(WisataStatus.loading);
    final result = await _repository.deleteWisata(id);
    if (result.success) {
      _wisataList.removeWhere((w) => w.id == id);
      _setStatus(WisataStatus.success);
      return true;
    }
    _errorMessage = result.message;
    _setStatus(WisataStatus.error);
    return false;
  }

  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearSelectedWisata() {
    _selectedWisata = null;
    notifyListeners();
  }

  void _setStatus(WisataStatus status) {
    _status = status;
    notifyListeners();
  }
}
