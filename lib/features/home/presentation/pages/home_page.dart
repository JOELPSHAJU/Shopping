import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/home_providers.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../../product/domain/product.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800;

    final selectedCategory = ref.watch(selectedCategoryProvider);
    final products = ref.watch(filteredProductsProvider);
    final favorites = ref.watch(favoritesProvider);
    final favoriteProducts = mockProducts
        .where((p) => favorites.contains(p.id))
        .toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Hero Banner ──────────────────────────────────────────────
            _buildHero(context, isDesktop),

            // ── Marquee Brand Strip ──────────────────────────────────────
            _buildBrandStrip(),

            // ── SS26 Collection ──────────────────────────────────────────
            _buildConstrainedSection(
              paddingVertical: 80,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionLabel(context, 'SS26 COLLECTION'),
                  const SizedBox(height: 16),
                  Text(
                    'New Arrivals',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: isDesktop ? 64 : 40,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 48),
                  // Category filter tabs
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: ['All', 'Gowns', 'Ready-To-Wear', 'Bridal'].map(
                        (cat) {
                          final isSel = selectedCategory == cat;
                          return GestureDetector(
                            onTap: () =>
                                ref
                                        .read(selectedCategoryProvider.notifier)
                                        .state =
                                    cat,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              margin: const EdgeInsets.only(right: 32),
                              padding: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: isSel
                                        ? AppColors.white
                                        : Colors.transparent,
                                    width: 1,
                                  ),
                                ),
                              ),
                              child: Text(
                                cat.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 13,
                                  letterSpacing: 4,
                                  fontWeight: FontWeight.w300,
                                  color: isSel
                                      ? AppColors.white
                                      : AppColors.textBody,
                                ),
                              ),
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  ),
                  const SizedBox(height: 56),
                  products.isEmpty
                      ? Padding(
                          padding: const EdgeInsets.all(32),
                          child: Text(
                            'COLLECTION EMPTY',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        )
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: products.map((p) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 40),
                                child: _buildProductCard(
                                  context,
                                  ref,
                                  p,
                                  height: 560,
                                  width: 380,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                ],
              ),
            ),

            // ── Editorial Full-width Image ────────────────────────────────
            _buildEditorialBanner(context, isDesktop),

            // ── Curated Picks ───────────────────────────────────────────
            _buildConstrainedSection(
              paddingVertical: 80,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionLabel(context, 'CURATED FOR YOU'),
                  const SizedBox(height: 16),
                  Text(
                    favoriteProducts.isEmpty
                        ? 'Most Wanted'
                        : 'Your Favourites',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: isDesktop ? 56 : 36,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 48),
                  favoriteProducts.isEmpty
                      ? _buildDefaultFavourites(context, ref, isDesktop)
                      : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: favoriteProducts.map((p) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 32),
                                child: _buildProductCard(
                                  context,
                                  ref,
                                  p,
                                  height: 440,
                                  width: 300,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                ],
              ),
            ),

            // ── Email / Join the House ────────────────────────────────────
            _buildJoin(context, isDesktop),

            // ── Footer ────────────────────────────────────────────────────
            _buildFooter(context, isDesktop),
          ],
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // HERO
  // ──────────────────────────────────────────────────────────────────────────
  Widget _buildHero(BuildContext context, bool isDesktop) {
    return SizedBox(
      width: double.infinity,
      height: isDesktop ? 720 : 600,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background image (editorial campaign gown)
          Image.asset(
            'assets/images/dress_hero.webp',
            fit: BoxFit.cover,
            color: Colors.black.withValues(alpha: 0.35),
            colorBlendMode: BlendMode.darken,
          ),
          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  AppColors.background,
                  AppColors.background.withValues(alpha: 0.0),
                ],
                stops: const [0.0, 0.7],
              ),
            ),
          ),
          // Content
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      color: AppColors.accent.withValues(alpha: 0.2),
                      child: Text(
                        'S S 2 6',
                        style: TextStyle(
                          color: AppColors.accent,
                          fontSize: 12,
                          letterSpacing: 6,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'ETHEREAL\nSILHOUETTES',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontSize: isDesktop ? 88 : 56,
                        height: 1.0,
                        letterSpacing: 4,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: 440,
                      child: Text(
                        'Redefining the architecture of the modern gown — '
                        'weightless fabrics, avant-garde draping.',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          height: 1.8,
                          color: AppColors.textBody,
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 48,
                              vertical: 20,
                            ),
                            elevation: 0,
                            shape: const ContinuousRectangleBorder(),
                          ),
                          child: const Text(
                            'SHOP NOW',
                            style: TextStyle(
                              color: AppColors.black,
                              fontSize: 13,
                              letterSpacing: 4,
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: AppColors.white,
                              width: 0.5,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 20,
                            ),
                            shape: const ContinuousRectangleBorder(),
                          ),
                          child: const Text(
                            'VIEW LOOKBOOK',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 13,
                              letterSpacing: 3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // BRAND STRIP
  // ──────────────────────────────────────────────────────────────────────────
  Widget _buildBrandStrip() {
    const brands = [
      'MAISON MARGIELA',
      'BALENCIAGA',
      'SAINT LAURENT',
      'GIVENCHY',
      'ALEXANDER MCQUEEN',
      'MUGLER',
      'VALENTINO',
    ];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28),
      decoration: const BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(color: Color(0xFF222222), width: 1),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Opacity(
          opacity: 0.45,
          child: Row(
            children: brands
                .expand(
                  (b) => [
                    const SizedBox(width: 64),
                    Text(
                      b,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 15,
                        letterSpacing: 6,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // PRODUCT CARD
  // ──────────────────────────────────────────────────────────────────────────
  Widget _buildProductCard(
    BuildContext context,
    WidgetRef ref,
    Product product, {
    required double height,
    required double width,
  }) {
    final favorites = ref.watch(favoritesProvider);
    final isFav = favorites.contains(product.id);

    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image container
          Container(
            height: height,
            width: width,
            color: AppColors.cardDark,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (product.imageAsset != null)
                  Image.asset(
                    product.imageAsset!,
                    fit: BoxFit.cover,
                    errorBuilder: (ctx, err, st) => const Center(
                      child: Icon(
                        CupertinoIcons.scissors,
                        color: AppColors.secondary,
                        size: 32,
                      ),
                    ),
                  )
                else
                  const Center(
                    child: Icon(
                      CupertinoIcons.scissors,
                      color: AppColors.secondary,
                      size: 32,
                    ),
                  ),
                // Overlay on hover feel — bottom gradient
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          AppColors.background.withValues(alpha: 0.7),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                // Favourite
                Positioned(
                  top: 20,
                  right: 20,
                  child: GestureDetector(
                    onTap: () =>
                        ref.read(favoritesProvider.notifier).toggle(product.id),
                    child: Icon(
                      isFav ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                      color: isFav ? AppColors.accent : AppColors.white,
                      size: 22,
                    ),
                  ),
                ),
                // Brand tag
                Positioned(
                  top: 20,
                  left: 20,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    color: AppColors.background.withValues(alpha: 0.7),
                    child: Text(
                      product.brand,
                      style: const TextStyle(
                        color: AppColors.white,
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
          const SizedBox(height: 20),
          Text(
            product.name.toUpperCase(),
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 13,
              letterSpacing: 2,
              fontWeight: FontWeight.w400,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$${product.price.toStringAsFixed(0)}',
                style: const TextStyle(
                  color: AppColors.textBody,
                  fontSize: 14,
                  letterSpacing: 1,
                ),
              ),
              GestureDetector(
                onTap: () {
                  ref.read(cartProvider.notifier).add(product);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: AppColors.white,
                      behavior: SnackBarBehavior.floating,
                      margin: const EdgeInsets.all(24),
                      content: Text(
                        '${product.name} added to bag',
                        style: const TextStyle(
                          color: AppColors.black,
                          fontSize: 12,
                          letterSpacing: 2,
                        ),
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                child: const Text(
                  'ADD TO BAG',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 11,
                    letterSpacing: 3,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultFavourites(
    BuildContext context,
    WidgetRef ref,
    bool isDesktop,
  ) {
    final picks = mockProducts.take(4).toList();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: picks.map((p) {
          return Padding(
            padding: const EdgeInsets.only(right: 32),
            child: _buildProductCard(context, ref, p, height: 440, width: 300),
          );
        }).toList(),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // EDITORIAL BANNER
  // ──────────────────────────────────────────────────────────────────────────
  Widget _buildEditorialBanner(BuildContext context, bool isDesktop) {
    return Container(
      width: double.infinity,
      color: AppColors.cardDark,
      child: isDesktop
          ? IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Left image
                  Expanded(
                    flex: 5,
                    child: SizedBox(
                      height: 640,
                      child: Image.asset(
                        'assets/images/dress_cobalt_02.webp',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Right content
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(80.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _sectionLabel(context, 'ARCHIVE EVENT'),
                          const SizedBox(height: 24),
                          Text(
                            'THE\nPREMIERE\nEDITION',
                            style: Theme.of(context).textTheme.displayLarge
                                ?.copyWith(
                                  fontSize: 64,
                                  height: 1.0,
                                  letterSpacing: 4,
                                  fontWeight: FontWeight.w300,
                                ),
                          ),
                          const SizedBox(height: 32),
                          Text(
                            'For a limited time, acquire select archival showpieces at an unprecedented price adjustment.',
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  height: 1.8,
                                  color: AppColors.textBody,
                                ),
                          ),
                          const SizedBox(height: 56),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 48,
                                vertical: 20,
                              ),
                              elevation: 0,
                              shape: const ContinuousRectangleBorder(),
                            ),
                            child: const Text(
                              'ENTER ARCHIVE',
                              style: TextStyle(
                                color: AppColors.black,
                                fontSize: 13,
                                letterSpacing: 4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 500,
                  width: double.infinity,
                  child: Image.asset(
                    'assets/images/dress_cobalt_02.webp',
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionLabel(context, 'ARCHIVE EVENT'),
                      const SizedBox(height: 24),
                      Text(
                        'THE PREMIERE EDITION',
                        style: Theme.of(context).textTheme.displayLarge
                            ?.copyWith(fontSize: 40, letterSpacing: 2),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Acquire select archival showpieces at an unprecedented price adjustment.',
                        style: Theme.of(
                          context,
                        ).textTheme.bodyLarge?.copyWith(height: 1.8),
                      ),
                      const SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 18,
                          ),
                          elevation: 0,
                          shape: const ContinuousRectangleBorder(),
                        ),
                        child: const Text(
                          'ENTER ARCHIVE',
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 13,
                            letterSpacing: 4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // JOIN THE HOUSE (email)
  // ──────────────────────────────────────────────────────────────────────────
  Widget _buildJoin(BuildContext context, bool isDesktop) {
    return _buildConstrainedSection(
      backgroundColor: AppColors.cardLight,
      paddingVertical: 120,
      child: Column(
        children: [
          Text(
            'JOIN THE HOUSE\nPRIVATE PREVIEWS',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              fontSize: isDesktop ? 48 : 32,
              letterSpacing: 8,
              height: 1.4,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Receive early access to the bridal and evening collections.',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: AppColors.textBody),
          ),
          const SizedBox(height: 56),
          SizedBox(
            width: 560,
            height: 56,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.background,
                border: Border.all(
                  color: AppColors.secondary.withValues(alpha: 0.4),
                  width: 0.5,
                ),
              ),
              padding: const EdgeInsets.only(left: 24, right: 4),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 14,
                        letterSpacing: 1,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Email address',
                        hintStyle: TextStyle(color: AppColors.textBody),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        filled: false,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      elevation: 0,
                      shape: const ContinuousRectangleBorder(),
                    ),
                    child: const Text(
                      'SUBSCRIBE',
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 12,
                        letterSpacing: 3,
                      ),
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

  // ──────────────────────────────────────────────────────────────────────────
  // FOOTER
  // ──────────────────────────────────────────────────────────────────────────
  Widget _buildFooter(BuildContext context, bool isDesktop) {
    return _buildConstrainedSection(
      paddingVertical: 100,
      child: isDesktop
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 3, child: _buildFooterBrand(context)),
                Expanded(
                  flex: 1,
                  child: _buildFooterCol('HOUSE', [
                    'Heritage',
                    'Designers',
                    'Sustainability',
                    'Careers',
                  ]),
                ),
                Expanded(
                  flex: 1,
                  child: _buildFooterCol('SERVICE', [
                    'Book Appointment',
                    'Order Status',
                    'Care Guide',
                    'FAQ',
                  ]),
                ),
                Expanded(
                  flex: 1,
                  child: _buildFooterCol('LEGAL', [
                    'Terms',
                    'Privacy',
                    'Accessibility',
                  ]),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFooterBrand(context),
                const SizedBox(height: 80),
                Wrap(
                  spacing: 56,
                  runSpacing: 48,
                  children: [
                    _buildFooterCol('HOUSE', [
                      'Heritage',
                      'Designers',
                      'Sustainability',
                      'Careers',
                    ]),
                    _buildFooterCol('SERVICE', [
                      'Book Appointment',
                      'Order Status',
                      'Care Guide',
                      'FAQ',
                    ]),
                    _buildFooterCol('LEGAL', [
                      'Terms',
                      'Privacy',
                      'Accessibility',
                    ]),
                  ],
                ),
              ],
            ),
    );
  }

  Widget _buildFooterBrand(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'A U R A',
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
            color: AppColors.white,
            fontSize: 36,
            letterSpacing: 12,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Pioneering future elegance.\nParis  ·  Milan  ·  Tokyo',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            height: 1.8,
            color: AppColors.textBody,
          ),
        ),
        const SizedBox(height: 40),
        Row(
          children: ['IG', 'TW', 'LI', 'YT'].map((s) {
            return Container(
              margin: const EdgeInsets.only(right: 16),
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.textBody.withValues(alpha: 0.3),
                  width: 0.5,
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                s,
                style: const TextStyle(
                  color: AppColors.textBody,
                  fontSize: 11,
                  letterSpacing: 1,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFooterCol(String title, List<String> links) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 4,
          ),
        ),
        const SizedBox(height: 40),
        ...links.map(
          (l) => Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Text(
              l.toUpperCase(),
              style: const TextStyle(
                color: AppColors.textBody,
                fontSize: 11,
                letterSpacing: 3,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // HELPERS
  // ──────────────────────────────────────────────────────────────────────────
  Widget _buildConstrainedSection({
    required Widget child,
    Color? backgroundColor,
    required double paddingVertical,
  }) {
    return Container(
      width: double.infinity,
      color: backgroundColor ?? AppColors.background,
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
          style: TextStyle(
            color: AppColors.accent,
            fontSize: 11,
            letterSpacing: 6,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
