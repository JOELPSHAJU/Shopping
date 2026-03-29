import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../product/domain/product.dart';

class CartItem {
  final Product product;
  final int quantity;
  final String size;

  CartItem({required this.product, required this.quantity, required this.size});

  CartItem copyWith({Product? product, int? quantity, String? size}) {
    return CartItem(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      size: size ?? this.size,
    );
  }
}

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void add(Product product, {String size = 'M'}) {
    final existingIndex = state.indexWhere(
      (item) => item.product.id == product.id && item.size == size,
    );
    if (existingIndex >= 0) {
      final updated = [...state];
      updated[existingIndex] = updated[existingIndex].copyWith(
        quantity: updated[existingIndex].quantity + 1,
      );
      state = updated;
    } else {
      state = [...state, CartItem(product: product, quantity: 1, size: size)];
    }
  }

  void remove(Product product, {String size = 'M'}) {
    final existingIndex = state.indexWhere(
      (item) => item.product.id == product.id && item.size == size,
    );
    if (existingIndex >= 0) {
      final updated = [...state];
      if (updated[existingIndex].quantity > 1) {
        updated[existingIndex] = updated[existingIndex].copyWith(
          quantity: updated[existingIndex].quantity - 1,
        );
        state = updated;
      } else {
        updated.removeAt(existingIndex);
        state = updated;
      }
    }
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});

final cartTotalProvider = Provider<double>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.fold(
    0.0,
    (sum, item) => sum + (item.product.price * item.quantity),
  );
});
