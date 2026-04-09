// lib/features/wisata/wisata_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constants/route_constants.dart';
import '../../data/models/wisata_model.dart';
import '../../providers/wisata_provider.dart';
import '../../shared/widgets/error_widget.dart';
import '../../shared/widgets/loading_widget.dart';
import '../../shared/widgets/top_app_bar_widget.dart';

class WisataScreen extends StatefulWidget {
  const WisataScreen({super.key});

  @override
  State<WisataScreen> createState() => _WisataScreenState();
}

class _WisataScreenState extends State<WisataScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WisataProvider>().loadWisata();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WisataProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          appBar: TopAppBarWidget(
            title: 'Wisata Samosir',
            withSearch: true,
            searchQuery: provider.searchQuery,
            onSearchQueryChange: provider.updateSearchQuery,
          ),
          body: _buildBody(provider),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final added = await context.push<bool>(RouteConstants.wisataAdd);
              if (added == true && context.mounted) {
                provider.loadWisata();
              }
            },
            tooltip: 'Tambah Wisata',
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  Widget _buildBody(WisataProvider provider) {
    return switch (provider.status) {
      WisataStatus.loading || WisataStatus.initial => const LoadingWidget(),
      WisataStatus.error => AppErrorWidget(
        message: provider.errorMessage,
        onRetry: () => provider.loadWisata(),
      ),
      WisataStatus.success => _WisataBody(
        wisataList: provider.wisataList,
        onOpen: (wisata) => context.go(
          RouteConstants.wisataDetail(wisata.id!),
          extra: wisata,
        ),
      ),
    };
  }
}

class _WisataBody extends StatelessWidget {
  const _WisataBody({required this.wisataList, required this.onOpen});

  final List<WisataModel> wisataList;
  final ValueChanged<WisataModel> onOpen;

  @override
  Widget build(BuildContext context) {
    if (wisataList.isEmpty) {
      return Center(
        child: Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.explore_off_outlined,
                  size: 64,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 12),
                Text(
                  'Belum ada data wisata.',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => context.read<WisataProvider>().loadWisata(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: wisataList.length,
        itemBuilder: (context, index) {
          return _WisataItemCard(
            wisata: wisataList[index],
            onOpen: onOpen,
          );
        },
      ),
    );
  }
}

class _WisataItemCard extends StatelessWidget {
  const _WisataItemCard({required this.wisata, required this.onOpen});

  final WisataModel wisata;
  final ValueChanged<WisataModel> onOpen;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      color: colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => onOpen(wisata),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Gambar wisata
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  wisata.gambar,
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 70,
                    height: 70,
                    color: colorScheme.primaryContainer,
                    child: Icon(Icons.landscape, color: colorScheme.primary),
                  ),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return SizedBox(
                      width: 70,
                      height: 70,
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                              : null,
                          strokeWidth: 2,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      wisata.nama,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(Icons.location_on_outlined,
                            size: 13, color: colorScheme.primary),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            wisata.lokasi,
                            style: textTheme.labelSmall?.copyWith(
                              color: colorScheme.primary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      wisata.deskripsi,
                      style: textTheme.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        wisata.kategori,
                        style: textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSecondaryContainer,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
