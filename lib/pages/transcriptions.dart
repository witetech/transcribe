// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:transcribe/core/di.dart';
import 'package:transcribe/data/auth.dart';

class TranscriptionsPage extends StatefulWidget {
  const TranscriptionsPage({super.key});

  @override
  State<TranscriptionsPage> createState() => _TranscriptionsPageState();
}

class _TranscriptionsPageState extends State<TranscriptionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Transcriptions'),
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            signOut(context);
          },
        ),
      ],
    );
  }

  Future<void> signOut(BuildContext context) async {
    await getIt<Auth>().signOut();
    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/landing',
        (route) => false,
      );
    }
  }
}
