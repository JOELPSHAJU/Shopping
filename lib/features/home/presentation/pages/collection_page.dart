import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/home_providers.dart';
import '../../../product/domain/product.dart';

class CollectionPage extends ConsumerWidget {
  final String collectionId;

  const CollectionPage({super.key, required this.collectionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(collectionProductsProvider(collectionId));
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = Theme.of(context).scaffoldBackgroundColor;
    final fg = isDark ? Colors.white : Colors.black;
    final fgMuted = isDark ? AppColors.textBody : AppColors.lightTextBody;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800;

    return Scaffold(
      backgroundColor: bg,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeader(context, fg, bg, isDesktop),

            // Collection Title
            _buildConstrainedSection(
              paddingVertical: 60,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   _sectionLabel(context, 'EXCURSIVE COLLECTION'),
                  const SizedBox(height: 16),
                  Text(
                    collectionId.replaceAll('-', ' ').toUpperCase(),
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: isDesktop ? 64 : 40,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),

            // Product Grid
            _buildConstrainedSection(
              paddingVertical: 40,
              child: products.isEmpty
                  ? Center(
                      child: Text(
                        'COLLECTION IS EMPTY',
                        style: TextStyle(
                          color: fgMuted,
                          letterSpacing: 4,
                          fontSize: 12,
                        ),
                      ),
                    )
                  : GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isDesktop ? 3 : 1,
                        childAspectRatio: 0.65,
                        crossAxisSpacing: 40,
                        mainAxisSpacing: 60,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return _buildProductCard(context, ref, product);
                      },
                    ),
            ),

            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Color fg, Color bg, bool isDesktop) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: Icon(Icons.arrow_back_ios_new, size: 20, color: fg),
          ),
          Text(
            'F A T H A S H',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              fontSize: 24,
              letterSpacing: 8,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(width: 48), // Spacer for centering
        ],
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, WidgetRef ref, Product product) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fg = isDark ? Colors.white : Colors.black;
    final fgMuted = isDark ? AppColors.textBody : AppColors.lightTextBody;
    final cardBg = isDark ? AppColors.cardDark : AppColors.lightCard;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => context.push('/product/${product.id}'),
            child: Container(
              width: double.infinity,
              color: cardBg,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (product.imageAsset != null)
                    Image.asset(product.imageAsset!, fit: BoxFit.cover),
                  Positioned(
                    top: 20,
                    left: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      color: (isDark ? Colors.black : Colors.white).withValues(
                        alpha: 0.7,
                      ),
                      child: Text(
                        product.brand,
                        style: TextStyle(
                          color: fg,
                          fontSize: 10,
                          letterSpacing: 3,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          product.brand.toUpperCase(),
          style: TextStyle(
            color: fgMuted,
            fontSize: 10,
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          product.name,
          style: TextStyle(
            color: fg,
            fontSize: 16,
            letterSpacing: 1,
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          '\$${product.price.toStringAsFixed(0)}',
          style: TextStyle(
            color: fg,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildConstrainedSection({
    required Widget child,
    required double paddingVertical,
    Color? backgroundColor,
  }) {
    return Container(
      width: double.infinity,
      color: backgroundColor ?? Colors.transparent,
      padding: EdgeInsets.symmetric(vertical: paddingVertical),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: child,
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(BuildContext context, String text) {
    return Row(
      children: [
        Container(width: 20, height: 0.5, color: AppColors.accent),
        const SizedBox(width: 12),
        Text(
          text,
          style: const TextStyle(
            color: AppColors.accent,
            fontSize: 10,
            letterSpacing: 4,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
