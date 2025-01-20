import 'package:flutter/material.dart';
import 'package:bmi_health_checker/constant/legal_constants.dart';
import 'package:bmi_health_checker/screen/legal_screen.dart';

class ConsentDialog extends StatelessWidget {
  final VoidCallback onAccept;

  const ConsentDialog({
    super.key,
    required this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Welcome to BMI Calculator'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(LegalConstants.adConsentText),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LegalScreen(
                          title: 'Privacy Policy',
                          content: LegalConstants.privacyPolicyText,
                        ),
                      ),
                    );
                  },
                  child: const Text('Privacy Policy'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LegalScreen(
                          title: 'Terms of Service',
                          content: LegalConstants.termsOfServiceText,
                        ),
                      ),
                    );
                  },
                  child: const Text('Terms of Service'),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            onAccept();
            Navigator.of(context).pop();
          },
          child: const Text('Accept & Continue'),
        ),
      ],
    );
  }
}
