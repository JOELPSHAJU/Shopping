import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/user_provider.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _activeSection = 'PERSONAL DATA';
  bool _isEditing = false;

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _mobileController;
  late TextEditingController _dobController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _mobileController = TextEditingController();
    _dobController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.background : const Color(0xFFF8F5F0);
    final fg = isDark ? AppColors.white : const Color(0xFF1A1A1A);
    final fgMuted = isDark ? AppColors.textBody : const Color(0xFF888480);
    final borderColor = isDark ? AppColors.cardLight : const Color(0xFFDDD8D0);

    final user = ref.watch(userProvider);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: bg,
      endDrawer: _buildProfileSidebar(context, fg, bg, fgMuted, borderColor, user),
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
                            user.name.split(' ').map((n) => n[0]).join().toUpperCase(),
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
                      child: Text(
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
                      if (_isEditing) {
                        setState(() => _isEditing = false);
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                    icon: Icon(
                      _isEditing ? CupertinoIcons.arrow_left : CupertinoIcons.xmark,
                      size: 20, 
                      color: fgMuted
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                children: _getSectionContent(fg, bg, fgMuted, borderColor, user),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _getSectionContent(Color fg, Color bg, Color fgMuted, Color borderColor, UserProfile user) {
    switch (_activeSection) {
      case 'PERSONAL DATA':
        if (_isEditing) {
          return [
            _sidebarField('Name', _nameController, fg, fgMuted),
            _sidebarField('Email', _emailController, fg, fgMuted),
            _sidebarField('Mobile', _mobileController, fg, fgMuted),
            _sidebarField('Date of Birth', _dobController, fg, fgMuted),
            const SizedBox(height: 48),
            _actionButton('SAVE CHANGES', fg, bg, onTap: () {
              ref.read(userProvider.notifier).updateProfile(UserProfile(
                name: _nameController.text,
                email: _emailController.text,
                mobile: _mobileController.text,
                dob: _dobController.text,
              ));
              setState(() => _isEditing = false);
            }),
          ];
        } else {
          return [
            _sidebarDisplayItem('Name', user.name, fg, fgMuted),
            _sidebarDisplayItem('Email', user.email, fg, fgMuted),
            _sidebarDisplayItem('Mobile', user.mobile, fg, fgMuted),
            _sidebarDisplayItem('Date of Birth', user.dob, fg, fgMuted),
            const SizedBox(height: 48),
            _actionButton('EDIT PROFILE', fg, bg, onTap: () {
              setState(() {
                _nameController.text = user.name;
                _emailController.text = user.email;
                _mobileController.text = user.mobile;
                _dobController.text = user.dob;
                _isEditing = true;
              });
            }),
          ];
        }
      case 'MY ORDERS':
        return [
          _orderItem('ID #82928', 'SS26 SILK SHIRT', 'Delivered', fg, fgMuted, borderColor),
          _orderItem('ID #82921', 'ARTISANAL TEE', 'Shipped', fg, fgMuted, borderColor),
          _orderItem('ID #81200', 'MODERN SLACKS', 'Cancelled', fg, fgMuted, borderColor),
        ];
      case 'SHIPPING':
        return [
          _addressItem('HOME', 'Kinfra Park Main Gate, Accel Infinium 1, Thiruvananthapuram, Kerala 695585', fg, fgMuted, borderColor),
          _addressItem('WORK', 'KINFRA IT & ITES SEZ, KINFRA Film and IT Park, Kerala 695585', fg, fgMuted, borderColor),
          const SizedBox(height: 32),
          _actionButton('+ ADD NEW ADDRESS', fg, Colors.transparent, outline: true, onTap: () {}),
        ];
      default:
        return [
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: Center(
              child: Text(
                'Coming Soon',
                style: TextStyle(
                  color: fgMuted,
                  fontSize: 12,
                  letterSpacing: 4,
                ),
              ),
            ),
          ),
        ];
    }
  }

  Widget _sidebarDisplayItem(String label, String value, Color fg, Color fgMuted) {
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
            style: TextStyle(
              color: fg,
              fontSize: 16,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sidebarField(String label, TextEditingController controller, Color fg, Color fgMuted) {
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
            style: TextStyle(color: fg, fontSize: 16, fontWeight: FontWeight.w300),
            cursorColor: fg,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: fg.withValues(alpha: 0.1))),
              focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: fg)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _orderItem(String id, String item, String status, Color fg, Color fgMuted, Color border) {
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
              Text(id, style: TextStyle(color: fgMuted, fontSize: 10, letterSpacing: 2)),
              Text(status.toUpperCase(), style: TextStyle(color: AppColors.accent, fontSize: 10, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          Text(item, style: TextStyle(color: fg, fontSize: 14, letterSpacing: 2)),
        ],
      ),
    );
  }

  Widget _addressItem(String type, String address, Color fg, Color fgMuted, Color border) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(border: Border.all(color: border, width: 0.5)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(type, style: TextStyle(color: fg, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 4)),
          const SizedBox(height: 12),
          Text(address, style: TextStyle(color: fgMuted, fontSize: 13, height: 1.5)),
        ]),
    );
  }

  Widget _actionButton(String label, Color fg, Color bg, {bool outline = false, required VoidCallback onTap}) {
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
            child: Text(label, style: TextStyle(color: fg, fontSize: 11, letterSpacing: 4, fontWeight: FontWeight.bold)),
          )
        : ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: fg,
              elevation: 0,
              shape: const RoundedRectangleBorder(),
            ),
            child: Text(label, style: TextStyle(color: bg, fontSize: 11, letterSpacing: 4, fontWeight: FontWeight.bold)),
          ),
    );
  }
}
