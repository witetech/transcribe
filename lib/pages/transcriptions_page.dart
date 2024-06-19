// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:transcribe/core/auth.dart';
import 'package:transcribe/core/di.dart';
import 'package:transcribe/extensions/build_context_extensions.dart';
import 'package:transcribe/pages/recording_page.dart';

class TranscriptionsPage extends StatefulWidget {
  const TranscriptionsPage({super.key});

  @override
  State<TranscriptionsPage> createState() => _TranscriptionsPageState();
}

class _TranscriptionsPageState extends State<TranscriptionsPage> {
  Future<void> _signOut() async {
    await getIt<Auth>().signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  void _navigateToLanding() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/landing',
      (route) => false,
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(context.localization.transcriptionsTitle),
      actions: [
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            _signOut().then((_) {
              _navigateToLanding();
            });
          },
        ),
      ],
    );
  }

  FloatingActionButton _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          isDismissible: false,
          enableDrag: false,
          builder: (context) {
            return const RecordingPage();
          },
        );
      },
      child: const Icon(Icons.multitrack_audio_rounded),
    );
  }
}
