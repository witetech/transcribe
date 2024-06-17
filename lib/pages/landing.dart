// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:transcribe/core/di.dart';
import 'package:transcribe/data/auth.dart';
import 'package:transcribe/extensions/build_context_extensions.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
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
                signInWithGoogle();
              },
              child: Text(context.localization.loginWithGoogle),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> signInWithGoogle() async {
    await getIt<Auth>().signInWithGoogle();
  }
}
