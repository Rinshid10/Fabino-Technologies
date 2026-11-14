import 'dart:async';

import 'package:flutter/material.dart';

/// Shows "Try again in N s" until [until], then calls [onExpired] once.
class LockoutCountdown extends StatefulWidget {
  const LockoutCountdown({
    required this.until,
    required this.onExpired,
    super.key,
  });

  final DateTime until;
  final VoidCallback onExpired;

  @override
  State<LockoutCountdown> createState() => _LockoutCountdownState();
}

class _LockoutCountdownState extends State<LockoutCountdown> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Duration get _remaining => widget.until.difference(DateTime.now());

  void _tick() {
    if (_remaining <= Duration.zero) {
      _timer?.cancel();
      widget.onExpired();
    } else {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    // Round up so the text never shows "0 s" while still locked.
    final seconds = (_remaining.inMilliseconds / 1000).ceil().clamp(0, 86400);
    final text = seconds >= 60 ? '${(seconds / 60).ceil()} min' : '$seconds s';
    return Text(
      'Try again in $text',
      style: TextStyle(color: Theme.of(context).colorScheme.error),
      textAlign: TextAlign.center,
    );
  }
}
