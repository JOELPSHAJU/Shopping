import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/cart_provider.dart';

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.background : AppColors.lightBackground;
    final cardBg = isDark ? AppColors.cardDark : AppColors.lightCard;
    final fg = isDark ? AppColors.white : AppColors.lightTextTitle;
    final fgMuted = isDark ? AppColors.textBody : AppColors.lightTextBody;
    final borderColor = isDark ? AppColors.cardLight : AppColors.lightBorder;

    final cartItems = ref.watch(cartProvider);
    final total = ref.watch(cartTotalProvider);

    return Scaffold(
      backgroundColor: bg,
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 56),

                  // Label
                  Row(
                    children: [
                      Container(
                        width: 16,
                        height: 0.5,
                        color: AppColors.accent,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'SHOPPING BAG',
                        style: TextStyle(
                          color: AppColors.accent,
                          fontSize: 11,
                          letterSpacing: 6,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Title
                  Text(
                    'Your Cart',
                    style: TextStyle(
                      color: fg,
                      fontSize: 56,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${cartItems.length} ITEMS SELECTED',
                    style: TextStyle(
                      color: fgMuted,
                      fontSize: 11,
                      letterSpacing: 4,
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.only(top: 24, bottom: 48),
                    height: 0.5,
                    color: borderColor,
                  ),

                  if (cartItems.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(120),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(CupertinoIcons.bag, size: 48, color: fgMuted),
                            const SizedBox(height: 24),
                            Text(
                              'YOUR BAG IS EMPTY',
                              style: TextStyle(
                                color: fgMuted,
                                letterSpacing: 4,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Column(
                      children: cartItems
                          .map(
                            (item) => _buildCartItem(
                              context,
                              ref,
                              item,
                              fg,
                              fgMuted,
                              borderColor,
                              cardBg,
                              isDark,
                            ),
                          )
                          .toList(),
                    ),

                  if (cartItems.isNotEmpty) ...[
                    const SizedBox(height: 48),
                    Container(height: 0.5, color: borderColor),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'TOTAL ESTIMATE',
                          style: TextStyle(
                            color: fg,
                            letterSpacing: 4,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '\$${total.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: fg,
                            fontSize: 24,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      height: 64,
                      child: OutlinedButton(
                        onPressed: () {
                          // TODO: Navigate to checkout
                        },
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: fg, width: 1),
                          shape: const RoundedRectangleBorder(),
                          backgroundColor: fg,
                        ),
                        child: Text(
                          'PROCEED TO CHECKOUT',
                          style: TextStyle(
                            color: bg,
                            fontSize: 12,
                            letterSpacing: 4,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCartItem(
    BuildContext context,
    WidgetRef ref,
    CartItem item,
    Color fg,
    Color fgMuted,
    Color borderColor,
    Color cardBg,
    bool isDark,
  ) {
    return InkWell(
      onTap: () => context.push('/product/${item.product.id}'),
      child: Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: borderColor, width: 0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          Container(
            width: 120,
            height: 160,
            color: cardBg,
            child: Icon(CupertinoIcons.scissors, color: fgMuted, size: 24),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.brand.toUpperCase(),
                  style: TextStyle(
                    color: fg,
                    fontSize: 10,
                    letterSpacing: 4,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item.product.name,
                  style: TextStyle(
                    color: fg,
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'SIZE: ${item.size}',
                  style: TextStyle(
                    color: fgMuted,
                    fontSize: 11,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    _qtyBtn(ref, item, false, fg, fgMuted),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        '${item.quantity}',
                        style: TextStyle(color: fg, fontSize: 13),
                      ),
                    ),
                    _qtyBtn(ref, item, true, fg, fgMuted),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$${(item.product.price * item.quantity).toStringAsFixed(0)}',
                style: TextStyle(color: fg, fontSize: 16, letterSpacing: 1),
              ),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: () => ref
                    .read(cartProvider.notifier)
                    .remove(item.product, size: item.size),
                child: Text(
                  'REMOVE',
                  style: TextStyle(
                    color: fgMuted,
                    fontSize: 10,
                    letterSpacing: 2,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

  Widget _qtyBtn(
    WidgetRef ref,
    CartItem item,
    bool inc,
    Color fg,
    Color fgMuted,
  ) {
    return GestureDetector(
      onTap: () {
        if (inc) {
          ref.read(cartProvider.notifier).add(item.product, size: item.size);
        } else {
          ref.read(cartProvider.notifier).remove(item.product, size: item.size);
        }
      },
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          border: Border.all(color: fgMuted.withValues(alpha: 0.3)),
        ),
        child: Icon(
          inc ? CupertinoIcons.add : CupertinoIcons.minus,
          size: 14,
          color: fg,
        ),
      ),
    );
  }
}
