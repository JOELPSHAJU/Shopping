import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../home/presentation/providers/home_providers.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../../product/domain/product.dart';
import 'package:go_router/go_router.dart';

class FavouritesPage extends ConsumerWidget {
  const FavouritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.background : const Color(0xFFF8F5F0);
    final cardBg = isDark ? AppColors.cardDark : const Color(0xFFE8E3DC);
    final fg = isDark ? AppColors.white : const Color(0xFF1A1A1A);
    final fgMuted = isDark ? AppColors.textBody : const Color(0xFF888480);
    final borderColor = isDark ? AppColors.cardLight : const Color(0xFFDDD8D0);

    final favorites = ref.watch(favoritesProvider);
    final favoriteProducts = mockProducts
        .where((p) => favorites.contains(p.id))
        .toList();

    return Scaffold(
      backgroundColor: bg,
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 56),

                  // Label
                  Row(
                    children: [
                      Container(
                        width: 16,
                        height: 0.5,
                        color: AppColors.accent,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'WISHLIST',
                        style: TextStyle(
                          color: AppColors.accent,
                          fontSize: 11,
                          letterSpacing: 6,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Title
                  Text(
                    'Favourites',
                    style: TextStyle(
                      color: fg,
                      fontSize: 56,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${favoriteProducts.length} COLLECTED PIECES',
                    style: TextStyle(
                      color: fgMuted,
                      fontSize: 11,
                      letterSpacing: 4,
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.only(top: 24, bottom: 48),
                    height: 0.5,
                    color: borderColor,
                  ),

                  // 3-column grid — 1:1.5 ratio
                  favoriteProducts.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(120),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(
                                  CupertinoIcons.heart,
                                  size: 48,
                                  color: fgMuted,
                                ),
                                const SizedBox(height: 24),
                                Text(
                                  'YOUR WISHLIST IS EMPTY',
                                  style: TextStyle(
                                    color: fgMuted,
                                    letterSpacing: 4,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : LayoutBuilder(
                          builder: (context, constraints) {
                            final crossCount = constraints.maxWidth > 700
                                ? 3
                                : constraints.maxWidth > 450
                                ? 2
                                : 1;
                            final itemWidth =
                                (constraints.maxWidth - (crossCount - 1) * 24) /
                                crossCount;
                            final itemHeight = itemWidth * 1.5;

                            return Wrap(
                              spacing: 24,
                              runSpacing: 40,
                              children: favoriteProducts.map((product) {
                                return SizedBox(
                                  width: itemWidth,
                                  child: _buildCard(
                                    context,
                                    ref,
                                    product,
                                    itemHeight,
                                    fg,
                                    fgMuted,
                                    borderColor,
                                    cardBg,
                                    isDark,
                                  ),
                                );
                              }).toList(),
                            );
                          },
                        ),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard(
    BuildContext context,
    WidgetRef ref,
    Product product,
    double height,
    Color fg,
    Color fgMuted,
    Color borderColor,
    Color cardBg,
    bool isDark,
  ) {
    // This is identical to the one on BrandPage - ideally should be a common widget, but we'll stick to consistency for now.
    final favorites = ref.watch(favoritesProvider);
    final isFav = favorites.contains(product.id);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => context.push('/product/${product.id}'),
          child: Container(
            height: height,
            width: double.infinity,
            color: cardBg,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (product.imageAsset != null)
                  Image.asset(
                    product.imageAsset!,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, st) => Center(
                      child: Icon(
                        CupertinoIcons.scissors,
                        color: fgMuted,
                        size: 32,
                      ),
                    ),
                  )
                else
                  Center(
                    child: Icon(
                      CupertinoIcons.scissors,
                      color: fgMuted,
                      size: 32,
                    ),
                  ),
                // Bottom fade
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          cardBg.withValues(alpha: 0.8),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                // Brand tag
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    color: isDark
                        ? AppColors.background.withValues(alpha: 0.75)
                        : Colors.white.withValues(alpha: 0.8),
                    child: Text(
                      product.brand.toUpperCase(),
                      style: TextStyle(
                        color: fg,
                        fontSize: 9,
                        letterSpacing: 3,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // Favourite removal
                Positioned(
                  top: 12,
                  right: 12,
                  child: GestureDetector(
                    onTap: () =>
                        ref.read(favoritesProvider.notifier).toggle(product.id),
                    child: Icon(
                      isFav ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                      color: isFav ? AppColors.accent : fgMuted,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          product.name.toUpperCase(),
          style: TextStyle(
            color: fg,
            fontSize: 12,
            letterSpacing: 2,
            fontWeight: FontWeight.w400,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '\$${product.price.toStringAsFixed(0)}',
              style: TextStyle(color: fgMuted, fontSize: 13, letterSpacing: 1),
            ),
            GestureDetector(
              onTap: () {
                ref.read(cartProvider.notifier).add(product);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: isDark
                        ? AppColors.white
                        : const Color(0xFF1A1A1A),
                    duration: const Duration(seconds: 2),
                    content: Text('${product.name} added to bag'),
                  ),
                );
              },
              child: Text(
                'ADD TO BAG',
                style: TextStyle(
                  color: fg,
                  fontSize: 10,
                  letterSpacing: 3,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
