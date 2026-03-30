import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shopping/core/theme/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:go_router/go_router.dart';

class HelpCenterPage extends StatefulWidget {
  const HelpCenterPage({super.key});

  @override
  State<HelpCenterPage> createState() => _HelpCenterPageState();
}

class _HelpCenterPageState extends State<HelpCenterPage> {
  final _subjectController = TextEditingController();
  final _bodyController = TextEditingController();
  bool _isMessaging = false;

  @override
  void dispose() {
    _subjectController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final subject = _subjectController.text.trim();
    final body = _bodyController.text.trim();

    if (subject.isEmpty || body.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in both subject and message'),
        ),
      );
      return;
    }

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'info@fathash.com',
      query: encodeQueryParameters(<String, String>{
        'subject': subject,
        'body': body,
      }),
    );

    try {
      if (await canLaunchUrl(emailLaunchUri)) {
        await launchUrl(emailLaunchUri);
        setState(() => _isMessaging = false);
        _subjectController.clear();
        _bodyController.clear();
      } else {
        throw 'Could not launch $emailLaunchUri';
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not open email app: $e')));
    }
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map(
          (MapEntry<String, String> e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
        )
        .join('&');
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppColors.background : AppColors.lightBackground;
    final fg = isDark ? AppColors.white : AppColors.lightTextTitle;
    final fgMuted = isDark ? AppColors.textBody : AppColors.lightTextBody;
    final borderColor = isDark ? AppColors.cardLight : AppColors.lightBorder;
    final cardBg = isDark ? AppColors.cardDark : AppColors.lightCard;

    return Scaffold(
      backgroundColor: bg,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context, fg, bg, fgMuted),
          SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        'HOW CAN WE ASSIST YOU?',
                        style: TextStyle(
                          color: fg,
                          fontSize: 24,
                          letterSpacing: 4,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Select a topic or send us a message directly. Our support team is available 24/7.',
                        style: TextStyle(
                          color: fgMuted,
                          fontSize: 14,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 48),

                      if (!_isMessaging) ...[
                        _buildTopicTile(
                          'ORDER TRACKING',
                          CupertinoIcons.cube_box,
                          fg,
                          fgMuted,
                          borderColor,
                        ),
                        _buildTopicTile(
                          'RETURNS & EXCHANGES',
                          CupertinoIcons.arrow_2_squarepath,
                          fg,
                          fgMuted,
                          borderColor,
                        ),
                        _buildTopicTile(
                          'SHIPPING & DELIVERY',
                          Icons.local_shipping,
                          fg,
                          fgMuted,
                          borderColor,
                        ),
                        _buildTopicTile(
                          'PAYMENT ISSUES',
                          CupertinoIcons.creditcard,
                          fg,
                          fgMuted,
                          borderColor,
                        ),
                        const SizedBox(height: 64),

                        // Message Us Trigger
                        Center(
                          child: Column(
                            children: [
                              Text(
                                'DON\'T SEE YOUR ISSUE?',
                                style: TextStyle(
                                  color: fgMuted,
                                  fontSize: 10,
                                  letterSpacing: 2,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                width: double.infinity,
                                height: 60,
                                child: OutlinedButton(
                                  onPressed: () =>
                                      setState(() => _isMessaging = true),
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide(color: fg, width: 0.5),
                                    shape: const RoundedRectangleBorder(),
                                  ),
                                  child: Text(
                                    'MESSAGE US',
                                    style: TextStyle(
                                      color: fg,
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
                      ] else ...[
                        // Messaging Form
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () => setState(() => _isMessaging = false),
                              child: Row(
                                children: [
                                  Icon(
                                    CupertinoIcons.chevron_left,
                                    size: 14,
                                    color: fgMuted,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'BACK',
                                    style: TextStyle(
                                      color: fgMuted,
                                      fontSize: 10,
                                      letterSpacing: 2,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        Text(
                          'DIRECT MESSAGE',
                          style: TextStyle(
                            color: fg,
                            fontSize: 12,
                            letterSpacing: 4,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 32),

                        _buildField(
                          'SUBJECT',
                          'Enter enquiry subject...',
                          _subjectController,
                          fg,
                          fgMuted,
                          borderColor,
                          cardBg,
                        ),
                        const SizedBox(height: 24),
                        _buildField(
                          'MESSAGE',
                          'How can we help...',
                          _bodyController,
                          fg,
                          fgMuted,
                          borderColor,
                          cardBg,
                          maxLines: 6,
                        ),
                        const SizedBox(height: 48),

                        SizedBox(
                          width: double.infinity,
                          height: 64,
                          child: ElevatedButton(
                            onPressed: _sendMessage,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: fg,
                              elevation: 0,
                              shape: const RoundedRectangleBorder(),
                            ),
                            child: Text(
                              'SEND MESSAGE',
                              style: TextStyle(
                                color: isDark ? Colors.black : Colors.white,
                                fontSize: 12,
                                letterSpacing: 4,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 100),
                      ],
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, Color fg, Color bg, Color fgMuted) {
    return SliverAppBar(
      backgroundColor: bg,
      floating: true,
      elevation: 0,
      leading: IconButton(
        icon: Icon(CupertinoIcons.chevron_left, color: fg, size: 20),
        onPressed: () => context.pop(),
      ),
      title: Text(
        'HELP CENTER',
        style: TextStyle(
          color: fg,
          fontSize: 14,
          letterSpacing: 4,
          fontWeight: FontWeight.w400,
        ),
      ),
      centerTitle: true,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(color: fgMuted.withValues(alpha: 0.1), height: 0.5),
      ),
    );
  }

  Widget _buildTopicTile(
    String title,
    IconData icon,
    Color fg,
    Color fgMuted,
    Color borderColor,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor, width: 0.5),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        leading: Icon(icon, color: fg, size: 20),
        title: Text(
          title,
          style: TextStyle(
            color: fg,
            fontSize: 12,
            letterSpacing: 2,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(CupertinoIcons.chevron_right, size: 14, color: fgMuted),
      ),
    );
  }

  Widget _buildField(
    String label,
    String hint,
    TextEditingController controller,
    Color fg,
    Color fgMuted,
    Color borderColor,
    Color cardBg, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: fg,
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
            hintText: hint,
            hintStyle: TextStyle(color: fgMuted, fontSize: 14),
            filled: true,
            fillColor: cardBg.withValues(alpha: 0.5),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: borderColor, width: 0.5),
              borderRadius: BorderRadius.zero,
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: fg, width: 1),
              borderRadius: BorderRadius.zero,
            ),
            contentPadding: const EdgeInsets.all(20),
          ),
        ),
      ],
    );
  }
}
