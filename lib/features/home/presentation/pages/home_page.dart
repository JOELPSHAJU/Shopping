import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/home_providers.dart';

import '../../../product/domain/product.dart';
import 'package:go_router/go_router.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 800;

    final selectedCategory = ref.watch(selectedCategoryProvider);
    final products = ref.watch(filteredProductsProvider);
    final favorites = ref.watch(favoritesProvider);
    final favoriteProducts = mockProducts
        .where((p) => favorites.contains(p.id))
        .toList();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = Theme.of(context).scaffoldBackgroundColor;
    final fg = isDark ? Colors.white : Colors.black;
    final fgMuted = isDark ? AppColors.textBody : AppColors.lightTextBody;
    final borderColor = isDark ? AppColors.cardLight : AppColors.lightBorder;

    final banner = ref.watch(homeBannerProvider);

    return Scaffold(
      backgroundColor: bg,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Hero Banner ──────────────────────────────────────────────
            _buildHero(context, isDesktop, bg, fg, fgMuted, banner),

            // ── Marquee Brand Strip ──────────────────────────────────────
            _buildBrandStrip(context, bg, fg),

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
                                      color: isSel ? fg : Colors.transparent,
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
                                    color: isSel ? fg : fgMuted,
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
            _buildEditorialBanner(context, isDesktop, bg, fg),

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
                  _buildDefaultFavourites(context, isDesktop),
                ],
              ),
            ),

            if (ref.watch(newsletterStatusProvider) != NewsletterStatus.success)
              _buildJoin(context, isDesktop, bg, fg, fgMuted, borderColor),

            _buildFooter(context, isDesktop, bg, fg, fgMuted),
          ],
        ),
      ),
    );
  }

  Widget _buildHero(
    BuildContext context,
    bool isDesktop,
    Color bg,
    Color fg,
    Color fgMuted,
    dynamic banner,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: double.infinity,
      height: isDesktop ? 720 : 600,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            banner.imageAsset,
            fit: BoxFit.cover,
            color: isDark
                ? Colors.black.withValues(alpha: 0.35)
                : Colors.white.withValues(alpha: 0.15),
            colorBlendMode: isDark ? BlendMode.darken : BlendMode.lighten,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [bg, bg.withValues(alpha: 0.0)],
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
                      banner.title,
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontSize: isDesktop ? 88 : 56,
                        height: 1.0,
                        letterSpacing: 4,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 440),
                      child: Text(
                        banner.description,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          height: 1.8,
                          color: fgMuted,
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () => context.push(
                            '/collection/${banner.collectionId}',
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: fg,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 48,
                              vertical: 20,
                            ),
                            elevation: 0,
                            shape: const ContinuousRectangleBorder(),
                          ),
                          child: Text(
                            'SHOP NOW',
                            style: TextStyle(
                              color: bg,
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

  Widget _buildBrandStrip(BuildContext context, Color bg, Color fg) {
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
      decoration: BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(color: fg.withValues(alpha: 0.1), width: 1),
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
                            style: TextStyle(
                              color: fg,
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
    Product product, {
    required double height,
    required double width,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fg = isDark ? Colors.white : Colors.black;
    final fgMuted = isDark ? AppColors.textBody : AppColors.lightTextBody;
    final cardBg = isDark ? AppColors.cardDark : AppColors.lightCard;

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
      ),
    );
  }

  Widget _buildDefaultFavourites(
    BuildContext context,
    bool isDesktop,
  ) {
    final products = mockProducts.take(3).toList();
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: products.map((p) {
          return Padding(
            padding: const EdgeInsets.only(right: 32),
            child: _buildProductCard(context, p, height: 440, width: 300),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildJoin(
    BuildContext context,
    bool isDesktop,
    Color bg,
    Color fg,
    Color fgMuted,
    Color borderColor,
  ) {
    final status = ref.watch(newsletterStatusProvider);

    return _buildConstrainedSection(
      key: const ValueKey('newsletter_section'),
      paddingVertical: 120,
      backgroundColor: isDesktop
          ? (Theme.of(context).brightness == Brightness.dark
                ? const Color(0xFF111111)
                : AppColors.lightCard)
          : bg,
      child: Column(
        children: [
          Text(
            'JOIN THE WORLD OF FATHASH',
            style: TextStyle(
              color: fg,
              fontSize: 12,
              letterSpacing: 8,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 48),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: TextField(
                controller: _emailController,
                style: TextStyle(color: fg),
                enabled: status != NewsletterStatus.loading,
                decoration: InputDecoration(
                  hintText: 'YOUR EMAIL ADDRESS',
                  hintStyle: TextStyle(
                    color: fgMuted,
                    fontSize: 11,
                    letterSpacing: 4,
                  ),
                  errorText: status == NewsletterStatus.error ? 'PLEASE ENTER A VALID EMAIL' : null,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: borderColor),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: fg),
                  ),
                  suffixIcon: status == NewsletterStatus.loading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: CircularProgressIndicator(strokeWidth: 1),
                          ),
                        )
                      : TextButton(
                          onPressed: () async {
                            final email = _emailController.text;
                            // Unfocus BEFORE starting the action to avoid DWDS errors
                            FocusManager.instance.primaryFocus?.unfocus();
                            
                            await ref.read(newsletterProvider).join(email);

                            if (mounted && ref.read(newsletterStatusProvider) == NewsletterStatus.success) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  backgroundColor: bg,
                                  shape: const ContinuousRectangleBorder(),
                                  title: Text(
                                    'WELCOME TO FATHASH',
                                    style: TextStyle(
                                      color: fg,
                                      fontSize: 14,
                                      letterSpacing: 4,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                  content: Text(
                                    'A confirmation email has been sent to $email.\n\nEnjoy exclusive access to our newest collections and archival showpieces.',
                                    style: TextStyle(
                                      color: fgMuted,
                                      fontSize: 13,
                                      height: 1.6,
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text(
                                        'START SHOPPING',
                                        style: TextStyle(
                                          color: fg,
                                          fontSize: 11,
                                          letterSpacing: 2,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                          child: Text(
                            'JOIN',
                            style: TextStyle(color: fg, fontSize: 11, letterSpacing: 2),
                          ),
                        ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFooter(
    BuildContext context,
    bool isDesktop,
    Color bg,
    Color fg,
    Color fgMuted,
  ) {
    return _buildConstrainedSection(
      paddingVertical: 120,
      backgroundColor: bg,
      child: isDesktop
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: _buildFooterBrand(context, bg, fg, fgMuted),
                ),
                _buildFooterLinks(
                  context,
                  'BOUTIQUE',
                  ['All Dresses', 'Latest Picks', 'Archives'],
                  fg,
                  fgMuted,
                ),
                const SizedBox(width: 80),
                _buildFooterLinks(
                  context,
                  'SUPPORT',
                  ['Shipping & T&C', 'Help Center', 'Payment'],
                  fg,
                  fgMuted,
                ),
                const SizedBox(width: 80),
                _buildFooterLinks(
                  context,
                  'CONTACT',
                  ['Instagram', 'Business Inquiry', 'WhatsApp'],
                  fg,
                  fgMuted,
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFooterBrand(context, bg, fg, fgMuted),
                const SizedBox(height: 80),
                Wrap(
                  spacing: 40,
                  runSpacing: 48,
                  crossAxisAlignment: WrapCrossAlignment.start,
                  children: [
                    _buildFooterLinks(
                      context,
                      'BOUTIQUE',
                      ['Dresses', 'Latest'],
                      fg,
                      fgMuted,
                    ),
                    _buildFooterLinks(
                      context,
                      'SUPPORT',
                      ['T&C', 'Policy'],
                      fg,
                      fgMuted,
                    ),
                    _buildFooterLinks(
                      context,
                      'SOCIAL',
                      ['IG', 'WA'],
                      fg,
                      fgMuted,
                    ),
                  ],
                ),
              ],
            ),
    );
  }

  Widget _buildFooterBrand(
    BuildContext context,
    Color bg,
    Color fg,
    Color fgMuted,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'F A T H A S H',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                color: fg,
                fontSize: 36,
                letterSpacing: 12,
              ),
            ),
            const SizedBox(height: 8),
            Text(
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
            color: fg,
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

  Widget _buildFooterLinks(
    BuildContext context,
    String title,
    List<String> links,
    Color fg,
    Color fgMuted,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: fg,
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
              style: TextStyle(color: fgMuted, fontSize: 11, letterSpacing: 1),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConstrainedSection({
    Key? key,
    required Widget child,
    required double paddingVertical,
    Color? backgroundColor,
  }) {
    return Container(
      key: key,
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

  Widget _buildEditorialBanner(
    BuildContext context,
    bool isDesktop,
    Color bg,
    Color fg,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.cardDark : AppColors.lightCard;
    final fgMuted = isDark ? AppColors.textBody : AppColors.lightTextBody;

    return Container(
      width: double.infinity,
      color: cardBg,
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
                        'assets/images/adv1.jpg',
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
                                  color: fg,
                                ),
                          ),
                          const SizedBox(height: 32),
                          Text(
                            'For a limited time, acquire select archival showpieces at an unprecedented price adjustment.',
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(height: 1.8, color: fgMuted),
                          ),
                          const SizedBox(height: 56),
                          ElevatedButton(
                            onPressed: () => context.push('/archive'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: fg,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 48,
                                vertical: 20,
                              ),
                              elevation: 0,
                              shape: const ContinuousRectangleBorder(),
                            ),
                            child: Text(
                              'ENTER ARCHIVE',
                              style: TextStyle(
                                color: bg,
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
                    'assets/images/adv1.jpg',
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
                            ?.copyWith(
                              fontSize: 40,
                              letterSpacing: 2,
                              color: fg,
                            ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Acquire select archival showpieces at an unprecedented price adjustment.',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          height: 1.8,
                          color: fgMuted,
                        ),
                      ),
                      const SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: () => context.push('/archive'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: fg,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 18,
                          ),
                          elevation: 0,
                          shape: const ContinuousRectangleBorder(),
                        ),
                        child: Text(
                          'ENTER ARCHIVE',
                          style: TextStyle(
                            color: bg,
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
}
