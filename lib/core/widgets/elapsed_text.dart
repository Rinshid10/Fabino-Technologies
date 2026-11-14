import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smart_access_security/core/utils/formatters.dart';

/// A stopwatch label: the time since [since], updated every second.
class ElapsedText extends StatefulWidget {
  const ElapsedText({required this.since, super.key});

  final DateTime since;

  @override
  State<ElapsedText> createState() => _ElapsedTextState();
}

class _ElapsedTextState extends State<ElapsedText> {
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => setState(() {}),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      Formatters.duration(DateTime.now().difference(widget.since)),
    );
  }
}
