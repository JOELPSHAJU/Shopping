import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/theme_provider.dart';

class MainLayoutPage extends ConsumerWidget {
  const MainLayoutPage({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: true,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDesktop = MediaQuery.of(context).size.width > 800;
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;

    // Adaptive colors based on theme
    final bg = isDark ? AppColors.background : const Color(0xFFF8F5F0);
    final fg = isDark ? AppColors.white : const Color(0xFF1A1A1A);
    final fgMuted = isDark ? AppColors.textBody : const Color(0xFF888480);

    return Scaffold(
      backgroundColor: bg,
      body: Column(
        children: [
          _buildHeader(context, ref, isDesktop, isDark, bg, fg, fgMuted),
          Expanded(child: navigationShell),
        ],
      ),
      bottomNavigationBar: isDesktop
          ? null
          : BottomNavigationBar(
              currentIndex: navigationShell.currentIndex,
              onTap: (index) => _onTap(context, index),
              type: BottomNavigationBarType.fixed,
              backgroundColor: bg,
              selectedItemColor: fg,
              unselectedItemColor: fgMuted,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.square_grid_2x2),
                  label: 'Products',
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.cart),
                  label: 'Cart',
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.heart),
                  label: 'Favourites',
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.person),
                  label: 'Profile',
                ),
              ],
            ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    WidgetRef ref,
    bool isDesktop,
    bool isDark,
    Color bg,
    Color fg,
    Color fgMuted,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28),
      decoration: BoxDecoration(
        color: bg,
        border: Border(
          bottom: BorderSide(
            color: fgMuted.withValues(alpha: 0.15),
            width: 0.5,
          ),
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Brand wordmark
                GestureDetector(
                  onTap: () => _onTap(context, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'F A T H A S H',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: isDesktop ? 22 : 18,
                          letterSpacing: isDesktop ? 8 : 4,
                          fontWeight: FontWeight.w300,
                          color: fg,
                        ),
                      ),
                      Text(
                        'BY HIBAASHIR',
                        style: TextStyle(
                          fontSize: 7,
                          letterSpacing: 4,
                          fontWeight: FontWeight.bold,
                          color: fgMuted.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                if (isDesktop)
                  Row(
                    children: [
                      _navText('HOME', 0, fg, fgMuted, context),
                      const SizedBox(width: 48),
                      _navText('PRODUCTS', 1, fg, fgMuted, context),
                      const SizedBox(width: 48),
                      // Cart icon
                      GestureDetector(
                        onTap: () => _onTap(context, 2),
                        child: Icon(
                          CupertinoIcons.cart,
                          size: 22,
                          color: navigationShell.currentIndex == 2
                              ? fg
                              : fgMuted,
                        ),
                      ),
                      const SizedBox(width: 28),
                      // Favourites icon
                      GestureDetector(
                        onTap: () => _onTap(context, 3),
                        child: Icon(
                          CupertinoIcons.heart,
                          size: 22,
                          color: navigationShell.currentIndex == 3
                              ? fg
                              : fgMuted,
                        ),
                      ),
                      const SizedBox(width: 28),
                      // Profile icon
                      GestureDetector(
                        onTap: () => _onTap(context, 4),
                        child: Icon(
                          CupertinoIcons.person,
                          size: 22,
                          color: navigationShell.currentIndex == 4
                              ? fg
                              : fgMuted,
                        ),
                      ),
                      const SizedBox(width: 28),
                      // ── THEME TOGGLE ──
                      GestureDetector(
                        onTap: () {
                          ref.read(themeModeProvider.notifier).state = isDark
                              ? ThemeMode.light
                              : ThemeMode.dark;
                        },
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder: (child, anim) =>
                              RotationTransition(
                                turns: anim,
                                child: FadeTransition(
                                  opacity: anim,
                                  child: child,
                                ),
                              ),
                          child: Icon(
                            isDark
                                ? CupertinoIcons.sun_max
                                : CupertinoIcons.moon_stars,
                            key: ValueKey(isDark),
                            size: 22,
                            color: fgMuted,
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  Row(
                    children: [
                      // Mobile theme toggle
                      GestureDetector(
                        onTap: () {
                          ref.read(themeModeProvider.notifier).state = isDark
                              ? ThemeMode.light
                              : ThemeMode.dark;
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: Icon(
                              isDark
                                  ? CupertinoIcons.sun_max
                                  : CupertinoIcons.moon_stars,
                              key: ValueKey(isDark),
                              size: 22,
                              color: fgMuted,
                            ),
                          ),
                        ),
                      ),
                      Icon(CupertinoIcons.bars, size: 24, color: fg),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navText(
    String text,
    int index,
    Color fg,
    Color fgMuted,
    BuildContext context,
  ) {
    final isSelected = navigationShell.currentIndex == index;
    return GestureDetector(
      onTap: () => _onTap(context, index),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: isSelected ? FontWeight.w500 : FontWeight.w300,
          fontSize: 12,
          letterSpacing: 4,
          color: isSelected ? fg : fgMuted,
        ),
      ),
    );
  }
}
