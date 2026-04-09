// lib/data/services/wisata_repository.dart

import 'dart:io';
import 'dart:typed_data';
import '../models/wisata_model.dart';
import '../models/api_response_model.dart';
import 'wisata_service.dart';

class WisataRepository {
  WisataRepository({WisataService? service})
      : _service = service ?? WisataService();

  final WisataService _service;

  Future<ApiResponse<List<WisataModel>>> getWisata({String search = ''}) async {
    try {
      return await _service.getWisata(search: search);
    } catch (e) {
      return ApiResponse(success: false, message: 'Terjadi kesalahan jaringan: $e');
    }
  }

  Future<ApiResponse<WisataModel>> getWisataById(String id) async {
    try {
      return await _service.getWisataById(id);
    } catch (e) {
      return ApiResponse(success: false, message: 'Terjadi kesalahan jaringan: $e');
    }
  }

  Future<ApiResponse<String>> createWisata({
    required String nama,
    required String deskripsi,
    required String lokasi,
    required String kategori,
    required String tipsKunjungan,
    File? imageFile,
    Uint8List? imageBytes,
    String imageFilename = 'image.jpg',
  }) async {
    try {
      return await _service.createWisata(
        nama: nama,
        deskripsi: deskripsi,
        lokasi: lokasi,
        kategori: kategori,
        tipsKunjungan: tipsKunjungan,
        imageFile: imageFile,
        imageBytes: imageBytes,
        imageFilename: imageFilename,
      );
    } catch (e) {
      return ApiResponse(success: false, message: 'Terjadi kesalahan jaringan: $e');
    }
  }

  Future<ApiResponse<void>> updateWisata({
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
    try {
      return await _service.updateWisata(
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
    } catch (e) {
      return ApiResponse(success: false, message: 'Terjadi kesalahan jaringan: $e');
    }
  }

  Future<ApiResponse<void>> deleteWisata(String id) async {
    try {
      return await _service.deleteWisata(id);
    } catch (e) {
      return ApiResponse(success: false, message: 'Terjadi kesalahan jaringan: $e');
    }
  }
}
