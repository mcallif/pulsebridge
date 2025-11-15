import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:just_audio/just_audio.dart';

void main() => runApp(const PulsebridgeApp());

class PulsebridgeApp extends StatefulWidget {
  const PulsebridgeApp({super.key});
  @override State<PulsebridgeApp> createState() => _PulsebridgeAppState();
}

class _PulsebridgeAppState extends State<PulsebridgeApp> {
  final player = AudioPlayer();
  double bpm = 60.0;

  @override
  void initState() {
    super.initState();
    accelerometerEvents.listen((event) {
      final g = event.x.abs() + event.y.abs() + event.z.abs();
      final newBpm = 60 + (g * 15).clamp(0, 120);
      if ((newBpm - bpm).abs() > 2) {
        setState(() => bpm = newBpm);
        triggerPulse(newBpm);
      }
    });
    triggerPulse(60);
  }

  void triggerPulse(double bpm) async {
    final freq = 220.0 + (bpm - 60) * 3.5;
    await player.setAsset('assets/pulse.wav');
    await player.setPitch(freq / 440.0);
    player.play();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            '${bpm.toInt()} BPM',
            style: const TextStyle(color: Colors.red, fontSize: 48),
          ),
        ),
      ),
    );
  }
}
