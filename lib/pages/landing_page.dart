// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:transcribe/core/auth.dart';
import 'package:transcribe/core/di.dart';
import 'package:transcribe/extensions/build_context_extensions.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  Future<void> _signInWithGoogle() async {
    await getIt<Auth>().signInWithGoogle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              context.localization.loginTitle,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 8),
            Text(
              context.localization.loginSubtitle,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _signInWithGoogle().then((_) {
                  _navigateToTranscriptions();
                });
              },
              child: Text(context.localization.loginWithGoogle),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToTranscriptions() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/transcriptions',
      (route) => false,
    );
  }
}
