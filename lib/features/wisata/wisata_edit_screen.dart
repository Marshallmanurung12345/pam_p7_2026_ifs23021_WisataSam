// lib/features/wisata/wisata_edit_screen.dart

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../data/models/wisata_model.dart';
import '../../providers/wisata_provider.dart';
import '../../shared/widgets/top_app_bar_widget.dart';

class WisataEditScreen extends StatefulWidget {
  const WisataEditScreen({
    super.key,
    required this.wisataId,
    this.initialWisata,
  });

  final String wisataId;
  final WisataModel? initialWisata;

  @override
  State<WisataEditScreen> createState() => _WisataEditScreenState();
}

class _WisataEditScreenState extends State<WisataEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _lokasiController = TextEditingController();
  final _kategoriController = TextEditingController();
  final _tipsController = TextEditingController();

  File? _newImageFile;
  Uint8List? _newImageBytes;
  String _newImageFilename = 'image.jpg';
  bool _isLoading = false;
  bool _isInitialized = false;

  bool get _hasNewImage => _newImageBytes != null;

  final List<String> _kategoriList = [
    'Alam', 'Budaya', 'Pantai', 'Kuliner',
    'Danau', 'Petualangan', 'Sejarah', 'Religi',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialWisata != null) {
      _populateForm(widget.initialWisata!);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isInitialized && widget.initialWisata == null) {
        context.read<WisataProvider>().loadWisataById(widget.wisataId);
      }
    });
  }

  @override
  void dispose() {
    _namaController.dispose();
    _deskripsiController.dispose();
    _lokasiController.dispose();
    _kategoriController.dispose();
    _tipsController.dispose();
    super.dispose();
  }

  void _populateForm(WisataModel wisata) {
    if (_isInitialized) return;
    _namaController.text = wisata.nama;
    _deskripsiController.text = wisata.deskripsi;
    _lokasiController.text = wisata.lokasi;
    _kategoriController.text = wisata.kategori;
    _tipsController.text = wisata.tipsKunjungan;
    _isInitialized = true;
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
        source: source, imageQuality: 80, maxWidth: 1024);
    if (picked == null) return;
    final bytes = await picked.readAsBytes();
    setState(() {
      _newImageBytes = bytes;
      _newImageFilename = picked.name;
      _newImageFile = kIsWeb ? null : File(picked.path);
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

  Future<void> _submit(WisataModel original) async {
    if (!_formKey.currentState!.validate()) return;
    if (kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Simpan perubahan dari Flutter Web masih diblokir backend karena CORS untuk method PUT. Jalankan dari Android emulator/perangkat atau perbaiki backend.',
          ),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final success = await context.read<WisataProvider>().editWisata(
      id: original.id!,
      nama: _namaController.text.trim(),
      deskripsi: _deskripsiController.text.trim(),
      lokasi: _lokasiController.text.trim(),
      kategori: _kategoriController.text.trim(),
      tipsKunjungan: _tipsController.text.trim(),
      imageFile: _newImageFile,
      imageBytes: _newImageBytes,
      imageFilename: _newImageFilename,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Wisata berhasil diperbarui.')),
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

    return Consumer<WisataProvider>(
      builder: (context, provider, _) {
        final wisata = provider.selectedWisata ?? widget.initialWisata;
        if (wisata != null) _populateForm(wisata);

        return Scaffold(
          appBar: const TopAppBarWidget(
              title: 'Edit Wisata', showBackButton: true),
          body: wisata == null
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
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
                        border:
                        Border.all(color: colorScheme.outline),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            _hasNewImage
                                ? Image.memory(_newImageBytes!,
                                fit: BoxFit.cover)
                                : Image.network(wisata.gambar,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (_, __, ___) => Icon(
                                  Icons.landscape,
                                  size: 48,
                                  color: colorScheme.primary,
                                )),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                color: Colors.black45,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 6),
                                child: const Text(
                                  'Ketuk untuk ganti foto (opsional)',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildField(
                    controller: _namaController,
                    label: 'Nama Wisata',
                    icon: Icons.landscape_outlined,
                  ),
                  const SizedBox(height: 16),
                  _buildField(
                    controller: _deskripsiController,
                    label: 'Deskripsi',
                    icon: Icons.description_outlined,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  _buildField(
                    controller: _lokasiController,
                    label: 'Lokasi',
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
                          prefixIcon:
                          const Icon(Icons.category_outlined),
                          suffixIcon:
                          const Icon(Icons.arrow_drop_down),
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty) {
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
                    icon: Icons.tips_and_updates_outlined,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: _isLoading
                        ? null
                        : () => _submit(wisata),
                    icon: _isLoading
                        ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2))
                        : const Icon(Icons.save_outlined),
                    label: Text(_isLoading
                        ? 'Menyimpan...'
                        : 'Simpan Perubahan'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
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
