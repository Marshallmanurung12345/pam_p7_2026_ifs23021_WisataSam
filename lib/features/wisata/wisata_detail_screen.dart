// lib/features/wisata/wisata_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants/route_constants.dart';
import '../../providers/wisata_provider.dart';
import '../../shared/widgets/error_widget.dart';
import '../../shared/widgets/loading_widget.dart';
import '../../shared/widgets/top_app_bar_widget.dart';
import '../../data/models/wisata_model.dart';

class WisataDetailScreen extends StatefulWidget {
  const WisataDetailScreen({
    super.key,
    required this.wisataId,
    this.initialWisata,
  });

  final String wisataId;
  final WisataModel? initialWisata;

  @override
  State<WisataDetailScreen> createState() => _WisataDetailScreenState();
}

class _WisataDetailScreenState extends State<WisataDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialWisata == null) {
        context.read<WisataProvider>().loadWisataById(widget.wisataId);
      }
    });
  }

  Future<void> _confirmDelete(
      BuildContext context, WisataProvider provider) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Wisata'),
        content: const Text('Apakah kamu yakin ingin menghapus data wisata ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final success = await provider.removeWisata(widget.wisataId);
      if (success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data wisata berhasil dihapus.')),
        );
        context.go(RouteConstants.wisata);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WisataProvider>(
      builder: (context, provider, _) {
        final wisata = provider.selectedWisata ?? widget.initialWisata;

        if (wisata == null &&
            (provider.status == WisataStatus.loading ||
                provider.status == WisataStatus.initial)) {
          return Scaffold(
            appBar: const TopAppBarWidget(
                title: 'Detail Wisata', showBackButton: true),
            body: const LoadingWidget(),
          );
        }

        if (wisata == null && provider.status == WisataStatus.error) {
          return Scaffold(
            appBar: const TopAppBarWidget(
                title: 'Detail Wisata', showBackButton: true),
            body: AppErrorWidget(
              message: provider.errorMessage,
              onRetry: () => provider.loadWisataById(widget.wisataId),
            ),
          );
        }

        if (wisata == null) {
          return Scaffold(
            appBar: const TopAppBarWidget(
                title: 'Detail Wisata', showBackButton: true),
            body: const Center(child: Text('Data tidak ditemukan.')),
          );
        }

        return Scaffold(
          appBar: TopAppBarWidget(
            title: wisata.nama,
            showBackButton: true,
            menuItems: [
              TopAppBarMenuItem(
                text: 'Edit',
                icon: Icons.edit_outlined,
                onTap: () async {
                  final edited = await context.push<bool>(
                    RouteConstants.wisataEdit(wisata.id!),
                    extra: wisata,
                  );
                  if (edited == true && context.mounted) {
                    provider.loadWisataById(widget.wisataId);
                  }
                },
              ),
              TopAppBarMenuItem(
                text: 'Hapus',
                icon: Icons.delete_outline,
                isDestructive: true,
                onTap: () => _confirmDelete(context, provider),
              ),
            ],
          ),
          body: _WisataDetailBody(wisata: wisata),
        );
      },
    );
  }
}

class _WisataDetailBody extends StatelessWidget {
  const _WisataDetailBody({required this.wisata});

  final WisataModel wisata;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            children: [
              Image.network(
                wisata.gambar,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 250,
                  color: colorScheme.primaryContainer,
                  child: Icon(Icons.landscape, size: 80,
                      color: colorScheme.primary),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: colorScheme.secondary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    wisata.kategori,
                    style: textTheme.labelMedium?.copyWith(
                      color: colorScheme.onSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  wisata.nama,
                  style: textTheme.headlineMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.location_on,
                        color: colorScheme.primary, size: 18),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        wisata.lokasi,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _InfoCard(title: 'Deskripsi', content: wisata.deskripsi,
                    icon: Icons.description_outlined),
                const SizedBox(height: 12),
                _InfoCard(title: 'Tips Kunjungan',
                    content: wisata.tipsKunjungan,
                    icon: Icons.tips_and_updates_outlined),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard(
      {required this.title, required this.content, required this.icon});

  final String title;
  final String content;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 4,
      color: colorScheme.surface,
      shape:
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const Divider(height: 16),
            Text(
              content,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(height: 1.6),
            ),
          ],
        ),
      ),
    );
  }
}
