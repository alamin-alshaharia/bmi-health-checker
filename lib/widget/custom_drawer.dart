import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_exit_app/flutter_exit_app.dart';
import '../constant/color/color.dart';
import '../constant/text_style.dart';
import '../constant/legal_constants.dart';
import '../screen/legal_screen.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 50.h),
      child: Column(
        children: <Widget>[
          CircleAvatar(
            radius: 50.r,
            backgroundColor: kActiveColor,
            child: Icon(Icons.health_and_safety,
                size: 50.sp, color: kInactiveColor),
          ),
          SizedBox(height: 20.h),
          Text(
            'BMI Health Checker',
            textAlign: TextAlign.center,
            style: buildTextStyle(
              fontSize: 22.sp,
              weight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 30.h),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildMenuItem(
                  context,
                  icon: Icons.history,
                  title: 'History',
                  onTap: () => Navigator.pushNamed(context, 'history_screen'),
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.analytics,
                  title: 'BMI Graph',
                  onTap: () => Navigator.pushNamed(context, 'graph_screen'),
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.share,
                  title: 'Share App',
                  onTap: () {
                    const String shareText = '''
BMI Health Checker - Calculate & Track Your BMI

A simple and effective tool to monitor your Body Mass Index (BMI) and maintain a healthy lifestyle.

#HealthyLifestyle #BMICalculator''';

                    Share.share(shareText);
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.star_rate,
                  title: 'Rate App',
                  onTap: () async {
                    // Remove rate app functionality until new account is approved
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Rating feature coming soon!'),
                      ),
                    );
                  },
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.info_outline,
                  title: 'About',
                  onTap: () => _showAboutDialog(context),
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy Policy',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LegalScreen(
                        title: 'Privacy Policy',
                        content: LegalConstants.privacyPolicyText,
                      ),
                    ),
                  ),
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.description_outlined,
                  title: 'Terms of Service',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LegalScreen(
                        title: 'Terms of Service',
                        content: LegalConstants.termsOfServiceText,
                      ),
                    ),
                  ),
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.exit_to_app,
                  title: 'Exit',
                  onTap: () => FlutterExitApp.exitApp(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(
        title,
        style: buildTextStyle(fontSize: 16, weight: FontWeight.w400),
      ),
      leading: Icon(icon, color: kActiveColor),
      onTap: () {
        // Navigator.pop(context); // Close the drawer first
        onTap();
      },
    );
  }

  Future<void> _launchRateApp() async {
    final url = Uri.parse(
      'https://play.google.com/store/apps/details?id=com.aas_soft.bmi_health_checker',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: kInactiveColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: kActiveColor.withOpacity(0.1),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: kActiveColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: kActiveColor.withOpacity(0.2),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.health_and_safety,
                  size: 48,
                  color: kActiveColor,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'BMI Health Checker',
                style: buildTextStyle(
                  fontSize: 28,
                  weight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: kActiveColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Version 1.0.0',
                  style: buildTextStyle(
                    fontSize: 14,
                    weight: FontWeight.w500,
                    color: kActiveColor,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'BMI Health Checker is a simple and effective tool to calculate and track your Body Mass Index (BMI). Stay healthy by monitoring your BMI regularly.',
                textAlign: TextAlign.center,
                style: buildTextStyle(
                  fontSize: 15,
                  weight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: kActiveColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: kActiveColor.withOpacity(0.1),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.copyright,
                          size: 20,
                          color: kActiveColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '2024 BMI Health Checker',
                          style: buildTextStyle(
                            fontSize: 14,
                            weight: FontWeight.w500,
                            color: kActiveColor,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'All Rights Reserved',
                      style: buildTextStyle(
                        fontSize: 14,
                        weight: FontWeight.w500,
                        color: kActiveColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  backgroundColor: kActiveColor,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Close',
                  style: buildTextStyle(
                    fontSize: 16,
                    weight: FontWeight.w600,
                    color: kInactiveColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required VoidCallback onPressed,
    required String tooltip,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: kActiveColor.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: kActiveColor),
        tooltip: tooltip,
        iconSize: 24,
        padding: const EdgeInsets.all(12),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    if (url.startsWith('mailto:')) {
      final Uri emailLaunchUri = Uri(
        scheme: 'mailto',
        path: url.substring(7),
        queryParameters: {
          'subject': 'Contact from BMI Health Checker App',
        },
      );

      try {
        if (await canLaunchUrl(emailLaunchUri)) {
          await launchUrl(emailLaunchUri);
        } else {
          // Fallback to web URL if email app is not available
          final webUrl = Uri.parse(
              'https://mail.google.com/mail/?view=cm&fs=1&to=${url.substring(7)}');
          if (await canLaunchUrl(webUrl)) {
            await launchUrl(webUrl, mode: LaunchMode.externalApplication);
          }
        }
      } catch (e) {
        // print('Error launching URL: $e');
      }
    } else {
      final uri = Uri.parse(url);
      try {
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      } catch (e) {
        // print('Error launching URL: $e');
      }
    }
  }

  Future<void> _launchShareApp() async {
    const String shareText = '''
Check out BMI Health Checker App!

Track your BMI and stay healthy with this amazing app.

Download now: https://play.google.com/store/apps/details?id=com.aas_soft.bmi_health_checker

#BMIHealthChecker #HealthyLifestyle''';

    await Share.share(shareText);
  }
}
