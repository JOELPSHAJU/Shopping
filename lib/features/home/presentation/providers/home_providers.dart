import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../product/domain/product.dart';

// High Fashion Dress Catalog — mapped to clean asset filenames
final List<Product> mockProducts = [
  Product(
    id: '1',
    name: 'Navy Structured Blazer Dress',
    price: 2450.0,
    rating: 5.0,
    category: 'Ready-To-Wear',
    brand: 'AURA',
    imageAsset: 'assets/images/dress_navy_01.webp',
  ),
  Product(
    id: '2',
    name: 'Classic Solid Maxi Dress',
    price: 1250.0,
    rating: 4.8,
    category: 'Gowns',
    brand: 'AURA',
    imageAsset: 'assets/images/dress_maxi_01.jpg',
  ),
  Product(
    id: '3',
    name: 'Draped Midi Evening Gown',
    price: 4200.0,
    rating: 4.9,
    category: 'Gowns',
    brand: 'VORTEX',
    imageAsset: 'assets/images/dress_midi_01.jpg',
  ),
  Product(
    id: '4',
    name: 'Minimal Capsule Shift Dress',
    price: 850.0,
    rating: 4.5,
    category: 'Ready-To-Wear',
    brand: 'AURA',
    imageAsset: 'assets/images/dress_shift_01.webp',
  ),
  Product(
    id: '5',
    name: 'Limited Edition Collab Dress',
    price: 3100.0,
    rating: 4.7,
    category: 'Ready-To-Wear',
    brand: 'VELVET',
    imageAsset: 'assets/images/dress_collab_01.webp',
  ),
  Product(
    id: '6',
    name: 'Relaxed Graphic Sweat Dress',
    price: 750.0,
    rating: 4.6,
    category: 'Ready-To-Wear',
    brand: 'AURA',
    imageAsset: 'assets/images/dress_graphic_01.jpg',
  ),
  Product(
    id: '7',
    name: 'Heritage Fleece Layer Dress',
    price: 980.0,
    rating: 5.0,
    category: 'Ready-To-Wear',
    brand: 'VORTEX',
    imageAsset: 'assets/images/dress_fleece_01.jpg',
  ),
  Product(
    id: '8',
    name: 'Navy Double-Breast Midi',
    price: 1920.0,
    rating: 4.8,
    category: 'Bridal',
    brand: 'VELVET',
    imageAsset: 'assets/images/dress_navy_01.webp',
  ),
  Product(
    id: '9',
    name: 'Editorial Campaign Gown',
    price: 5800.0,
    rating: 5.0,
    category: 'Bridal',
    brand: 'AURA',
    imageAsset: 'assets/images/dress_hero.webp',
  ),
  Product(
    id: '10',
    name: 'Cobalt Bold Shoulder Dress',
    price: 1400.0,
    rating: 4.7,
    category: 'Ready-To-Wear',
    brand: 'AURA',
    imageAsset: 'assets/images/dress_cobalt_01.webp',
  ),
  Product(
    id: '11',
    name: 'Cobalt Statement A-Line',
    price: 1650.0,
    rating: 4.9,
    category: 'Gowns',
    brand: 'VELVET',
    imageAsset: 'assets/images/dress_cobalt_02.webp',
  ),
];

// Selected Category State
final selectedCategoryProvider = StateProvider<String>((ref) => 'All');

// Filtered Products
final filteredProductsProvider = Provider<List<Product>>((ref) {
  final category = ref.watch(selectedCategoryProvider);
  if (category == 'All') return mockProducts;
  return mockProducts.where((p) => p.category == category).toList();
});

// Favorites State
final favoritesProvider = StateNotifierProvider<FavoritesNotifier, Set<String>>(
  (ref) {
    return FavoritesNotifier();
  },
);

class FavoritesNotifier extends StateNotifier<Set<String>> {
  FavoritesNotifier() : super({});

  void toggle(String productId) {
    if (state.contains(productId)) {
      state = {
        for (final id in state)
          if (id != productId) id,
      };
    } else {
      state = {...state, productId};
    }
  }
}
