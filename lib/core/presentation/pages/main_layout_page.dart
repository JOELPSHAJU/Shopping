import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';

class MainLayoutPage extends StatelessWidget {
  const MainLayoutPage({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildResponsiveHeader(context, isDesktop),
          Expanded(child: navigationShell),
        ],
      ),
      bottomNavigationBar: isDesktop
          ? null
          : BottomNavigationBar(
              currentIndex: navigationShell.currentIndex,
              onTap: (index) => _onTap(context, index),
              type: BottomNavigationBarType.fixed,
              backgroundColor: AppColors.background,
              selectedItemColor: AppColors.primary,
              unselectedItemColor: AppColors.textBody,
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

  Widget _buildResponsiveHeader(BuildContext context, bool isDesktop) {
    return Container(
      width: double.infinity,
      color: AppColors.background,
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => _onTap(context, 0),
                  child: Text(
                    'A U R A',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontSize: 32,
                      letterSpacing: 12,
                      fontWeight: FontWeight.w300,
                      color: AppColors.white,
                    ),
                  ),
                ),
                if (isDesktop)
                  Row(
                    children: [
                      _buildNavText(context, 'COLLECTIONS', 0),
                      const SizedBox(width: 48),
                      _buildNavText(context, 'PRODUCTS', 1),
                      const SizedBox(width: 48),
                      GestureDetector(
                        onTap: () => _onTap(context, 2),
                        child: Icon(
                          CupertinoIcons.cart,
                          size: 24,
                          color: _iconColor(2),
                        ),
                      ),
                      const SizedBox(width: 32),
                      GestureDetector(
                        onTap: () => _onTap(context, 3),
                        child: Icon(
                          CupertinoIcons.heart,
                          size: 24,
                          color: _iconColor(3),
                        ),
                      ),
                      const SizedBox(width: 32),
                      GestureDetector(
                        onTap: () => _onTap(context, 4),
                        child: Icon(
                          CupertinoIcons.person,
                          size: 24,
                          color: _iconColor(4),
                        ),
                      ),
                    ],
                  )
                else
                  const Icon(
                    CupertinoIcons.bars,
                    size: 24,
                    color: AppColors.primary,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavText(BuildContext context, String text, int index) {
    final isSelected = navigationShell.currentIndex == index;
    return GestureDetector(
      onTap: () => _onTap(context, index),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w300,
          fontSize: 13,
          letterSpacing: 4,
          color: isSelected ? AppColors.white : AppColors.textBody,
        ),
      ),
    );
  }

  Color _iconColor(int index) {
    return navigationShell.currentIndex == index
        ? AppColors.white
        : AppColors.textBody;
  }
}
