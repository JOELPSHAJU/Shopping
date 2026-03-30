import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../home/presentation/providers/home_providers.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../domain/product.dart';

// ── Search query provider ──────────────────────────────────────────────────
final searchQueryProvider = StateProvider<String>((ref) => '');

// ── Autocomplete suggestions provider ─────────────────────────────────────
final searchSuggestionsProvider = Provider<List<Product>>((ref) {
  final query = ref.watch(searchQueryProvider).trim().toLowerCase();
  if (query.isEmpty) return [];
  return mockProducts
      .where(
        (p) =>
            p.name.toLowerCase().contains(query) ||
            p.category.toLowerCase().contains(query) ||
            p.brand.toLowerCase().contains(query),
      )
      .take(6)
      .toList();
});

// ── Products grouped by category ──────────────────────────────────────────
final groupedProductsProvider = Provider<Map<String, List<Product>>>((ref) {
  final query = ref.watch(searchQueryProvider).trim().toLowerCase();
  final source = query.isEmpty
      ? mockProducts
      : mockProducts
            .where(
              (p) =>
                  p.name.toLowerCase().contains(query) ||
                  p.category.toLowerCase().contains(query) ||
                  p.brand.toLowerCase().contains(query),
            )
            .toList();

  final map = <String, List<Product>>{};
  for (final p in source) {
    map.putIfAbsent(p.brand, () => []).add(p);
  }
  return map;
});

class ProductListPage extends ConsumerStatefulWidget {
  const ProductListPage({super.key});

  @override
  ConsumerState<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends ConsumerState<ProductListPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _showSuggestions =
            _focusNode.hasFocus && ref.read(searchQueryProvider).isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.background : AppColors.lightBackground;
    final cardBg = isDark ? AppColors.cardDark : AppColors.lightCard;
    final fg = isDark ? AppColors.white : AppColors.lightTextTitle;
    final fgMuted = isDark ? AppColors.textBody : AppColors.lightTextBody;
    final borderColor = isDark ? AppColors.cardLight : AppColors.lightBorder;

    final groupedProducts = ref.watch(groupedProductsProvider);
    final suggestions = ref.watch(searchSuggestionsProvider);
    final query = ref.watch(searchQueryProvider);

    return Scaffold(
      backgroundColor: bg,
      body: GestureDetector(
        onTap: () {
          _focusNode.unfocus();
          setState(() => _showSuggestions = false);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Search Bar ────────────────────────────────────────────────
            Container(
              color: bg,
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: Column(
                    children: [
                      // Search input
                      Container(
                        decoration: BoxDecoration(
                          color: cardBg,
                          border: Border.all(color: borderColor, width: 0.5),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Icon(
                                CupertinoIcons.search,
                                size: 20,
                                color: fgMuted,
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                focusNode: _focusNode,
                                style: TextStyle(
                                  color: fg,
                                  fontSize: 14,
                                  letterSpacing: 1,
                                  fontWeight: FontWeight.w300,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'SEARCH STYLES, BRANDS...',
                                  hintStyle: TextStyle(
                                    color: fgMuted,
                                    fontSize: 12,
                                    letterSpacing: 3,
                                    fontWeight: FontWeight.w300,
                                  ),
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  filled: false,
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 18,
                                  ),
                                ),
                                onChanged: (val) {
                                  ref.read(searchQueryProvider.notifier).state =
                                      val;
                                  setState(() {
                                    _showSuggestions = val.isNotEmpty;
                                  });
                                },
                              ),
                            ),
                            if (query.isNotEmpty)
                              GestureDetector(
                                onTap: () {
                                  _searchController.clear();
                                  ref.read(searchQueryProvider.notifier).state =
                                      '';
                                  setState(() => _showSuggestions = false);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: Icon(
                                    CupertinoIcons.xmark,
                                    size: 18,
                                    color: fgMuted,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),

                      // ── Autocomplete Dropdown ─────────────────────────
                      if (_showSuggestions && suggestions.isNotEmpty)
                        Container(
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.cardLight
                                : const Color(0xFFE8E3DC),
                            border: Border.all(color: borderColor, width: 0.5),
                          ),
                          child: Column(
                            children: suggestions.map((product) {
                              return InkWell(
                                onTap: () {
                                  _searchController.text = product.name;
                                  ref.read(searchQueryProvider.notifier).state =
                                      product.name;
                                  _focusNode.unfocus();
                                  setState(() => _showSuggestions = false);
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 14,
                                  ),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        color: borderColor,
                                        width: 0.5,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        CupertinoIcons.search,
                                        size: 14,
                                        color: fgMuted,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            _highlightMatch(
                                              product.name,
                                              query,
                                              fg,
                                              fgMuted,
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              '${product.brand}  ·  ${product.category}',
                                              style: TextStyle(
                                                color: fgMuted,
                                                fontSize: 11,
                                                letterSpacing: 2,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        '\$${product.price.toStringAsFixed(0)}',
                                        style: TextStyle(
                                          color: AppColors.accent,
                                          fontSize: 13,
                                          letterSpacing: 1,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Main scrollable content ────────────────────────────────
            Expanded(
              child: groupedProducts.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(CupertinoIcons.search, size: 48, color: fgMuted),
                          const SizedBox(height: 24),
                          Text(
                            'NO RESULTS FOUND',
                            style: TextStyle(
                              color: fgMuted,
                              letterSpacing: 4,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: 80),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1200),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: groupedProducts.entries
                                  .map(
                                    (entry) => _buildCategory(
                                      context,
                                      ref,
                                      entry.key,
                                      entry.value,
                                      fg,
                                      fgMuted,
                                      borderColor,
                                      isDark,
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Category Section ─────────────────────────────────────────────────────
  Widget _buildCategory(
    BuildContext context,
    WidgetRef ref,
    String category,
    List<Product> products,
    Color fg,
    Color fgMuted,
    Color borderColor,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 64),
        // Category title
        Row(
          children: [
            Container(width: 16, height: 0.5, color: AppColors.accent),
            const SizedBox(width: 12),
            Text(
              category.toUpperCase(),
              style: TextStyle(
                color: AppColors.accent,
                fontSize: 11,
                letterSpacing: 6,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          category,
          style: TextStyle(
            color: fg,
            fontSize: 36,
            fontWeight: FontWeight.w300,
            letterSpacing: 4,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 16, bottom: 40),
          height: 0.5,
          color: borderColor,
        ),

        // 3-column grid — aspect ratio 2:6 (width:height = 1:3)
        LayoutBuilder(
          builder: (context, constraints) {
            final crossCount = constraints.maxWidth > 700
                ? 3
                : constraints.maxWidth > 450
                ? 2
                : 1;
            final itemWidth =
                (constraints.maxWidth - (crossCount - 1) * 24) / crossCount;
            final itemHeight = itemWidth * 1.5; // 3:6 = 1:2 ratio

            return Wrap(
              spacing: 24,
              runSpacing: 40,
              children: products.map((product) {
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
                    isDark,
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  // ── Product Card ─────────────────────────────────────────────────────────
  Widget _buildCard(
    BuildContext context,
    WidgetRef ref,
    Product product,
    double height,
    Color fg,
    Color fgMuted,
    Color borderColor,
    bool isDark,
  ) {
    final favorites = ref.watch(favoritesProvider);
    final isFav = favorites.contains(product.id);
    final cardBg = isDark ? AppColors.cardDark : const Color(0xFFE8E3DC);

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
            Consumer(
              builder: (context, ref, child) {
                final cart = ref.watch(cartProvider);
                final isInCart = cart.any((item) => item.product.id == product.id);
                return GestureDetector(
                  onTap: () {
                    if (isInCart) {
                      context.go('/cart');
                    } else {
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
                    }
                  },
                  child: Text(
                    isInCart ? 'GO TO BAG' : 'ADD TO BAG',
                    style: TextStyle(
                      color: fg,
                      fontSize: 10,
                      letterSpacing: 3,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  // ── Highlight matching text in suggestion ─────────────────────────────────
  Widget _highlightMatch(String text, String query, Color fg, Color fgMuted) {
    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final index = lowerText.indexOf(lowerQuery);

    if (index < 0) {
      return Text(
        text,
        style: TextStyle(color: fg, fontSize: 13, letterSpacing: 1),
      );
    }

    return RichText(
      text: TextSpan(
        children: [
          if (index > 0)
            TextSpan(
              text: text.substring(0, index),
              style: TextStyle(
                color: fgMuted,
                fontSize: 13,
                letterSpacing: 1,
                fontWeight: FontWeight.w300,
              ),
            ),
          TextSpan(
            text: text.substring(index, index + query.length),
            style: TextStyle(
              color: fg,
              fontSize: 13,
              letterSpacing: 1,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (index + query.length < text.length)
            TextSpan(
              text: text.substring(index + query.length),
              style: TextStyle(
                color: fgMuted,
                fontSize: 13,
                letterSpacing: 1,
                fontWeight: FontWeight.w300,
              ),
            ),
        ],
      ),
    );
  }
}
