import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../app.dart';

class AppLoader {
  static final AppLoader _instance = AppLoader._internal();
  factory AppLoader() => _instance;
  AppLoader._internal();
  bool _loaderVisible = false;

  show() {
    if (MyApp.navigatorKey.currentContext != null && !_loaderVisible) {
      _loaderVisible = true;
      showDialog(
          context: MyApp.navigatorKey.currentContext!,
          barrierDismissible: false,
          builder: (context) {
            final primaryColor = Theme.of(context).primaryColor;
            return Scaffold(
              backgroundColor: Colors.transparent,
              body: PopScope(
                  canPop: false,
                  child: Center(
                    child: _SpinnerWidget(color: primaryColor),
                  )),
            );
          });
    }
  }

  hide() {
    if (_loaderVisible) {
      if (MyApp.navigatorKey.currentContext != null) {
        _loaderVisible = false;
        Navigator.of(MyApp.navigatorKey.currentContext!).pop();
      }
    }
  }
}

class _SpinnerWidget extends StatefulWidget {
  final Color color;
  const _SpinnerWidget({required this.color});

  @override
  State<_SpinnerWidget> createState() => _SpinnerWidgetState();
}

class _SpinnerWidgetState extends State<_SpinnerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: const Size(48, 48),
          painter: _SpinnerPainter(
            progress: _controller.value,
            color: widget.color,
          ),
        );
      },
    );
  }
}

class _SpinnerPainter extends CustomPainter {
  final double progress;
  final Color color;

  _SpinnerPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;
    final startAngle = 2 * math.pi * progress - math.pi / 2;
    final sweepAngle = math.pi * 1.2;

    // Track
    final trackPaint = Paint()
      ..color = color.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, trackPaint);

    // Arc
    final arcPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      arcPaint,
    );
  }

  @override
  bool shouldRepaint(_SpinnerPainter oldDelegate) =>
      oldDelegate.progress != progress;
}