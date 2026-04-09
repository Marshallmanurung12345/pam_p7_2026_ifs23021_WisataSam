// lib/data/services/wisata_service.dart

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import '../models/wisata_model.dart';
import '../models/api_response_model.dart';
import '../../core/constants/api_constants.dart';

class WisataService {
  WisataService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<ApiResponse<List<WisataModel>>> getWisata({String search = ''}) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.wisata}')
        .replace(queryParameters: search.isNotEmpty ? {'search': search} : null);

    try {
      final response = await _client.get(uri);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final dataMap = body['data'] as Map<String, dynamic>;
        final List<dynamic> jsonList = dataMap['wisata'] as List<dynamic>;
        final wisataList = jsonList
            .map((e) => WisataModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return ApiResponse(
          success: true,
          message: body['message'] as String? ?? 'Berhasil.',
          data: wisataList,
        );
      }

      return ApiResponse(success: false, message: _parseErrorMessage(response));
    } on http.ClientException catch (e) {
      return ApiResponse(success: false, message: _parseClientException(e));
    } on SocketException catch (e) {
      return ApiResponse(success: false, message: _parseSocketException(e));
    } on HandshakeException {
      return const ApiResponse(
        success: false,
        message: 'Koneksi HTTPS ditolak. Sertifikat SSL backend tidak valid atau belum dipercaya browser.',
      );
    }
  }

  Future<ApiResponse<WisataModel>> getWisataById(String id) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.wisataById(id)}');
    try {
      final response = await _client.get(uri);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final dataMap = body['data'] as Map<String, dynamic>;
        final wisata = WisataModel.fromJson(dataMap['wisata'] as Map<String, dynamic>);
        return ApiResponse(
          success: true,
          message: body['message'] as String? ?? 'Berhasil.',
          data: wisata,
        );
      }

      return ApiResponse(success: false, message: _parseErrorMessage(response));
    } on http.ClientException catch (e) {
      return ApiResponse(success: false, message: _parseClientException(e));
    } on SocketException catch (e) {
      return ApiResponse(success: false, message: _parseSocketException(e));
    } on HandshakeException {
      return const ApiResponse(
        success: false,
        message: 'Koneksi HTTPS ditolak. Sertifikat SSL backend tidak valid atau belum dipercaya browser.',
      );
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
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.wisata}');

    final request = http.MultipartRequest('POST', uri)
      ..fields['nama'] = nama
      ..fields['deskripsi'] = deskripsi
      ..fields['lokasi'] = lokasi
      ..fields['kategori'] = kategori
      ..fields['tipsKunjungan'] = tipsKunjungan;

    if (kIsWeb && imageBytes != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'file', imageBytes, filename: imageFilename,
      ));
    } else if (imageFile != null) {
      request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));
    }

    try {
      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);

      if (response.statusCode == 201 || response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        final dataMap = body['data'] as Map<String, dynamic>;
        return ApiResponse(
          success: true,
          message: body['message'] as String? ?? 'Wisata berhasil ditambahkan.',
          data: dataMap['wisataId'] as String,
        );
      }

      return ApiResponse(success: false, message: _parseErrorMessage(response));
    } on http.ClientException catch (e) {
      return ApiResponse(success: false, message: _parseClientException(e));
    } on SocketException catch (e) {
      return ApiResponse(success: false, message: _parseSocketException(e));
    } on HandshakeException {
      return const ApiResponse(
        success: false,
        message: 'Koneksi HTTPS ditolak. Sertifikat SSL backend tidak valid atau belum dipercaya browser.',
      );
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
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.wisataById(id)}');

    final request = http.MultipartRequest('PUT', uri)
      ..fields['nama'] = nama
      ..fields['deskripsi'] = deskripsi
      ..fields['lokasi'] = lokasi
      ..fields['kategori'] = kategori
      ..fields['tipsKunjungan'] = tipsKunjungan;

    if (kIsWeb && imageBytes != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'file', imageBytes, filename: imageFilename,
      ));
    } else if (imageFile != null) {
      request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));
    }

    try {
      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body) as Map<String, dynamic>;
        return ApiResponse(
          success: true,
          message: body['message'] as String? ?? 'Wisata berhasil diperbarui.',
        );
      }

      return ApiResponse(success: false, message: _parseErrorMessage(response));
    } on http.ClientException catch (e) {
      return ApiResponse(success: false, message: _parseClientException(e));
    } on SocketException catch (e) {
      return ApiResponse(success: false, message: _parseSocketException(e));
    } on HandshakeException {
      return const ApiResponse(
        success: false,
        message: 'Koneksi HTTPS ditolak. Sertifikat SSL backend tidak valid atau belum dipercaya browser.',
      );
    }
  }

  Future<ApiResponse<void>> deleteWisata(String id) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.wisataById(id)}');
    try {
      final response = await _client.delete(uri);

      if (response.statusCode == 200 || response.statusCode == 204) {
        return const ApiResponse(success: true, message: 'Wisata berhasil dihapus.');
      }

      return ApiResponse(success: false, message: _parseErrorMessage(response));
    } on http.ClientException catch (e) {
      return ApiResponse(success: false, message: _parseClientException(e));
    } on SocketException catch (e) {
      return ApiResponse(success: false, message: _parseSocketException(e));
    } on HandshakeException {
      return const ApiResponse(
        success: false,
        message: 'Koneksi HTTPS ditolak. Sertifikat SSL backend tidak valid atau belum dipercaya browser.',
      );
    }
  }

  String _parseErrorMessage(http.Response response) {
    try {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      return body['message'] as String? ?? 'Gagal. Kode: ${response.statusCode}';
    } catch (_) {
      return 'Gagal. Kode: ${response.statusCode}';
    }
  }

  String _parseClientException(http.ClientException error) {
    if (kIsWeb) {
      return 'Request diblokir browser atau backend tidak bisa dijangkau. Periksa CORS, SSL, dan status server.';
    }
    return 'Koneksi ke backend gagal: ${error.message}';
  }

  String _parseSocketException(SocketException error) {
    return 'Tidak bisa terhubung ke backend: ${error.message}';
  }

  void dispose() => _client.close();
}
