import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../home/presentation/providers/home_providers.dart';
import '../providers/address_provider.dart';

class CheckoutPage extends ConsumerStatefulWidget {
  const CheckoutPage({super.key});

  @override
  ConsumerState<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends ConsumerState<CheckoutPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isAddingAddress = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.background : const Color(0xFFF8F5F0);
    final fg = isDark ? AppColors.white : const Color(0xFF1A1A1A);
    final fgMuted = isDark ? AppColors.textBody : const Color(0xFF888480);
    final borderColor = isDark ? AppColors.cardLight : const Color(0xFFDDD8D0);
    final cardBg = isDark ? AppColors.cardDark : const Color(0xFFE8E3DC);

    final addressState = ref.watch(addressProvider);
    final selectedAddress = addressState.selectedAddress;

    final product = mockProducts.first;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(CupertinoIcons.chevron_left, color: fg),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'ORDER SUMMARY',
          style: TextStyle(
            color: fg,
            fontSize: 12,
            letterSpacing: 4,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      endDrawer: _buildSidebar(
        context,
        fg,
        bg,
        fgMuted,
        borderColor,
        cardBg,
        addressState,
      ),
      onEndDrawerChanged: (isOpen) {
        if (!isOpen) {
          setState(() => _isAddingAddress = false);
        }
      },
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionHeader('DELIVERY ADDRESS', fg),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      border: Border.all(color: borderColor),
                    ),
                    child: selectedAddress == null
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'No address selected',
                                style: TextStyle(color: fgMuted, fontSize: 13),
                              ),
                              const SizedBox(height: 16),
                              TextButton(
                                onPressed: () {
                                  setState(() => _isAddingAddress = true);
                                  _scaffoldKey.currentState?.openEndDrawer();
                                },
                                child: Text(
                                  '+ ADD DELIVERY ADDRESS',
                                  style: TextStyle(
                                    color: fg,
                                    fontSize: 11,
                                    letterSpacing: 2,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    selectedAddress.name,
                                    style: TextStyle(
                                      color: fg,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 2,
                                    ),
                                    color: cardBg,
                                    child: Text(
                                      selectedAddress.type.toUpperCase(),
                                      style: TextStyle(
                                        color: fgMuted,
                                        fontSize: 9,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                selectedAddress.summary,
                                style: TextStyle(
                                  color: fgMuted,
                                  fontSize: 13,
                                  height: 1.6,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                selectedAddress.mobile,
                                style: TextStyle(color: fg, fontSize: 13),
                              ),
                              const SizedBox(height: 16),
                              TextButton(
                                onPressed: () {
                                  setState(() => _isAddingAddress = false);
                                  _scaffoldKey.currentState?.openEndDrawer();
                                },
                                child: Text(
                                  'CHANGE ADDRESS',
                                  style: TextStyle(
                                    color: fg,
                                    fontSize: 10,
                                    letterSpacing: 2,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                  const SizedBox(height: 64),
                  _sectionHeader('YOUR ITEMS', fg),
                  const SizedBox(height: 24),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: borderColor),
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 80,
                          height: 110,
                          color: cardBg,
                          child: Center(
                            child: Icon(
                              CupertinoIcons.scissors,
                              color: fgMuted,
                              size: 24,
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.brand.toUpperCase(),
                                style: TextStyle(
                                  color: fg,
                                  fontSize: 10,
                                  letterSpacing: 3,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                product.name,
                                style: TextStyle(
                                  color: fg,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                'Size: M  |  Qty: 1',
                                style: TextStyle(color: fgMuted, fontSize: 12),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                '\$${product.price.toStringAsFixed(0)}',
                                style: TextStyle(
                                  color: fg,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 64),
                  _sectionHeader('PAYMENT METHOD', fg),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      border: Border.all(color: borderColor, width: 0.5),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.account_balance_wallet_outlined,
                          size: 20,
                        ),
                        const SizedBox(width: 16),
                        Text(
                          'UPI PAYMENT',
                          style: TextStyle(
                            color: fg,
                            fontSize: 12,
                            letterSpacing: 2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.check_circle_outline,
                          color: AppColors.accent,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildStickyFooter(
        bg,
        fg,
        fgMuted,
        borderColor,
        product.price,
      ),
    );
  }

  Widget _sectionHeader(String title, Color fg) {
    return Text(
      title,
      style: TextStyle(
        color: fg,
        fontSize: 12,
        letterSpacing: 4,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  void _showPaymentModal(
    BuildContext context,
    Color fg,
    Color bg,
    Color fgMuted,
    Color borderColor,
    double price,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: bg,
      isScrollControlled: true,
      shape: const ContinuousRectangleBorder(),
      builder: (context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 64),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'PAYMENT REQUIRED',
              style: TextStyle(
                color: fg,
                fontSize: 12,
                letterSpacing: 4,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Please scan the QR code or use your UPI app to complete the transaction of \$${price.toStringAsFixed(2)}',
              textAlign: TextAlign.center,
              style: TextStyle(color: fgMuted, fontSize: 13, height: 1.6),
            ),
            const SizedBox(height: 64),
            // QR Code
            Container(
              padding: const EdgeInsets.all(24),
              color: Colors.white,
              child: QrImageView(
                data:
                    'upi://pay?pa=hibaashir@upi&pn=FATHASH&am=$price&cu=INR&mode=02',
                version: QrVersions.auto,
                size: 220.0,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'FATHASH BY HIBAASHIR',
              style: TextStyle(
                color: fg,
                fontSize: 10,
                letterSpacing: 6,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 64),
            SizedBox(
              width: double.infinity,
              height: 64,
              child: ElevatedButton(
                onPressed: () async {
                  final upiUrl = Uri.parse(
                    'upi://pay?pa=hibaashir@upi&pn=FATHASH&am=$price&cu=INR',
                  );
                  if (await canLaunchUrl(upiUrl)) {
                    await launchUrl(upiUrl);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Could not launch UPI app')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: fg,
                  elevation: 0,
                  shape: const ContinuousRectangleBorder(),
                ),
                child: Text(
                  'PAY VIA UPI APP',
                  style: TextStyle(
                    color: bg,
                    fontSize: 12,
                    letterSpacing: 4,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'CANCEL',
                style: TextStyle(
                  color: fgMuted,
                  fontSize: 11,
                  letterSpacing: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStickyFooter(
    Color bg,
    Color fg,
    Color fgMuted,
    Color borderColor,
    double price,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: bg,
        border: Border(top: BorderSide(color: borderColor, width: 0.5)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TOTAL',
                  style: TextStyle(
                    color: fg.withValues(alpha: 0.5),
                    fontSize: 10,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${price.toStringAsFixed(2)}',
                  style: TextStyle(
                    color: fg,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 56,
              width: 200,
              child: ElevatedButton(
                onPressed: () => _showPaymentModal(
                  context,
                  fg,
                  bg,
                  fgMuted,
                  borderColor,
                  price,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: fg,
                  elevation: 0,
                  shape: const RoundedRectangleBorder(),
                ),
                child: Text(
                  'PLACE ORDER',
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
        ),
      ),
    );
  }

  Widget _buildSidebar(
    BuildContext context,
    Color fg,
    Color bg,
    Color fgMuted,
    Color borderColor,
    Color cardBg,
    AddressState addressState,
  ) {
    if (_isAddingAddress) {
      return _buildAddAddressSidebar(context, fg, bg, fgMuted, borderColor);
    } else {
      return _buildAddressSelectorSidebar(
        context,
        fg,
        bg,
        fgMuted,
        cardBg,
        addressState,
        borderColor,
      );
    }
  }

  Widget _buildAddressSelectorSidebar(
    BuildContext context,
    Color fg,
    Color bg,
    Color fgMuted,
    Color cardBg,
    AddressState addressState,
    Color borderColor,
  ) {
    return Drawer(
      width: 450,
      backgroundColor: bg,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'CHANGE ADDRESS',
                    style: TextStyle(
                      color: fg,
                      fontSize: 14,
                      letterSpacing: 4,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(CupertinoIcons.xmark, size: 20, color: fgMuted),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                children: [
                  ...addressState.addresses.map(
                    (a) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: InkWell(
                        onTap: () {
                          ref
                              .read(addressProvider.notifier)
                              .selectAddress(a.id);
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: addressState.selectedAddressId == a.id
                                  ? fg
                                  : borderColor,
                            ),
                            color: addressState.selectedAddressId == a.id
                                ? fg.withValues(alpha: 0.05)
                                : Colors.transparent,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    addressState.selectedAddressId == a.id
                                        ? CupertinoIcons
                                              .check_mark_circled_solid
                                        : CupertinoIcons.circle,
                                    size: 16,
                                    color: fg,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    a.name,
                                    style: TextStyle(
                                      color: fg,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                a.summary,
                                style: TextStyle(
                                  color: fgMuted,
                                  fontSize: 12,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    height: 56,
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => setState(() => _isAddingAddress = true),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: fg),
                        shape: const RoundedRectangleBorder(),
                      ),
                      child: Text(
                        '+ ADD NEW ADDRESS',
                        style: TextStyle(
                          color: fg,
                          fontSize: 11,
                          letterSpacing: 2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddAddressSidebar(
    BuildContext context,
    Color fg,
    Color bg,
    Color fgMuted,
    Color borderColor,
  ) {
    final nameController = TextEditingController();
    final mobileController = TextEditingController();
    final pincodeController = TextEditingController();
    final cityController = TextEditingController();
    final stateController = TextEditingController();
    final addressController = TextEditingController();
    final localityController = TextEditingController();
    String type = 'Home';

    return Drawer(
      width: 450,
      backgroundColor: bg,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ADD NEW ADDRESS',
                    style: TextStyle(
                      color: fg,
                      fontSize: 14,
                      letterSpacing: 4,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => setState(() => _isAddingAddress = false),
                    icon: Icon(
                      CupertinoIcons.arrow_left,
                      size: 20,
                      color: fgMuted,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                children: [
                  _sidebarField('NAME', nameController, fg),
                  _sidebarField('10-DIGIT MOBILE NUMBER', mobileController, fg),
                  Row(
                    children: [
                      Expanded(
                        child: _sidebarField('PINCODE', pincodeController, fg),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _sidebarField(
                          'LOCALITY',
                          localityController,
                          fg,
                        ),
                      ),
                    ],
                  ),
                  _sidebarField(
                    'ADDRESS (AREA AND STREET)',
                    addressController,
                    fg,
                    maxLines: 3,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: _sidebarField(
                          'CITY / DISTRICT / TOWN',
                          cityController,
                          fg,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: _sidebarField('STATE', stateController, fg),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'ADDRESS TYPE',
                    style: TextStyle(
                      color: fg,
                      fontSize: 10,
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  StatefulBuilder(
                    builder: (context, setStateSB) {
                      return Row(
                        children: [
                          _typeChip(
                            'HOME',
                            type == 'Home',
                            fg,
                            bg,
                            () => setStateSB(() => type = 'Home'),
                          ),
                          const SizedBox(width: 12),
                          _typeChip(
                            'WORK',
                            type == 'Work',
                            fg,
                            bg,
                            () => setStateSB(() => type = 'Work'),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 64),
                  SizedBox(
                    height: 64,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final newAddress = Address(
                          id: const Uuid().v4(),
                          name: nameController.text,
                          mobile: mobileController.text,
                          pincode: pincodeController.text,
                          locality: localityController.text,
                          fullAddress: addressController.text,
                          city: cityController.text,
                          state: stateController.text,
                          type: type,
                        );
                        ref
                            .read(addressProvider.notifier)
                            .addAddress(newAddress);
                        setState(() => _isAddingAddress = false);
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: fg,
                        elevation: 0,
                        shape: const RoundedRectangleBorder(),
                      ),
                      child: Text(
                        'SAVE AND USE',
                        style: TextStyle(
                          color: bg,
                          fontSize: 12,
                          letterSpacing: 4,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sidebarField(
    String label,
    TextEditingController controller,
    Color fg, {
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: fg.withValues(alpha: 0.6),
              fontSize: 10,
              letterSpacing: 2,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            maxLines: maxLines,
            style: TextStyle(color: fg, fontSize: 14),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: fg.withValues(alpha: 0.2)),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: fg),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _typeChip(
    String label,
    bool selected,
    Color fg,
    Color bg,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: fg, width: 0.5),
          color: selected ? fg : Colors.transparent,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? bg : fg,
            fontSize: 10,
            letterSpacing: 2,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
