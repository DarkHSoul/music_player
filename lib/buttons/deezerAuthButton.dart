import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DeezerAuthButton extends StatelessWidget {
  const DeezerAuthButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _launchDeezerAuthPage,
      child: const Text('Authorize with Deezer'),
    );
  }

  Future<void> _launchDeezerAuthPage() async {
    const String authorizeUrl = 'https://connect.deezer.com/oauth/auth.php?app_id=667183&redirect_uri=https://myapp/oauth/callback&perms=basic_access';
    //launch the url
    await launchUrl(Uri.parse(authorizeUrl));
  }
}
