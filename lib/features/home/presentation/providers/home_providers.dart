import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../product/domain/product.dart';

// FATHASH Product Catalog — Ladies Modest Wear
final List<Product> mockProducts = [
  // ── COTTON SET ────────────────────────────────────────────────────────────
  _m(
    '1',
    'Classic Cotton Set',
    1850,
    'READY-TO-WEAR',
    'COTTON SET',
    'dress_navy_01.webp',
  ),
  _m(
    '1a',
    'Eco-Cotton Lounge Set',
    1650,
    'READY-TO-WEAR',
    'COTTON SET',
    'dress_shift_01.webp',
  ),
  _m(
    '1b',
    'Floral Cotton Co-ord',
    1950,
    'READY-TO-WEAR',
    'COTTON SET',
    'dress_collab_01.webp',
  ),

  // ── PARTY WEAR ────────────────────────────────────────────────────────────
  _m(
    '2',
    'Evening Party Gown',
    3250,
    'GOWNS',
    'PARTY WEAR',
    'dress_maxi_01.jpg',
  ),
  _m(
    '2a',
    'Sequin Jubilee Dress',
    4500,
    'GOWNS',
    'PARTY WEAR',
    'dress_midi_01.jpg',
  ),
  _m(
    '2b',
    'Midnight Gala Gown',
    5200,
    'GOWNS',
    'PARTY WEAR',
    'dress_hero.webp',
  ),

  // ── GOWN ───────────────────────────────────────────────────────────────────
  _m('3', 'Elegant Velvet Gown', 4200, 'GOWNS', 'GOWN', 'dress_midi_01.jpg'),
  _m('3a', 'Chiffon Flow Gown', 3100, 'GOWNS', 'GOWN', 'dress_maxi_01.jpg'),
  _m(
    '3b',
    'Embroidered Satin Gown',
    4800,
    'GOWNS',
    'GOWN',
    'dress_navy_01.webp',
  ),

  // ── CO-ORD SET ─────────────────────────────────────────────────────────────
  _m(
    '4',
    'Urban Co-ord Set',
    1450,
    'READY-TO-WEAR',
    'CO-ORD SET',
    'dress_shift_01.webp',
  ),
  _m(
    '4a',
    'Linen Minimalist Co-ord',
    2200,
    'READY-TO-WEAR',
    'CO-ORD SET',
    'dress_collab_01.webp',
  ),
  _m(
    '4b',
    'Pleated Evening Co-ord',
    2600,
    'READY-TO-WEAR',
    'CO-ORD SET',
    'dress_graphic_01.jpg',
  ),

  // ── LONG KURTHI ────────────────────────────────────────────────────────────
  _m(
    '5',
    'Floral Long Kurthi',
    1100,
    'READY-TO-WEAR',
    'LONG KURTHI',
    'dress_collab_01.webp',
  ),
  _m(
    '5a',
    'A-Line Heritage Kurthi',
    1350,
    'READY-TO-WEAR',
    'LONG KURTHI',
    'dress_fleece_01.jpg',
  ),
  _m(
    '5b',
    'Modern Pastel Kurthi',
    1200,
    'READY-TO-WEAR',
    'LONG KURTHI',
    'dress_cobalt_01.webp',
  ),

  // ── KAFTHAN GOWN ──────────────────────────────────────────────────────────
  _m(
    '6',
    'Silk Kafthan Gown',
    2750,
    'GOWNS',
    'KAFTHAN GOWN',
    'dress_graphic_01.jpg',
  ),
  _m(
    '6a',
    'Moroccan Style Kafthan',
    3400,
    'GOWNS',
    'KAFTHAN GOWN',
    'dress_maxi_01.jpg',
  ),
  _m(
    '6b',
    'Ombre Desert Kafthan',
    2900,
    'GOWNS',
    'KAFTHAN GOWN',
    'dress_hero.webp',
  ),

  // ── ROMPER ─────────────────────────────────────────────────────────────────
  _m(
    '7',
    'Modern Utility Romper',
    980,
    'READY-TO-WEAR',
    'ROMPER',
    'dress_fleece_01.jpg',
  ),
  _m(
    '7a',
    'Casual Day Romper',
    850,
    'READY-TO-WEAR',
    'ROMPER',
    'dress_graphic_01.jpg',
  ),
  _m(
    '7b',
    'Belted Linen Romper',
    1250,
    'READY-TO-WEAR',
    'ROMPER',
    'dress_shift_01.webp',
  ),

  // ── WESTERN GOWN ──────────────────────────────────────────────────────────
  _m(
    '8',
    'Satin Western Gown',
    3920,
    'GOWNS',
    'WESTERN GOWN',
    'dress_navy_01.webp',
  ),
  _m(
    '8a',
    'Editorial Slit Gown',
    4100,
    'GOWNS',
    'WESTERN GOWN',
    'dress_hero.webp',
  ),
  _m(
    '8b',
    'Avant-Garde Drape Gown',
    5500,
    'GOWNS',
    'WESTERN GOWN',
    'dress_midi_01.jpg',
  ),

  // ── DENIM GOWN ────────────────────────────────────────────────────────────
  _m('9', 'Rugged Denim Gown', 2800, 'GOWNS', 'DENIM GOWN', 'dress_hero.webp'),
  _m(
    '9a',
    'Patchwork Denim Gown',
    3200,
    'GOWNS',
    'DENIM GOWN',
    'dress_fleece_01.jpg',
  ),
  _m(
    '9b',
    'Stitched Indigo Gown',
    2950,
    'GOWNS',
    'DENIM GOWN',
    'dress_navy_01.webp',
  ),

  // ── SHORT KURTI ───────────────────────────────────────────────────────────
  _m(
    '10',
    'Casual Short Kurti',
    850,
    'READY-TO-WEAR',
    'SHORT KURTI',
    'dress_cobalt_01.webp',
  ),
  _m(
    '10a',
    'Embroidered Daily Kurti',
    950,
    'READY-TO-WEAR',
    'SHORT KURTI',
    'dress_collab_01.webp',
  ),
  _m(
    '10b',
    'Printed Summer Kurti',
    780,
    'READY-TO-WEAR',
    'SHORT KURTI',
    'dress_graphic_01.jpg',
  ),

  // ── KAFTHAN ────────────────────────────────────────────────────────────────
  _m(
    '11',
    'Kafthan Comfort Dress',
    1650,
    'READY-TO-WEAR',
    'KAFTHAN',
    'dress_cobalt_02.webp',
  ),
  _m(
    '11a',
    'Beachside Light Kafthan',
    1400,
    'READY-TO-WEAR',
    'KAFTHAN',
    'dress_shift_01.webp',
  ),
  _m(
    '11b',
    'Embellished Evening Kafthan',
    2100,
    'READY-TO-WEAR',
    'KAFTHAN',
    'dress_maxi_01.jpg',
  ),

  // ── PAKISTHANI SUIT ────────────────────────────────────────────────────────
  _m(
    '12',
    'Pakisthani Formal Suit',
    4500,
    'SUITS',
    'PAKISTHANI SUIT',
    'dress_maxi_01.jpg',
  ),
  _m(
    '12a',
    'Luxury Lawn Suit',
    5800,
    'SUITS',
    'PAKISTHANI SUIT',
    'dress_hero.webp',
  ),
  _m(
    '12b',
    'Artisanal Chiffon Suit',
    6200,
    'SUITS',
    'PAKISTHANI SUIT',
    'dress_midi_01.jpg',
  ),

  // ── DENIM CORD SET ─────────────────────────────────────────────────────────
  _m(
    '13',
    'Denim Cord Set',
    1950,
    'READY-TO-WEAR',
    'DENIM CORD SET',
    'dress_shift_01.webp',
  ),
  _m(
    '13a',
    'Indigo Wash Cord Set',
    2100,
    'READY-TO-WEAR',
    'DENIM CORD SET',
    'dress_navy_01.webp',
  ),
  _m(
    '13b',
    'Rigid Utility Cord Set',
    2400,
    'READY-TO-WEAR',
    'DENIM CORD SET',
    'dress_fleece_01.jpg',
  ),

  // ── KNEE LENGTH DENIM ──────────────────────────────────────────────────────
  _m(
    '14',
    'Knee Length Denim Dress',
    1350,
    'READY-TO-WEAR',
    'KNEE LENGTH DENIM',
    'dress_fleece_01.jpg',
  ),
  _m(
    '14a',
    'Frilled Denim Midi',
    1550,
    'READY-TO-WEAR',
    'KNEE LENGTH DENIM',
    'dress_graphic_01.jpg',
  ),
  _m(
    '14b',
    'Button-Down Denim Dress',
    1420,
    'READY-TO-WEAR',
    'KNEE LENGTH DENIM',
    'dress_cobalt_02.webp',
  ),

  // ── KNEE LENGTH TOP ───────────────────────────────────────────────────────
  _m(
    '15',
    'Classic Knee Length Top',
    1150,
    'TOPS',
    'KNEE LENGTH TOP',
    'dress_shift_01.webp',
  ),
  _m(
    '15a',
    'A-Line Tunic Top',
    1250,
    'TOPS',
    'KNEE LENGTH TOP',
    'dress_collab_01.webp',
  ),
  _m(
    '15b',
    'Embroidered Long Top',
    1600,
    'TOPS',
    'KNEE LENGTH TOP',
    'dress_fleece_01.jpg',
  ),

  // ── DENIM ROMPER ──────────────────────────────────────────────────────────
  _m(
    '16',
    'Denim Utility Romper',
    1850,
    'READY-TO-WEAR',
    'DENIM ROMPER',
    'dress_fleece_01.jpg',
  ),
  _m(
    '16a',
    'Light Wash Denim Romper',
    1700,
    'READY-TO-WEAR',
    'DENIM ROMPER',
    'dress_navy_01.webp',
  ),
  _m(
    '16b',
    'Indigo Zip Romper',
    1950,
    'READY-TO-WEAR',
    'DENIM ROMPER',
    'dress_shift_01.webp',
  ),

  // ── WESTERN LONGTOP ───────────────────────────────────────────────────────
  _m(
    '17',
    'Western Longtop Dress',
    2200,
    'TOPS',
    'WESTERN LONGTOP',
    'dress_graphic_01.jpg',
  ),
  _m(
    '17a',
    'Collared Longtop',
    1900,
    'TOPS',
    'WESTERN LONGTOP',
    'dress_cobalt_01.webp',
  ),
  _m(
    '17b',
    'Belted Western Top',
    2400,
    'TOPS',
    'WESTERN LONGTOP',
    'dress_maxi_01.jpg',
  ),

  // ── LONG CO-CORD SET ──────────────────────────────────────────────────────
  _m(
    '18',
    'Premium Long Co-ord',
    3200,
    'READY-TO-WEAR',
    'LONG CO-CORD SET',
    'dress_navy_01.webp',
  ),
  _m(
    '18a',
    'Silk Long Co-ord',
    3800,
    'READY-TO-WEAR',
    'LONG CO-CORD SET',
    'dress_midi_01.jpg',
  ),
  _m(
    '18b',
    'Crepe Long Co-ord Set',
    3500,
    'READY-TO-WEAR',
    'LONG CO-CORD SET',
    'dress_hero.webp',
  ),

  // ── SHORT TOPS ────────────────────────────────────────────────────────────
  _m(
    '19',
    'Minimalist Short Top',
    850,
    'TOPS',
    'SHORT TOPS',
    'dress_cobalt_01.webp',
  ),
  _m(
    '19a',
    'Daily Wear Short Top',
    700,
    'TOPS',
    'SHORT TOPS',
    'dress_collab_01.webp',
  ),
  _m(
    '19b',
    'Cropped Ethnic Top',
    950,
    'TOPS',
    'SHORT TOPS',
    'dress_shift_01.webp',
  ),
];

// Helper to shorten the product creation
Product _m(
  String id,
  String name,
  double price,
  String cat,
  String brand,
  String asset,
) {
  return Product(
    id: id,
    name: name,
    price: price,
    rating: 4.5 + (id.length % 5) * 0.1,
    category: cat,
    brand: brand,
    imageAsset: 'assets/images/$asset',
  );
}

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
