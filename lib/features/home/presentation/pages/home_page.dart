import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/home_providers.dart';

import '../../../product/domain/product.dart';
import 'package:go_router/go_router.dart';

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
            _buildBrandStrip(context),

            // ── SS26 Collection ──────────────────────────────────────────
            _buildConstrainedSection(
              paddingVertical: 80,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionLabel(context, 'FATHASH COLLECTIONS'),
                  const SizedBox(height: 16),
                  Text(
                    'Must-Have Styles',
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
                      children:
                          [
                            'All',
                            'GOWNS',
                            'READY-TO-WEAR',
                            'SUITS',
                            'TOPS',
                          ].map((cat) {
                            final isSel = selectedCategory == cat;
                            return GestureDetector(
                              onTap: () =>
                                  ref
                                          .read(
                                            selectedCategoryProvider.notifier,
                                          )
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
                          }).toList(),
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
                    'Most Wanted',

                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: isDesktop ? 56 : 36,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 48),
                  _buildDefaultFavourites(context, ref, isDesktop),
                ],
              ),
            ),

            _buildJoin(context, isDesktop),
            _buildFooter(context, isDesktop),
          ],
        ),
      ),
    );
  }

  Widget _buildHero(BuildContext context, bool isDesktop) {
    return SizedBox(
      width: double.infinity,
      height: isDesktop ? 720 : 600,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/dress_hero.webp',
            fit: BoxFit.cover,
            color: Colors.black.withValues(alpha: 0.35),
            colorBlendMode: BlendMode.darken,
          ),
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
                        'NEW IN',
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
                      'MODEST\nCOLLECTIONS',
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
                        'Ladies modest wear for the modern woman — cotton sets, '
                        'elegant gowns, and artisanal co-ord sets.',
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

  Widget _buildBrandStrip(BuildContext context) {
    const brands = [
      'COTTON SET',
      'PARTY WEAR',
      'GOWN',
      'CO-ORD SET',
      'LONG KURTHI',
      'KAFTHAN GOWN',
      'ROMPER',
      'WESTERN GOWN',
      'DENIM GOWN',
      'SHORT KURTI',
      'KAFTHAN',
      'DENIM CORD SET',
      'PAKISTHANI SUIT',
      'KNEE LENGTH DENIM',
      'KNEE LENGTH TOP',
      'DENIM ROMPER',
      'WESTERN LONGTOP',
      'LONG CO-CORD SET',
      'SHORT TOPS',
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
            children:
                brands
                    .expand(
                      (b) => [
                        const SizedBox(width: 64),
                        GestureDetector(
                          onTap: () => context.push('/brand/$b'),
                          child: Text(
                            b,
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 15,
                              letterSpacing: 6,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ],
                    )
                    .toList()
                  ..add(const SizedBox(width: 64)),
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(
    BuildContext context,
    WidgetRef ref,
    Product product, {
    required double height,
    required double width,
  }) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => context.push('/product/${product.id}'),
            child: Container(
              height: height,
              width: width,
              color: AppColors.cardDark,
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
          ),
          const SizedBox(height: 20),
          Text(
            product.brand.toUpperCase(),
            style: const TextStyle(
              color: AppColors.textBody,
              fontSize: 10,
              letterSpacing: 2,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            product.name,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 16,
              letterSpacing: 1,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '\$${product.price.toStringAsFixed(0)}',
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
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
    final products = mockProducts.take(3).toList();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: products.map((p) {
          return Padding(
            padding: const EdgeInsets.only(right: 32),
            child: _buildProductCard(context, ref, p, height: 440, width: 300),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildJoin(BuildContext context, bool isDesktop) {
    return _buildConstrainedSection(
      paddingVertical: 120,
      backgroundColor: const Color(0xFF111111),
      child: Column(
        children: [
          const Text(
            'JOIN THE WORLD OF FATHASH',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 12,
              letterSpacing: 8,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 48),
          SizedBox(
            width: 600,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'YOUR EMAIL ADDRESS',
                hintStyle: const TextStyle(
                  color: AppColors.textBody,
                  fontSize: 11,
                  letterSpacing: 4,
                ),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF333333)),
                ),
                focusedBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.white),
                ),
                suffixIcon: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'JOIN',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 11,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context, bool isDesktop) {
    return _buildConstrainedSection(
      paddingVertical: 120,
      backgroundColor: Colors.black,
      child: isDesktop
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: _buildFooterBrand(context)),
                _buildFooterLinks('BOUTIQUE', [
                  'All Dresses',
                  'Latest Picks',
                  'Archives',
                ]),
                const SizedBox(width: 80),
                _buildFooterLinks('SUPPORT', [
                  'Shipping & T&C',
                  'Help Center',
                  'Payment',
                ]),
                const SizedBox(width: 80),
                _buildFooterLinks('CONTACT', [
                  'Instagram',
                  'Business Inquiry',
                  'WhatsApp',
                ]),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFooterBrand(context),
                const SizedBox(height: 80),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildFooterLinks('BOUTIQUE', ['Dresses', 'Latest']),
                    _buildFooterLinks('SUPPORT', ['T&C', 'Policy']),
                    _buildFooterLinks('SOCIAL', ['IG', 'WA']),
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'F A T H A S H',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                color: AppColors.white,
                fontSize: 36,
                letterSpacing: 12,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'BY HIBAASHIR',
              style: TextStyle(
                color: AppColors.secondary,
                fontSize: 10,
                letterSpacing: 8,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          'LADIES MODEST WEAR',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            letterSpacing: 4,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
        const SizedBox(height: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _policyItem('NO REFUND OR EXCHANGE'),
            const SizedBox(height: 8),
            _policyItem('UNBOXING VIDEO REQUIRED FOR CLAIMS'),
          ],
        ),
        const SizedBox(height: 40),
        Row(
          children: ['IG', 'WA'].map((s) {
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

  Widget _buildFooterLinks(String title, List<String> links) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 11,
            letterSpacing: 4,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 32),
        ...links.map(
          (l) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              l,
              style: const TextStyle(
                color: AppColors.textBody,
                fontSize: 11,
                letterSpacing: 1,
              ),
            ),
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

  Widget _policyItem(String text) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 4,
          decoration: const BoxDecoration(
            color: AppColors.secondary,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            color: AppColors.textBody,
            fontSize: 12,
            letterSpacing: 2,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

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
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontSize: 40,
                        letterSpacing: 2,
                      ),
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
