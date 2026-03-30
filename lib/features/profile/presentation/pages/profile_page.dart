import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shopping/core/theme/app_colors.dart';
import '../providers/user_provider.dart';
import 'package:shopping/features/checkout/presentation/providers/address_provider.dart';
import 'package:uuid/uuid.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _activeSection = 'PERSONAL DATA';
  bool _isEditing = false;
  bool _tempNotificationsEnabled = true;

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _mobileController;
  late TextEditingController _dobController;

  // Support
  late TextEditingController _helpSubjectController;
  late TextEditingController _helpMessageController;

  // Unified Address Controllers
  late TextEditingController _addrNameController;
  late TextEditingController _addrMobileController;
  late TextEditingController _addrPincodeController;
  late TextEditingController _addrLocalityController;
  late TextEditingController _addrFullAddressController;
  late TextEditingController _addrCityController;
  late TextEditingController _addrStateController;
  String _addrType = 'Home';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _mobileController = TextEditingController();
    _dobController = TextEditingController();
    _helpSubjectController = TextEditingController();
    _helpMessageController = TextEditingController();

    _addrNameController = TextEditingController();
    _addrMobileController = TextEditingController();
    _addrPincodeController = TextEditingController();
    _addrLocalityController = TextEditingController();
    _addrFullAddressController = TextEditingController();
    _addrCityController = TextEditingController();
    _addrStateController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _dobController.dispose();
    _helpSubjectController.dispose();
    _helpMessageController.dispose();

    _addrNameController.dispose();
    _addrMobileController.dispose();
    _addrPincodeController.dispose();
    _addrLocalityController.dispose();
    _addrFullAddressController.dispose();
    _addrCityController.dispose();
    _addrStateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.background : AppColors.lightBackground;
    final fg = isDark ? AppColors.white : AppColors.lightTextTitle;
    final fgMuted = isDark ? AppColors.textBody : AppColors.lightTextBody;
    final borderColor = isDark ? AppColors.cardLight : AppColors.lightBorder;

    final user = ref.watch(userProvider);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: bg,
      endDrawer: _buildProfileSidebar(
        context,
        fg,
        bg,
        fgMuted,
        borderColor,
        user,
      ),
      onEndDrawerChanged: (isOpen) {
        if (!isOpen) {
          setState(() => _isEditing = false);
        }
      },
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

                  // Header Section
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 16,
                                height: 0.5,
                                color: AppColors.accent,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'ACCOUNT PROFILE',
                                style: TextStyle(
                                  color: AppColors.accent,
                                  fontSize: 11,
                                  letterSpacing: 6,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Your Identity',
                            style: TextStyle(
                              color: fg,
                              fontSize: 56,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 8,
                            ),
                          ),
                        ],
                      ),
                      // Profile initial / circle
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          border: Border.all(color: fg, width: 0.5),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            user.name
                                .split(' ')
                                .map((n) => n[0])
                                .join()
                                .toUpperCase(),
                            style: TextStyle(
                              color: fg,
                              fontSize: 24,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 4,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  Container(
                    margin: const EdgeInsets.only(top: 48, bottom: 0),
                    height: 0.5,
                    color: borderColor,
                  ),

                  // Menu Items
                  _buildMenuItem(
                    context,
                    'PERSONAL DATA',
                    'Edit your information',
                    fg,
                    fgMuted,
                    borderColor,
                    onTap: () => _openSection('PERSONAL DATA'),
                  ),
                  _buildMenuItem(
                    context,
                    'MY ORDERS',
                    'Track and manage your pieces',
                    fg,
                    fgMuted,
                    borderColor,
                    onTap: () => _openSection('MY ORDERS'),
                  ),
                  _buildMenuItem(
                    context,
                    'SHIPPING',
                    'Manage your destinations',
                    fg,
                    fgMuted,
                    borderColor,
                    onTap: () => _openSection('SHIPPING'),
                  ),
                  _buildMenuItem(
                    context,
                    'PAYMENT',
                    'Security and transactions',
                    fg,
                    fgMuted,
                    borderColor,
                    onTap: () => _openSection('PAYMENT'),
                  ),
                  _buildMenuItem(
                    context,
                    'HELP CENTER',
                    'Customer support',
                    fg,
                    fgMuted,
                    borderColor,
                    onTap: () => _openSection('HELP CENTER'),
                  ),
                  _buildMenuItem(
                    context,
                    'SETTINGS',
                    'Application preferences',
                    fg,
                    fgMuted,
                    borderColor,
                    onTap: () => _openSection('SETTINGS'),
                    isLast: true,
                  ),

                  const SizedBox(height: 100),

                  // Logout
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        // Logout logic
                      },
                      child: const Text(
                        'SIGN OUT',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                          letterSpacing: 6,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _openSection(String section) {
    if (section == 'SETTINGS') {
      _tempNotificationsEnabled = ref.read(userProvider).notificationsEnabled;
    }
    setState(() {
      _activeSection = section;
      _isEditing = false;
    });
    _scaffoldKey.currentState?.openEndDrawer();
  }

  Widget _buildMenuItem(
    BuildContext context,
    String title,
    String subtitle,
    Color fg,
    Color fgMuted,
    Color border, {
    bool isLast = false,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 40),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: border, width: 0.5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: fg,
                    fontSize: 14,
                    letterSpacing: 6,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle.toUpperCase(),
                  style: TextStyle(
                    color: fgMuted,
                    fontSize: 10,
                    letterSpacing: 3,
                  ),
                ),
              ],
            ),
            Icon(CupertinoIcons.chevron_right, size: 16, color: fg),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSidebar(
    BuildContext context,
    Color fg,
    Color bg,
    Color fgMuted,
    Color borderColor,
    UserProfile user,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Drawer(
      width: screenWidth > 450 ? 450 : screenWidth,
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
                    _activeSection,
                    style: TextStyle(
                      color: fg,
                      fontSize: 14,
                      letterSpacing: 4,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (_activeSection == 'MESSAGE US') {
                        setState(() => _activeSection = 'HELP CENTER');
                      } else if (_activeSection == 'ADD ADDRESS') {
                        setState(() => _activeSection = 'SHIPPING');
                      } else if (_isEditing) {
                        setState(() => _isEditing = false);
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                    icon: Icon(
                      (_isEditing ||
                              _activeSection == 'MESSAGE US' ||
                              _activeSection == 'ADD ADDRESS')
                          ? CupertinoIcons.arrow_left
                          : CupertinoIcons.xmark,
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
                children: _getSectionContent(
                  fg,
                  bg,
                  fgMuted,
                  borderColor,
                  user,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _getSectionContent(
    Color fg,
    Color bg,
    Color fgMuted,
    Color borderColor,
    UserProfile user,
  ) {
    switch (_activeSection) {
      case 'PERSONAL DATA':
        if (_isEditing) {
          return [
            _sidebarField('Name', _nameController, fg, fgMuted),
            _sidebarField('Email', _emailController, fg, fgMuted),
            _sidebarField('Mobile', _mobileController, fg, fgMuted),
            _sidebarField('Date of Birth', _dobController, fg, fgMuted),
            const SizedBox(height: 48),
            _actionButton(
              'SAVE CHANGES',
              fg,
              bg,
              onTap: () {
                ref.read(userProvider.notifier).updateProfile(
                      UserProfile(
                        name: _nameController.text,
                        email: _emailController.text,
                        mobile: _mobileController.text,
                        dob: _dobController.text,
                        addresses: user.addresses,
                        notificationsEnabled: user.notificationsEnabled,
                      ),
                    );
                setState(() => _isEditing = false);
              },
            ),
          ];
        } else {
          return [
            _sidebarDisplayItem('Name', user.name, fg, fgMuted),
            _sidebarDisplayItem('Email', user.email, fg, fgMuted),
            _sidebarDisplayItem('Mobile', user.mobile, fg, fgMuted),
            _sidebarDisplayItem('Date of Birth', user.dob, fg, fgMuted),
            const SizedBox(height: 48),
            _actionButton(
              'EDIT PROFILE',
              fg,
              bg,
              onTap: () {
                setState(() {
                  _nameController.text = user.name;
                  _emailController.text = user.email;
                  _mobileController.text = user.mobile;
                  _dobController.text = user.dob;
                  _isEditing = true;
                });
              },
            ),
          ];
        }
      case 'MY ORDERS':
        return [
          _orderItem('ID #82928', 'SS26 SILK SHIRT', 'Delivered', fg, fgMuted,
              borderColor),
          _orderItem(
              'ID #82921', 'ARTISANAL TEE', 'Shipped', fg, fgMuted, borderColor),
          _orderItem('ID #81200', 'MODERN SLACKS', 'Cancelled', fg, fgMuted,
              borderColor),
        ];
      case 'SHIPPING':
        return [
          ...user.addresses.map(
            (a) => _addressItem(
              a.id,
              a.name,
              a.type,
              a.summary,
              fg,
              fgMuted,
              borderColor,
              onDelete: () {
                ref.read(userProvider.notifier).removeAddress(a.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: fg,
                    content: Text(
                      'ADDRESS REMOVED',
                      style:
                          TextStyle(color: bg, fontSize: 10, letterSpacing: 2),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 32),
          _actionButton(
            '+ ADD NEW ADDRESS',
            fg,
            Colors.transparent,
            outline: true,
            onTap: () => setState(() => _activeSection = 'ADD ADDRESS'),
          ),
          const SizedBox(height: 64),
        ];
      case 'ADD ADDRESS':
        return [
          _sidebarField('NAME', _addrNameController, fg, fgMuted),
          _sidebarField('10-DIGIT MOBILE NUMBER', _addrMobileController, fg, fgMuted),
          Row(
            children: [
              Expanded(
                child: _sidebarField('PINCODE', _addrPincodeController, fg, fgMuted),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _sidebarField('LOCALITY', _addrLocalityController, fg, fgMuted),
              ),
            ],
          ),
          _sidebarField('ADDRESS (AREA AND STREET)', _addrFullAddressController, fg, fgMuted,
              maxLines: 4),
          Row(
            children: [
              Expanded(
                child: _sidebarField('CITY / DISTRICT / TOWN', _addrCityController, fg, fgMuted),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _sidebarField('STATE', _addrStateController, fg, fgMuted),
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
                    _addrType == 'Home',
                    fg,
                    bg,
                    () => setStateSB(() => _addrType = 'Home'),
                  ),
                  const SizedBox(width: 12),
                  _typeChip(
                    'WORK',
                    _addrType == 'Work',
                    fg,
                    bg,
                    () => setStateSB(() => _addrType = 'Work'),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 64),
          _actionButton(
            'ADD ADDRESS',
            fg,
            bg,
            onTap: () {
              if (_addrNameController.text.isNotEmpty &&
                  _addrFullAddressController.text.isNotEmpty) {
                ref.read(userProvider.notifier).addAddress(
                      Address(
                        id: Uuid().v4(),
                        name: _addrNameController.text,
                        mobile: _addrMobileController.text,
                        pincode: _addrPincodeController.text,
                        locality: _addrLocalityController.text,
                        fullAddress: _addrFullAddressController.text,
                        city: _addrCityController.text,
                        state: _addrStateController.text,
                        type: _addrType,
                      ),
                    );
                // Clear fields
                _addrNameController.clear();
                _addrMobileController.clear();
                _addrPincodeController.clear();
                _addrLocalityController.clear();
                _addrFullAddressController.clear();
                _addrCityController.clear();
                _addrStateController.clear();

                setState(() => _activeSection = 'SHIPPING');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: fg,
                    content: Text(
                      'ADDRESS ADDED SUCCESSFULLY',
                      style:
                          TextStyle(color: bg, fontSize: 10, letterSpacing: 2),
                    ),
                  ),
                );
              }
            },
          ),
          const SizedBox(height: 100),
        ];

      case 'HELP CENTER':
        return [
          _sidebarDisplayItem('Email Support', 'info@fathash.com', fg, fgMuted),
          _sidebarDisplayItem('WhatsApp', '+91 80782 56341', fg, fgMuted),
          _sidebarDisplayItem('Instagram', '@fathash_by_hibaashir', fg, fgMuted),
          _sidebarDisplayItem(
              'Store Hours', 'Mon - Sat: 10:00 - 19:00', fg, fgMuted),
          const SizedBox(height: 48),
          const Text(
            'FOR RETURNS OR CLAIMS',
            style: TextStyle(
              color: AppColors.accent,
              fontSize: 10,
              letterSpacing: 2,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '• No refund or exchange\n• Unboxing video required for claims',
            style: TextStyle(
              color: fg,
              fontSize: 12,
              height: 1.8,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 48),
          _actionButton(
            'MESSAGE US',
            fg,
            bg,
            onTap: () {
              setState(() {
                _activeSection = 'MESSAGE US';
              });
            },
          ),
        ];
      case 'MESSAGE US':
        return [
          _sidebarField('SUBJECT', _helpSubjectController, fg, fgMuted),
          _sidebarField('EXPLANATION', _helpMessageController, fg, fgMuted,
              maxLines: 5),
          const SizedBox(height: 48),
          _actionButton(
            'SEND MESSAGE',
            fg,
            bg,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: fg,
                  content: Text(
                    'MESSAGE SENT SUCCESSFULLY',
                    style: TextStyle(color: bg, fontSize: 10, letterSpacing: 2),
                  ),
                ),
              );
              Navigator.of(context).pop();
            },
          ),
        ];
      case 'PAYMENT':
        return [
          _sidebarDisplayItem(
              'Current Method', 'UPI Payment (Active)', fg, fgMuted),
          _sidebarDisplayItem('UPI ID', 'hibaashir@upi', fg, fgMuted),
          const SizedBox(height: 48),
          _actionButton('CHANGE METHOD', fg, bg, onTap: () {}),
        ];
      case 'SETTINGS':
        return [
          _sidebarDisplayItem('Language', 'English (UK)', fg, fgMuted),
          _sidebarDisplayItem('Currency', 'INR (₹)', fg, fgMuted),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'NOTIFICATIONS',
                    style: TextStyle(
                      color: fgMuted,
                      fontSize: 10,
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _tempNotificationsEnabled ? 'TURNED ON' : 'TURNED OFF',
                    style: TextStyle(
                      color: fg,
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
              CupertinoSwitch(
                value: _tempNotificationsEnabled,
                activeColor: AppColors.accent,
                onChanged: (val) => setState(() => _tempNotificationsEnabled = val),
              ),
            ],
          ),
          const SizedBox(height: 64),
          _actionButton(
            'SAVE PREFERENCES',
            fg,
            bg,
            onTap: () {
              ref.read(userProvider.notifier).updateNotifications(_tempNotificationsEnabled);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: fg,
                  content: Text(
                    'PREFERENCES UPDATED',
                    style: TextStyle(color: bg, fontSize: 10, letterSpacing: 2),
                  ),
                ),
              );
            },
          ),
        ];
      default:
        return [
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Center(
              child: Text(
                'Information not available',
                style: TextStyle(color: fgMuted, fontSize: 12, letterSpacing: 4),
              ),
            ),
          ),
        ];
    }
  }

  Widget _sidebarDisplayItem(
      String label, String value, Color fg, Color fgMuted) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              color: fgMuted,
              fontSize: 10,
              letterSpacing: 2,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style:
                TextStyle(color: fg, fontSize: 16, fontWeight: FontWeight.w300),
          ),
        ],
      ),
    );
  }

  Widget _sidebarField(
      String label, TextEditingController controller, Color fg, Color fgMuted,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              color: fgMuted,
              fontSize: 10,
              letterSpacing: 2,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            maxLines: maxLines,
            style:
                TextStyle(color: fg, fontSize: 16, fontWeight: FontWeight.w300),
            cursorColor: fg,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: fg.withValues(alpha: 0.1)),
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

  Widget _orderItem(String id, String item, String status, Color fg,
      Color fgMuted, Color border) {
    return InkWell(
      onTap: () => context.push('/profile/order-details/$id'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(border: Border.all(color: border, width: 0.5)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  id,
                  style:
                      TextStyle(color: fgMuted, fontSize: 10, letterSpacing: 2),
                ),
                Text(
                  status.toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.accent,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              item,
              style: TextStyle(color: fg, fontSize: 14, letterSpacing: 2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _addressItem(String id, String name, String type, String summary,
      Color fg, Color fgMuted, Color border,
      {required VoidCallback onDelete}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(border: Border.all(color: border, width: 0.5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name.toUpperCase(),
                style: TextStyle(
                  color: fg,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    color: border,
                    child: Text(
                      type.toUpperCase(),
                      style: TextStyle(color: fgMuted, fontSize: 8),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: onDelete,
                    icon: Icon(CupertinoIcons.trash, color: fgMuted, size: 16),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            summary,
            style: TextStyle(color: fgMuted, fontSize: 12, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _typeChip(
      String label, bool isSelected, Color fg, Color bg, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? fg : Colors.transparent,
          border: Border.all(color: fg, width: 0.5),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? bg : fg,
            fontSize: 10,
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _actionButton(String label, Color fg, Color bg,
      {bool outline = false, required VoidCallback onTap}) {
    return SizedBox(
      height: 56,
      width: double.infinity,
      child: outline
          ? OutlinedButton(
              onPressed: onTap,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: fg, width: 0.5),
                shape: const RoundedRectangleBorder(),
              ),
              child: Text(
                label,
                style: TextStyle(
                  color: fg,
                  fontSize: 11,
                  letterSpacing: 4,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: fg,
                elevation: 0,
                shape: const RoundedRectangleBorder(),
              ),
              child: Text(
                label,
                style: TextStyle(
                  color: bg,
                  fontSize: 11,
                  letterSpacing: 4,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
    );
  }
}
