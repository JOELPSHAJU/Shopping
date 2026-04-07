import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/cart/presentation/pages/cart_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/product/presentation/pages/product_list_page.dart';
import '../../features/product/presentation/pages/product_detail_page.dart';
import '../../features/product/presentation/pages/brand_page.dart';
import '../../features/favourites/presentation/pages/favourites_page.dart';
import '../../features/checkout/presentation/pages/checkout_page.dart';
import '../../features/help_center/presentation/pages/help_center_page.dart';
import '../../features/comparison/presentation/pages/comparison_page.dart';
import '../../features/home/presentation/pages/archive_page.dart';
import '../../features/home/presentation/pages/collection_page.dart';
// import '../../features/profile/presentation/pages/order_details_page.dart';
import '../presentation/pages/main_layout_page.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainLayoutPage(navigationShell: navigationShell);
        },
        branches: [
          // HOME BRANCH
          StatefulShellBranch(
            routes: [
              GoRoute(path: '/', builder: (context, state) => const HomePage()),
              GoRoute(
                path: '/help-center',
                builder: (context, state) => const HelpCenterPage(),
              ),
              GoRoute(
                path: '/comparison',
                builder: (context, state) => const ComparisonPage(),
              ),
              GoRoute(
                path: '/archive',
                builder: (context, state) => const ArchivePage(),
              ),
              GoRoute(
                path: '/collection/:id',
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return CollectionPage(collectionId: id);
                },
              ),
            ],
          ),
          // PRODUCTS BRANCH
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/products',
                builder: (context, state) => const ProductListPage(),
              ),
              GoRoute(
                path: '/product/:id',
                builder: (context, state) {
                  final id = state.pathParameters['id']!;
                  return ProductDetailPage(productId: id);
                },
              ),
              GoRoute(
                path: '/brand/:name',
                builder: (context, state) {
                  final name = state.pathParameters['name']!;
                  return BrandPage(brand: name);
                },
              ),
            ],
          ),
          // CART BRANCH
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/cart',
                builder: (context, state) => const CartPage(),
              ),
              GoRoute(
                path: '/checkout',
                builder: (context, state) => const CheckoutPage(),
              ),
            ],
          ),
          // FAVOURITES BRANCH
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/favourites',
                builder: (context, state) => const FavouritesPage(),
              ),
            ],
          ),
          // PROFILE BRANCH
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfilePage(),
                routes: [
                  // GoRoute(
                  //   path: 'order-details/:id',
                  //   builder: (context, state) {
                  //     final id = state.pathParameters['id']!;
                  //     return OrderDetailsPage(orderId: id);
                  //   },
                  // ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
