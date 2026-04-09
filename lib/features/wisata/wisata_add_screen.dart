// lib/features/wisata/wisata_add_screen.dart

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../providers/wisata_provider.dart';
import '../../shared/widgets/top_app_bar_widget.dart';

class WisataAddScreen extends StatefulWidget {
  const WisataAddScreen({super.key});

  @override
  State<WisataAddScreen> createState() => _WisataAddScreenState();
}

class _WisataAddScreenState extends State<WisataAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _lokasiController = TextEditingController();
  final _kategoriController = TextEditingController();
  final _tipsController = TextEditingController();

  File? _imageFile;
  Uint8List? _imageBytes;
  String _imageFilename = 'image.jpg';
  bool _isLoading = false;

  bool get _hasImage => _imageBytes != null;

  final List<String> _kategoriList = [
    'Alam', 'Budaya', 'Pantai', 'Kuliner',
    'Danau', 'Petualangan', 'Sejarah', 'Religi',
  ];

  @override
  void dispose() {
    _namaController.dispose();
    _deskripsiController.dispose();
    _lokasiController.dispose();
    _kategoriController.dispose();
    _tipsController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
        source: source, imageQuality: 80, maxWidth: 1024);
    if (picked == null) return;
    final bytes = await picked.readAsBytes();
    setState(() {
      _imageBytes = bytes;
      _imageFilename = picked.name;
      _imageFile = kIsWeb ? null : File(picked.path);
    });
  }

  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Pilih dari Galeri'),
              onTap: () {
                Navigator.pop(ctx);
                _pickImage(ImageSource.gallery);
              },
            ),
            if (!kIsWeb)
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: const Text('Ambil Foto'),
                onTap: () {
                  Navigator.pop(ctx);
                  _pickImage(ImageSource.camera);
                },
              ),
          ],
        ),
      ),
    );
  }

  void _showKategoriPicker() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text('Pilih Kategori',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
            ),
            ..._kategoriList.map((k) => ListTile(
              title: Text(k),
              trailing: _kategoriController.text == k
                  ? Icon(Icons.check,
                  color: Theme.of(context).colorScheme.primary)
                  : null,
              onTap: () {
                setState(() => _kategoriController.text = k);
                Navigator.pop(ctx);
              },
            )),
          ],
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_hasImage) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih foto wisata terlebih dahulu.')),
      );
      return;
    }
    setState(() => _isLoading = true);

    final success = await context.read<WisataProvider>().addWisata(
      nama: _namaController.text.trim(),
      deskripsi: _deskripsiController.text.trim(),
      lokasi: _lokasiController.text.trim(),
      kategori: _kategoriController.text.trim(),
      tipsKunjungan: _tipsController.text.trim(),
      imageFile: _imageFile,
      imageBytes: _imageBytes,
      imageFilename: _imageFilename,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Wisata berhasil ditambahkan.')),
      );
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.read<WisataProvider>().errorMessage),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: const TopAppBarWidget(
          title: 'Tambah Wisata', showBackButton: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: _showImageSourceSheet,
                child: Container(
                  height: 180,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: colorScheme.outline),
                  ),
                  child: _hasImage
                      ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.memory(_imageBytes!,
                        fit: BoxFit.cover,
                        width: double.infinity),
                  )
                      : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_photo_alternate_outlined,
                          size: 48, color: colorScheme.primary),
                      const SizedBox(height: 8),
                      Text('Ketuk untuk memilih foto wisata *',
                          style:
                          TextStyle(color: colorScheme.primary)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildField(
                controller: _namaController,
                label: 'Nama Wisata',
                hint: 'Contoh: Pantai Pasir Putih Parbaba',
                icon: Icons.landscape_outlined,
              ),
              const SizedBox(height: 16),
              _buildField(
                controller: _deskripsiController,
                label: 'Deskripsi',
                hint: 'Deskripsikan destinasi wisata ini...',
                icon: Icons.description_outlined,
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              _buildField(
                controller: _lokasiController,
                label: 'Lokasi',
                hint: 'Contoh: Kecamatan Pangururan, Samosir',
                icon: Icons.location_on_outlined,
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: _showKategoriPicker,
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _kategoriController,
                    decoration: InputDecoration(
                      labelText: 'Kategori',
                      hintText: 'Pilih kategori wisata',
                      prefixIcon: const Icon(Icons.category_outlined),
                      suffixIcon: const Icon(Icons.arrow_drop_down),
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Kategori tidak boleh kosong.';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildField(
                controller: _tipsController,
                label: 'Tips Kunjungan',
                hint: 'Tuliskan tips untuk pengunjung...',
                icon: Icons.tips_and_updates_outlined,
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _isLoading ? null : _submit,
                icon: _isLoading
                    ? const SizedBox(
                    width: 20, height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.save_outlined),
                label: Text(_isLoading ? 'Menyimpan...' : 'Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '$label tidak boleh kosong.';
        }
        return null;
      },
    );
  }
}
