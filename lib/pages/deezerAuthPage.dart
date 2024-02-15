import 'package:flutter/material.dart';
import 'package:uni_links/uni_links.dart';
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
  // Launch the URL
  await launch(authorizeUrl);
}
}

class DeezerAuthPage extends StatefulWidget {
  const DeezerAuthPage({super.key});

  @override
  _DeezerAuthPageState createState() => _DeezerAuthPageState();
}

class _DeezerAuthPageState extends State<DeezerAuthPage> {
  @override
  void initState() {
    super.initState();
    // Start listening for URL changes
    initUniLinks();
    launchUrl();
  }
Future<void> initUniLinks() async {
    try {
      Uri? initialUri = await getInitialUri();
      if (initialUri != null) {
        handleUri(initialUri);
      }
      getUriLinksStream().listen((Uri? uri) {
        if (uri != null) {
          handleUri(uri);
        }
      });
    } catch (e) {
      print('Error initializing uni_links: $e');
    }
  }

  void handleUri(Uri uri) {
    if (uri.toString().startsWith('myapp/oauth/callback')) {
      // Handle the callback URL appropriately
      print('Received callback URL: ${uri.toString()}');
    }
  }

  Future<void> launchUrl() async {
    // Check for the URL periodically
    while (true) {
      String? url = await _getUrl();
      if (url != null && url.startsWith('myapp/oauth/callback')) {
        // Extract any necessary information from the URL
        // For example, you can parse the URL to extract authorization code, access token, etc.
        print('Received callback URL: $url');
      }
      await Future.delayed(const Duration(seconds: 1)); // Adjust the delay as needed
    }
  }

  Future<String?> _getUrl() async {
    // Get the current URL
    String? url = await _getCurrentUrl();
    return url;
  }
Future<String?> _getCurrentUrl() async {
  try {
    Uri? initialUri = await getInitialUri();
    if (initialUri != null && initialUri.toString().startsWith('myapp/oauth/callback')) {
      return initialUri.toString();
    }
  } catch (e) {
    print('Error getting current URL: $e');
  }
  return null;
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Deezer Auth Callback'),
      ),
      body: const Center(
        child: Text('Waiting for Deezer callback...'),
      ),
    );
  }
}
