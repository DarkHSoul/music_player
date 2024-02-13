import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class DeezerAuthButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _launchDeezerAuthPage,
      child: Text('Authorize with Deezer'),
    );
  }

  Future<void> _launchDeezerAuthPage() async {
    final String authorizeUrl = 'https://connect.deezer.com/oauth/auth.php?app_id=667183&redirect_uri=https://myapp/oauth/callback&perms=basic_access';
    // Launch the URL
    await launch(authorizeUrl);
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Deezer Auth',
      home: DeezerAuthPage(),
    );
  }
}

class DeezerAuthPage extends StatefulWidget {
  @override
  _DeezerAuthPageState createState() => _DeezerAuthPageState();
}

class _DeezerAuthPageState extends State<DeezerAuthPage> {
  @override
  void initState() {
    super.initState();
    // Start listening for URL changes
    launchUrl();
  }

  Future<void> launchUrl() async {
    // Check for the URL periodically
    while (true) {
      String? url = await _getUrl();
      if (url != null && url.startsWith('https://myapp/oauth/callback')) {
        // Extract any necessary information from the URL
        // For example, you can parse the URL to extract authorization code, access token, etc.
        print('Received callback URL: $url');
      }
      await Future.delayed(Duration(seconds: 1)); // Adjust the delay as needed
    }
  }

  Future<String?> _getUrl() async {
    // Get the current URL
    String? url = await _getCurrentUrl();
    return url;
  }

  Future<String?> _getCurrentUrl() async {
    try {
      return await launchUrlString('https://google.com').then((value) => value.toString());
    } catch (e) {
      print('Error getting current URL: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Deezer Auth Callback'),
      ),
      body: Center(
        child: Text('Waiting for Deezer callback...'),
      ),
    );
  }
}
