import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../home/presentation/providers/home_providers.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../domain/product.dart';
import 'package:go_router/go_router.dart';

class BrandPage extends ConsumerWidget {
  final String brand;
  const BrandPage({super.key, required this.brand});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.background : AppColors.lightBackground;
    final cardBg = isDark ? AppColors.cardDark : AppColors.lightCard;
    final fg = isDark ? AppColors.white : AppColors.lightTextTitle;
    final fgMuted = isDark ? AppColors.textBody : AppColors.lightTextBody;
    final borderColor = isDark ? AppColors.cardLight : AppColors.lightBorder;

    final brandProducts = mockProducts.where((p) => p.brand == brand).toList();

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
                  const SizedBox(height: 40),
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          CupertinoIcons.chevron_left,
                          size: 14,
                          color: fgMuted,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'BACK',
                          style: TextStyle(
                            color: fgMuted,
                            fontSize: 10,
                            letterSpacing: 4,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Brand label
                  Row(
                    children: [
                      Container(
                        width: 16,
                        height: 0.5,
                        color: AppColors.accent,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'BRAND',
                        style: TextStyle(
                          color: AppColors.accent,
                          fontSize: 11,
                          letterSpacing: 6,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Brand name as hero title
                  Text(
                    brand,
                    style: TextStyle(
                      color: fg,
                      fontSize: 56,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${brandProducts.length} PIECES',
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

                  // 3-column grid — 1:1.5 ratio same as product page
                  brandProducts.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(64),
                          child: Center(
                            child: Text(
                              'NO PIECES FOUND FOR $brand',
                              style: TextStyle(
                                color: fgMuted,
                                letterSpacing: 4,
                                fontSize: 12,
                              ),
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
                              children: brandProducts.map((product) {
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
                      product.category.toUpperCase(),
                      style: TextStyle(
                        color: fg,
                        fontSize: 9,
                        letterSpacing: 3,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
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
