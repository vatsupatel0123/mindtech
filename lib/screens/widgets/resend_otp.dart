import 'dart:async';
import 'package:flutter/material.dart';

class ResendOtpTimer extends StatefulWidget {
  final int seconds;
  final VoidCallback onResend;

  const ResendOtpTimer({
    super.key,
    this.seconds = 90, // default 1 min 30 sec
    required this.onResend,
  });

  @override
  State<ResendOtpTimer> createState() => _ResendOtpTimerState();
}

class _ResendOtpTimerState extends State<ResendOtpTimer> {
  late int _secondsLeft;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    setState(() => _secondsLeft = widget.seconds);

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 1) {
        timer.cancel();
        setState(() => _secondsLeft = 0);
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTime(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: _secondsLeft > 0
            ? Text(
          'Resend OTP in ${_formatTime(_secondsLeft)}',
          style: const TextStyle(color: Colors.grey),
        )
            : GestureDetector(
          onTap: () {
            widget.onResend();
            _startCountdown();
          },
          child: const Text(
            'Resend OTP',
            style: TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ),
    );
  }
}
