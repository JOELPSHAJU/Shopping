import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../home/presentation/providers/home_providers.dart';
import '../../../cart/presentation/providers/cart_provider.dart';

class ProductDetailPage extends ConsumerStatefulWidget {
  final String productId;

  const ProductDetailPage({super.key, required this.productId});

  @override
  ConsumerState<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends ConsumerState<ProductDetailPage> {
  String selectedSize = 'M';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.background : const Color(0xFFF8F5F0);
    final fg = isDark ? AppColors.white : const Color(0xFF1A1A1A);
    final fgMuted = isDark ? AppColors.textBody : const Color(0xFF888480);
    final cardBg = isDark ? AppColors.cardDark : const Color(0xFFE8E3DC);
    final borderColor = isDark ? AppColors.cardLight : const Color(0xFFDDD8D0);

    final product = mockProducts.firstWhere(
      (p) => p.id == widget.productId,
      orElse: () => mockProducts.first,
    );

    final similarProducts = mockProducts
        .where((p) => p.category == product.category && p.id != product.id)
        .take(5)
        .toList();

    return Scaffold(
      backgroundColor: bg,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Elegant Back Button
            const SizedBox(height: 40),
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
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
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Main Product View
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // LEFT: Image Gallery Grid (2x2)
                    Expanded(
                      flex: 6,
                      child: Column(
                        children: [
                          GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 0.8,
                            children: List.generate(
                              4,
                              (index) => Container(
                                color: cardBg,
                                child: Stack(
                                  children: [
                                    Center(
                                      child: Icon(
                                        CupertinoIcons.scissors,
                                        color: fgMuted,
                                        size: 40,
                                      ),
                                    ),
                                    if (index ==
                                        0) // Main view could have the actual image if we had multiple
                                      const Positioned.fill(child: Center()),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 80),

                          // Product Details Accordion Style (Below Images)
                          _detailsAccordion(
                            'PRODUCT HIGHLIGHTS',
                            [
                              '100% Cotton Blend',
                              'Mandarin Collar',
                              'Modern Slim Fit',
                              'Artisanal Stitching',
                            ],
                            fg,
                            fgMuted,
                            borderColor,
                          ),
                          _detailsAccordion(
                            'COMPOSITION & CARE',
                            [
                              'Hand wash cold',
                              'Do not bleach',
                              'Iron at low temperature',
                            ],
                            fg,
                            fgMuted,
                            borderColor,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 60),

                    // RIGHT: Purchase Info
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Brand & Type breadcrumb
                          Text(
                            'HOME / ${product.category.toUpperCase()} / ${product.brand.toUpperCase()}',
                            style: TextStyle(
                              color: fgMuted,
                              fontSize: 10,
                              letterSpacing: 3,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Title
                          Text(
                            product.name,
                            style: TextStyle(
                              color: fg,
                              fontSize: 32,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Rating
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF26A541),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Row(
                                  children: [
                                    Text(
                                      '4.1',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Icon(
                                      Icons.star,
                                      color: Colors.white,
                                      size: 12,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                '37,842 ratings',
                                style: TextStyle(color: fgMuted, fontSize: 12),
                              ),
                            ],
                          ),

                          const SizedBox(height: 32),

                          // Price
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '\$${product.price.toStringAsFixed(0)}',
                                style: TextStyle(
                                  color: fg,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Text(
                                '\$${(product.price * 4.8).toStringAsFixed(0)}',
                                style: TextStyle(
                                  color: fgMuted,
                                  fontSize: 18,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              const SizedBox(width: 16),
                              const Text(
                                '79% off',
                                style: TextStyle(
                                  color: Color(0xFF26A541),
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 32),

                          // Delivery info
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              border: Border.all(color: borderColor),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      CupertinoIcons.location,
                                      size: 16,
                                      color: fg,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      'CHECK DELIVERY AVAILABILITY',
                                      style: TextStyle(
                                        color: fg,
                                        fontSize: 11,
                                        letterSpacing: 2,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Delivery in 2-4 business days | Free Shipping on orders over \$500',
                                  style: TextStyle(
                                    color: fgMuted,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 48),

                          // Size selector
                          Text(
                            'SELECT SIZE',
                            style: TextStyle(
                              color: fg,
                              fontSize: 10,
                              letterSpacing: 4,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: ['S', 'M', 'L', 'XL', 'XXL']
                                .map(
                                  (s) => _sizeChip(
                                    s,
                                    s == selectedSize,
                                    fg,
                                    bg,
                                    () {
                                      setState(() {
                                        selectedSize = s;
                                      });
                                    },
                                  ),
                                )
                                .toList(),
                          ),

                          const SizedBox(height: 64),

                          // Sticky-like Actions
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 64,
                                  child: OutlinedButton(
                                    onPressed: () {
                                      ref
                                          .read(cartProvider.notifier)
                                          .add(product, size: selectedSize);
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          backgroundColor: fg,
                                          duration: const Duration(seconds: 1),
                                          content: Text(
                                            'ADDED TO BAG ($selectedSize)',
                                            style: TextStyle(
                                              color: bg,
                                              fontSize: 10,
                                              letterSpacing: 4,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(color: fg, width: 1),
                                      shape: const RoundedRectangleBorder(),
                                    ),
                                    child: Text(
                                      'ADD TO BAG',
                                      style: TextStyle(
                                        color: fg,
                                        fontSize: 12,
                                        letterSpacing: 4,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: SizedBox(
                                  height: 64,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      context.push('/checkout');
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: fg,
                                      elevation: 0,
                                      shape: const RoundedRectangleBorder(),
                                    ),
                                    child: Text(
                                      'BUY NOW',
                                      style: TextStyle(
                                        color: bg,
                                        fontSize: 12,
                                        letterSpacing: 4,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 40),

                          // Favourites toggle
                          Center(
                            child: GestureDetector(
                              onTap: () => ref
                                  .read(favoritesProvider.notifier)
                                  .toggle(product.id),
                              child: Text(
                                'ADD TO WISHLIST',
                                style: TextStyle(
                                  color: fg,
                                  fontSize: 10,
                                  letterSpacing: 4,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
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

            const SizedBox(height: 120),

            // SIMILAR PRODUCTS
            if (similarProducts.isNotEmpty)
              _buildSimilarSection(
                context,
                similarProducts,
                fg,
                fgMuted,
                cardBg,
                isDark,
              ),

            const SizedBox(height: 120),
          ],
        ),
      ),
    );
  }

  Widget _buildSimilarSection(
    BuildContext context,
    List similar,
    Color fg,
    Color fgMuted,
    Color cardBg,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            'SIMILAR PIECES',
            style: TextStyle(
              color: fg,
              fontSize: 18,
              letterSpacing: 6,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        const SizedBox(height: 32),
        SizedBox(
          height: 450,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 40),
            itemCount: similar.length,
            itemBuilder: (context, index) {
              final p = similar[index];
              return Container(
                width: 280,
                margin: const EdgeInsets.only(right: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 350,
                      color: cardBg,
                      child: Center(
                        child: Icon(
                          CupertinoIcons.scissors,
                          color: fgMuted,
                          size: 40,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      p.name.toUpperCase(),
                      style: TextStyle(
                        color: fg,
                        fontSize: 11,
                        letterSpacing: 2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${p.price.toStringAsFixed(0)}',
                      style: TextStyle(color: fgMuted, fontSize: 12),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _detailsAccordion(
    String title,
    List<String> items,
    Color fg,
    Color fgMuted,
    Color border,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: border, width: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: fg,
              fontSize: 12,
              letterSpacing: 4,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Container(width: 12, height: 0.5, color: fgMuted),
                  const SizedBox(width: 12),
                  Text(
                    item,
                    style: TextStyle(
                      color: fgMuted,
                      fontSize: 13,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sizeChip(
    String size,
    bool selected,
    Color fg,
    Color bg,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          border: Border.all(color: fg, width: 0.5),
          color: selected ? fg : Colors.transparent,
        ),
        child: Center(
          child: Text(
            size,
            style: TextStyle(
              color: selected ? bg : fg,
              fontSize: 12,
              fontWeight: selected ? FontWeight.bold : FontWeight.w300,
            ),
          ),
        ),
      ),
    );
  }
}
