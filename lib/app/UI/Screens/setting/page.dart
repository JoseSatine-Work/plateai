import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class Setting extends StatelessWidget {
  const Setting({super.key});

  Future<void> _shareApp() async {
    await Share.share(
        'Check out flutter_application_1 - Download now from the app store!');
  }

  Future<void> _rateApp() async {
    final Uri url = Uri.parse('market://details?id=com.flutter_application_1');
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      final fallbackUrl = Uri.parse(
          'https://play.google.com/store/apps/details?id=com.flutter_application_1');
      if (await canLaunchUrl(fallbackUrl)) {
        await launchUrl(fallbackUrl);
      }
    }
  }

  // logout
  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black),
          iconSize: 30,
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Settings",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildSettingButton(
                        "Privacy & Policy",
                        onPressed: () {
                          Navigator.pushNamed(context, '/privacy-policy');
                        },
                      ),
                      const SizedBox(height: 10),
                      _buildSettingButton(
                        "Terms & Conditions",
                        onPressed: () {
                          Navigator.pushNamed(context, '/terms');
                        },
                      ),
                      const SizedBox(height: 10),
                      _buildSettingButton(
                        "Support",
                        onPressed: () {
                          Navigator.pushNamed(context, '/support');
                        },
                        showChevron: false,
                      ),
                      const SizedBox(height: 10),
                      _buildSettingButton(
                        "Logout",
                        onPressed: () => _showLogoutDialog(context),
                      ),
                    ],
                  ),
                ),
              ),
              _buildBottomButtons(context),
              const SizedBox(height: 70),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _shareApp,
              icon: const Icon(
                Icons.share,
                color: Colors.green,
                size: 20,
              ),
              label: const Text("Share",
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 20,
                  )),
              style: _buttonStyle(),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _rateApp,
              icon: const Icon(
                Icons.star_rate_rounded,
                color: Colors.green,
                size: 20,
              ),
              label: const Text("Rate",
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 20,
                  )),
              style: _buttonStyle(),
            ),
          ),
        ],
      ),
    );
  }

  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 12),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: Colors.green, width: 1),
      ),
    );
  }

  Widget _buildSettingButton(
    String title, {
    required VoidCallback onPressed,
    bool showChevron = true,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(15),
          elevation: 0,
          side: const BorderSide(color: Colors.grey, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontSize: 20)),
            if (showChevron)
              const Icon(Icons.chevron_right, size: 20, color: Colors.green),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.logout, color: Colors.green, size: 40),
              const SizedBox(height: 16),
              const Text(
                "Logout",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Are you sure you want to logout?",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildDialogButton(
                    context,
                    "CANCEL",
                    Colors.white,
                    Colors.green,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  _buildDialogButton(
                    context,
                    "CONFIRM",
                    Colors.green,
                    Colors.white,
                    onPressed: () async {
                      final UserProvider userProvider =
                          Provider.of<UserProvider>(context, listen: false);

                      userProvider.clearUser();
                      // Ensure the method is async when calling asynchronous code
                      await FirebaseAuth.instance.signOut();
                      Navigator.of(context).pop();
                      Navigator.pushNamed(context, '/');
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDialogButton(
      BuildContext context, String text, Color bgColor, Color textColor,
      {required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor: textColor,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(text),
    );
  }
}
