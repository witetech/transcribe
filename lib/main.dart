// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

// Project imports:
import 'package:transcribe/core/auth.dart';
import 'package:transcribe/core/di.dart';
import 'package:transcribe/core/firebase.dart';
import 'package:transcribe/pages/landing_page.dart';
import 'package:transcribe/pages/transcriptions_page.dart';

void main() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: binding);
  await dotenv.load(fileName: '.env');
  await initializeFirebase();
  await initializeDependencies();
  runApp(TranscribeApp(isSignedIn: await getIt.get<Auth>().isSignedIn));
  FlutterNativeSplash.remove();
}

class TranscribeApp extends StatelessWidget {
  final bool isSignedIn;

  const TranscribeApp({
    super.key,
    required this.isSignedIn,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Transcribe',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
      ),
      initialRoute: isSignedIn ? '/transcriptions' : '/landing',
      routes: {
        '/landing': (context) => const LandingPage(),
        '/transcriptions': (context) => const TranscriptionsPage(),
      },
    );
  }
}
