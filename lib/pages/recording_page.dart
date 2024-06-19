// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:audio_session/audio_session.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

// Project imports:
import 'package:transcribe/extensions/build_context_extensions.dart';

class RecordingPage extends StatefulWidget {
  const RecordingPage({super.key});

  @override
  State<RecordingPage> createState() => _RecordingPageState();
}

class _RecordingPageState extends State<RecordingPage> {
  bool _isRecording = false;
  int _durationInMilliseconds = 0;

  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  StreamSubscription? _recorderSubscription;

  Future<void> _initRecorder() async {
    await _recorder.openRecorder();
    await _recorder.setSubscriptionDuration(const Duration(milliseconds: 10));
    final session = await AudioSession.instance;
    await session.configure(
      AudioSessionConfiguration(
        avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
        avAudioSessionCategoryOptions:
            AVAudioSessionCategoryOptions.allowBluetooth |
                AVAudioSessionCategoryOptions.defaultToSpeaker,
        avAudioSessionMode: AVAudioSessionMode.spokenAudio,
        avAudioSessionRouteSharingPolicy:
            AVAudioSessionRouteSharingPolicy.defaultPolicy,
        avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
        androidAudioAttributes: const AndroidAudioAttributes(
          contentType: AndroidAudioContentType.speech,
          flags: AndroidAudioFlags.none,
          usage: AndroidAudioUsage.voiceCommunication,
        ),
        androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
        androidWillPauseWhenDucked: true,
      ),
    );
  }

  void cancelRecorderSubscriptions() {
    if (_recorderSubscription != null) {
      _recorderSubscription!.cancel();
      _recorderSubscription = null;
    }
  }

  Future<void> releaseRecorder() async {
    await _recorder.closeRecorder();
  }

  void startRecorder(BuildContext context) async {
    if (await _checkPermissions(context)) {
      await _recorder.startRecorder(
        toFile: 'test.mp4',
        codec: Codec.aacMP4,
        bitRate: 8000,
        numChannels: 1,
        sampleRate: 8000,
      );
      setState(() {
        _isRecording = true;
      });

      _recorderSubscription = _recorder.onProgress!.listen((e) {
        setState(() {
          _durationInMilliseconds = e.duration.inMilliseconds;
        });
      });
    }
  }

  void stopRecorder() async {
    await _recorder.stopRecorder();
    cancelRecorderSubscriptions();
    setState(() {
      _isRecording = false;
    });
  }

  Future<bool> _checkPermissions(BuildContext context) async {
    final status = await Permission.microphone.status;
    if (status.isGranted) {
      return true;
    }

    if (status.isPermanentlyDenied) {
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (BuildContext context) => _buildPermissionRequiredDialog(),
        );
      }
      return false;
    }

    final result = await Permission.microphone.request();
    return result.isGranted;
  }

  String _formatDuration(int duration) {
    return DateFormat('mm:ss:SS', 'en_GB').format(
      DateTime.fromMillisecondsSinceEpoch(
        duration,
        isUtc: true,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _initRecorder();
  }

  @override
  void dispose() {
    super.dispose();
    cancelRecorderSubscriptions();
    releaseRecorder();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _isRecording,
      child: SizedBox(
        width: double.infinity,
        height: 256.0,
        child: Center(
          child: _buildControls(),
        ),
      ),
    );
  }

  Widget _buildControls() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(_formatDuration(_durationInMilliseconds)),
        IconButton(
          icon: Icon(
            _isRecording ? Icons.stop_rounded : Icons.fiber_manual_record,
            color: Colors.red,
            size: 64.0,
          ),
          onPressed: () {
            if (_isRecording) {
              stopRecorder();
            } else {
              startRecorder(context);
            }
          },
        ),
      ],
    );
  }

  AlertDialog _buildPermissionRequiredDialog() {
    return AlertDialog(
      title: Text(context.localization.permissionRequiredDialogTitle),
      content: Text(context.localization.permissionRequiredDialogDescription),
      actions: [
        TextButton(
          child: Text(
            context.localization.permissionRequiredDialogNavigateToAppSettings,
          ),
          onPressed: () {
            openAppSettings();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
