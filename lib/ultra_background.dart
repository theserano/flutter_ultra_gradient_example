import 'package:flutter/material.dart';
import 'dart:math' as math;

class UltraBackgroundWidget extends StatefulWidget {
  final Widget child;
  const UltraBackgroundWidget({super.key, required this.child});

  @override
  State<UltraBackgroundWidget> createState() => _UltraBackgroundWidgetState();
}

class _UltraBackgroundWidgetState extends State<UltraBackgroundWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat();

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          AnimatedBuilder(
            animation: _animation,
            builder: (_, __) {
              return CustomPaint(
                painter: BackgroundPainter(progress: _animation.value),
                child: Container(),
              );
            },
          ),
          widget.child,
        ],
      ),
    );
  }
}

class BackgroundPainter extends CustomPainter {
  final double progress;
  BackgroundPainter({required this.progress});

  void paintBackground(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromCenter(
        center: Offset(size.width * 0.5, size.height * 0.5),
        width: size.width,
        height: size.height,
      ),
      Paint()..color = Colors.blueGrey,
    );
  }

  void drawSquare(Canvas canvas, Size size) {
    final paint1 = Paint();
    paint1.maskFilter = MaskFilter.blur(BlurStyle.normal, 100);
    paint1.color = Colors.blue.shade300;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(size.width * 0.75, 100),
          width: 300,
          height: 300,
        ),
        Radius.circular(20),
      ),
      paint1,
    );
  }

  void drawAbstractShapes(Canvas canvas, Size size) {
    Path path = Path();
    final paint = Paint();
    paint.maskFilter = MaskFilter.blur(BlurStyle.normal, 100);
    path.moveTo(size.width * 1.2, 0);
    path.quadraticBezierTo(
      size.width * 1.2,
      300,
      size.width * 0.4,
      size.width * 0.6,
    );
    path.quadraticBezierTo(
      size.width * 0.1,
      size.height * 0.7,
      -100,
      size.width * 1.2,
    );
    path.lineTo(-50, -50);
    path.close();
    canvas.drawPath(
      path,
      paint
        ..color = Colors.purple.shade200
        ..style = PaintingStyle.fill,
    );
    drawSquare(canvas, size);
  }

  void drawEllipse(Canvas canvas, Size size, Paint paint) {
    paint.color = const Color.fromARGB(255, 160, 64, 177);
    paint.style = PaintingStyle.fill;

    final dx = size.width * 0.9 + 40 * math.cos(progress * 2 * math.pi);
    final dy = size.height * 0.4 + 30 * math.sin(progress * 2 * math.pi);

    canvas.drawOval(
      Rect.fromCenter(center: Offset(dx, dy), width: 450, height: 250),
      paint,
    );
  }

  void drawTriangle(Canvas canvas, Size size, Paint paint) {
    paint.color = const Color.fromARGB(255, 81, 161, 151);

    final dx = 180 + 40 * math.cos(progress * 2 * math.pi);
    final dy = size.width * 0.8 + 40 * math.sin(progress * 2 * math.pi);
    final offset = Offset(dx, dy);

    final path =
        Path()
          ..moveTo(offset.dx, offset.dy)
          ..lineTo(offset.dx + 350, offset.dy + 400)
          ..lineTo(offset.dx - 280, offset.dy + 500)
          ..close();

    canvas.drawPath(path, paint);
  }

  void drawCircle(Canvas canvas, Size size, Paint paint) {
    paint.color = Colors.orange;
    final dx = size.width * 0.2 + 50 * math.sin(progress * 2 * math.pi);
    final dy = 300 + 30 * math.cos(progress * 2 * math.pi);
    canvas.drawCircle(Offset(dx, dy), 150, paint);
  }

  void drawContrastingBlobs(Canvas canvas, Size size, Paint paint) {
    paint.maskFilter = MaskFilter.blur(BlurStyle.normal, 50);
    paint.blendMode = BlendMode.overlay;
    drawCircle(canvas, size, paint);
    drawTriangle(canvas, size, paint);
    drawEllipse(canvas, size, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    paintBackground(canvas, size);
    drawAbstractShapes(canvas, size);
    final paint = Paint();
    drawContrastingBlobs(canvas, size, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
