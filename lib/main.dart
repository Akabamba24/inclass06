// In-Class Activity 06 — Drawing with Flutter
// Student: Augustin Kabamba
// Date: September 29, 2026

import 'dart:math' as math;

import 'package:flutter/material.dart';

void main() => runApp(const SmileyApp());

class SmileyApp extends StatelessWidget {
  const SmileyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Smiley Painter Lab',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF7257E8),
            brightness: Brightness.dark,
          ),
          scaffoldBackgroundColor: const Color(0xFF101116),
          useMaterial3: true,
        ),
        home: const DrawingPlayground(),
      );
}

enum FaceStyle { classic, sleepy, surprised, bullseye }

class FaceConfig {
  const FaceConfig({
    required this.mood,
    required this.style,
    required this.eyeRadius,
    required this.eyeGap,
    required this.blush,
    required this.hat,
    required this.glasses,
    required this.mustache,
  });

  final double mood;
  final FaceStyle style;
  final double eyeRadius;
  final double eyeGap;
  final bool blush;
  final bool hat;
  final bool glasses;
  final bool mustache;
}

class DrawingPlayground extends StatefulWidget {
  const DrawingPlayground({super.key});

  @override
  State<DrawingPlayground> createState() => _DrawingPlaygroundState();
}

class _DrawingPlaygroundState extends State<DrawingPlayground> {
  double mood = 0.82;
  double eyeRadius = 8;
  double eyeGap = 0.35;
  FaceStyle style = FaceStyle.classic;
  bool blush = false;
  bool hat = false;
  bool glasses = false;
  bool mustache = false;
  final List<FaceConfig> _undo = <FaceConfig>[];

  FaceConfig get _config => FaceConfig(
        mood: mood,
        style: style,
        eyeRadius: eyeRadius,
        eyeGap: eyeGap,
        blush: blush,
        hat: hat,
        glasses: glasses,
        mustache: mustache,
      );

  void _saveUndo() {
    _undo.add(_config);
    if (_undo.length > 30) _undo.removeAt(0);
  }

  void _change(VoidCallback change) {
    _saveUndo();
    setState(change);
  }

  void _feedback(String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger
      ..clearSnackBars()
      ..showSnackBar(SnackBar(
        content: Text(message),
        duration: const Duration(milliseconds: 1100),
        behavior: SnackBarBehavior.floating,
      ));
  }

  void _cycleFace() {
    _change(() => style = FaceStyle.values[
        (FaceStyle.values.indexOf(style) + 1) % 3]);
    _feedback('Expression: ${_faceName(style)}');
  }

  void _randomize() {
    final random = math.Random();
    _change(() {
      style = FaceStyle.values[random.nextInt(3)];
      mood = random.nextDouble();
      eyeRadius = 5 + random.nextDouble() * 8;
      blush = random.nextBool();
    });
    _feedback('Random expression created');
  }

  void _undoChange() {
    if (_undo.isEmpty) {
      _feedback('Nothing to undo yet');
      return;
    }
    final previous = _undo.removeLast();
    setState(() {
      mood = previous.mood;
      style = previous.style;
      eyeRadius = previous.eyeRadius;
      eyeGap = previous.eyeGap;
      blush = previous.blush;
      hat = previous.hat;
      glasses = previous.glasses;
      mustache = previous.mustache;
    });
    _feedback('Previous drawing restored');
  }

  static String _faceName(FaceStyle face) => switch (face) {
        FaceStyle.classic => 'Classic',
        FaceStyle.sleepy => 'Sleepy',
        FaceStyle.surprised => 'Surprised',
        FaceStyle.bullseye => 'Bullseye',
      };

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Smiley Painter Lab', style: TextStyle(fontSize: 18)),
            Text('ICA 06 · CustomPainter', style: TextStyle(fontSize: 11)),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Undo last drawing change',
            onPressed: _undoChange,
            icon: const Icon(Icons.undo_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          final landscape = constraints.maxWidth > constraints.maxHeight;
          final canvas = _drawingCanvas(colors);
          final controls = _controls(colors);
          if (landscape) {
            return Row(children: [
              Expanded(flex: 6, child: canvas),
              Expanded(flex: 5, child: controls),
            ]);
          }
          return Column(children: [
            Expanded(flex: 6, child: canvas),
            Expanded(flex: 5, child: controls),
          ]);
        }),
      ),
    );
  }

  Widget _drawingCanvas(ColorScheme colors) => Padding(
        padding: const EdgeInsets.all(12),
        child: LayoutBuilder(builder: (context, constraints) {
          final side = math.min(constraints.maxWidth, constraints.maxHeight);
          return Center(
            child: GestureDetector(
              onTap: _cycleFace,
              onLongPress: _randomize,
              child: Container(
                width: side,
                height: side,
                decoration: BoxDecoration(
                  color: const Color(0xFF191A22),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: Colors.white.withValues(alpha: .07)),
                ),
                child: CustomPaint(
                  painter: SmileyPainter(config: _config),
                  child: const SizedBox.expand(),
                ),
              ),
            ),
          );
        }),
      );

  Widget _controls(ColorScheme colors) => SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('EXPRESSIONS', style: _eyebrow(colors)),
          const SizedBox(height: 8),
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (final face in FaceStyle.values)
              ChoiceChip(
                label: Text(_faceName(face)),
                selected: style == face,
                onSelected: (_) => _change(() => style = face),
              ),
          ]),
          const SizedBox(height: 14),
          Text('MOOD  ·  ${mood.toStringAsFixed(2)}', style: _eyebrow(colors)),
          Slider(
            value: mood,
            onChanged: (value) => _change(() => mood = value),
          ),
          Row(children: [
            Expanded(child: _slider('Eye size', eyeRadius, 4, 14,
                (value) => _change(() => eyeRadius = value))),
            const SizedBox(width: 12),
            Expanded(child: _slider('Eye gap', eyeGap, .2, .52,
                (value) => _change(() => eyeGap = value))),
          ]),
          const SizedBox(height: 8),
          Text('ACCESSORIES', style: _eyebrow(colors)),
          Wrap(spacing: 4, children: [
            _accessory(Icons.face_retouching_natural, 'Blush', blush,
                (value) => _change(() => blush = value)),
            _accessory(Icons.web_asset, 'Hat', hat,
                (value) => _change(() => hat = value)),
            _accessory(Icons.visibility, 'Glasses', glasses,
                (value) => _change(() => glasses = value)),
            _accessory(Icons.face, 'Mustache', mustache,
                (value) => _change(() => mustache = value)),
          ]),
          const SizedBox(height: 8),
          Text('Tap face to cycle · Long-press to randomize',
              style: TextStyle(color: colors.onSurfaceVariant, fontSize: 12)),
        ]),
      );

  TextStyle _eyebrow(ColorScheme colors) => TextStyle(
        color: colors.primary,
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
      );

  Widget _slider(String label, double value, double min, double max,
          ValueChanged<double> changed) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label  ${value.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 12)),
          Slider(value: value, min: min, max: max, onChanged: changed),
        ],
      );

  Widget _accessory(IconData icon, String label, bool selected,
          ValueChanged<bool> onChanged) => FilterChip(
        avatar: Icon(icon, size: 17),
        label: Text(label),
        selected: selected,
        onSelected: onChanged,
        visualDensity: VisualDensity.compact,
      );
}

class SmileyPainter extends CustomPainter {
  const SmileyPainter({required this.config});
  final FaceConfig config;

  Color get _faceColor {
    if (config.mood < .35) return const Color(0xFF91C9F7);
    if (config.mood <= .7) return const Color(0xFFFFD768);
    return const Color(0xFFFFB84F);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide * .36;

    if (config.style == FaceStyle.bullseye) {
      final palette = [Colors.deepPurple, Colors.pinkAccent, Colors.amber];
      for (var i = 0; i < 3; i++) {
        canvas.drawCircle(center, radius * (1 - i * .3),
            Paint()..color = palette[i]);
      }
      return;
    }

    // Base face first; later canvas calls layer facial details on top.
    canvas.drawCircle(center, radius, Paint()..color = _faceColor);
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = const Color(0xFF332B32)
        ..style = PaintingStyle.stroke
        ..strokeWidth = radius * .035,
    );

    final eyePaint = Paint()..color = const Color(0xFF302A32);
    final eyeY = center.dy - radius * .2;
    final eyeDx = radius * config.eyeGap;
    if (config.style == FaceStyle.sleepy) {
      final sleepyEye = Paint()
        ..color = const Color(0xFF302A32)
        ..style = PaintingStyle.stroke
        ..strokeWidth = radius * .06
        ..strokeCap = StrokeCap.round;
      for (final direction in [-1.0, 1.0]) {
        final eyeCenter = Offset(center.dx + direction * eyeDx, eyeY);
        canvas.drawArc(
          Rect.fromCenter(center: eyeCenter, width: radius * .3, height: radius * .17),
          math.pi,
          math.pi,
          false,
          sleepyEye,
        );
      }
    } else {
      canvas.drawCircle(Offset(center.dx - eyeDx, eyeY), config.eyeRadius, eyePaint);
      canvas.drawCircle(Offset(center.dx + eyeDx, eyeY), config.eyeRadius, eyePaint);
    }

    if (config.blush) {
      final blushPaint = Paint()..color = const Color(0xFFFF6F91).withValues(alpha: .58);
      canvas.drawOval(
          Rect.fromCenter(
              center: Offset(center.dx - radius * .62, center.dy + radius * .13),
              width: radius * .28,
              height: radius * .14),
          blushPaint);
      canvas.drawOval(
          Rect.fromCenter(
              center: Offset(center.dx + radius * .62, center.dy + radius * .13),
              width: radius * .28,
              height: radius * .14),
          blushPaint);
    }

    if (config.style == FaceStyle.surprised) {
      canvas.drawCircle(
        Offset(center.dx, center.dy + radius * .38),
        radius * (.13 + config.mood * .05),
        Paint()
          ..color = const Color(0xFF302A32)
          ..style = PaintingStyle.stroke
          ..strokeWidth = radius * .045,
      );
    } else {
      final mouthPaint = Paint()
        ..color = const Color(0xFF302A32)
        ..style = PaintingStyle.stroke
        ..strokeWidth = radius * .055
        ..strokeCap = StrokeCap.round;
      final mouthRect = Rect.fromCenter(
        center: Offset(center.dx, center.dy + radius * .08),
        width: radius * .88,
        height: radius * (.35 + config.mood * .38),
      );
      if (config.mood < .35) {
        canvas.drawArc(mouthRect.translate(0, radius * .20), 1.15 * math.pi,
            .70 * math.pi, false, mouthPaint);
      } else {
        canvas.drawArc(mouthRect, .15 * math.pi, .70 * math.pi, false, mouthPaint);
      }
    }

    if (config.glasses) _drawGlasses(canvas, center, radius, eyeDx);
    if (config.mustache) _drawMustache(canvas, center, radius);
    if (config.hat) _drawHat(canvas, center, radius);
  }

  void _drawGlasses(Canvas canvas, Offset center, double radius, double eyeDx) {
    final paint = Paint()
      ..color = const Color(0xFF493C5F)
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius * .045;
    final y = center.dy - radius * .2;
    final width = radius * .29;
    final height = radius * .23;
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromCenter(center: Offset(center.dx - eyeDx, y), width: width, height: height),
            Radius.circular(radius * .06)),
        paint);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromCenter(center: Offset(center.dx + eyeDx, y), width: width, height: height),
            Radius.circular(radius * .06)),
        paint);
    canvas.drawLine(Offset(center.dx - radius * .08, y),
        Offset(center.dx + radius * .08, y), paint);
  }

  void _drawHat(Canvas canvas, Offset center, double radius) {
    final rect = Rect.fromCenter(
        center: Offset(center.dx, center.dy - radius * .83),
        width: radius * .95,
        height: radius * .3);
    canvas.drawRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(radius * .08)),
        Paint()..color = const Color(0xFF7257E8));
    canvas.drawRect(
        Rect.fromCenter(
            center: Offset(center.dx, rect.bottom),
            width: radius * 1.2,
            height: radius * .08),
        Paint()..color = const Color(0xFFFFD768));
  }

  void _drawMustache(Canvas canvas, Offset center, double radius) {
    final path = Path()
      ..moveTo(center.dx, center.dy + radius * .25)
      ..cubicTo(center.dx - radius * .18, center.dy + radius * .08,
          center.dx - radius * .48, center.dy + radius * .2,
          center.dx - radius * .48, center.dy + radius * .33)
      ..cubicTo(center.dx - radius * .3, center.dy + radius * .4,
          center.dx - radius * .14, center.dy + radius * .38, center.dx, center.dy + radius * .3)
      ..cubicTo(center.dx + radius * .14, center.dy + radius * .38,
          center.dx + radius * .3, center.dy + radius * .4,
          center.dx + radius * .48, center.dy + radius * .33)
      ..cubicTo(center.dx + radius * .48, center.dy + radius * .2,
          center.dx + radius * .18, center.dy + radius * .08,
          center.dx, center.dy + radius * .25)
      ..close();
    canvas.drawPath(path, Paint()..color = const Color(0xFF493C5F));
  }

  @override
  bool shouldRepaint(covariant SmileyPainter oldDelegate) =>
      oldDelegate.config.mood != config.mood ||
      oldDelegate.config.style != config.style ||
      oldDelegate.config.eyeRadius != config.eyeRadius ||
      oldDelegate.config.eyeGap != config.eyeGap ||
      oldDelegate.config.blush != config.blush ||
      oldDelegate.config.hat != config.hat ||
      oldDelegate.config.glasses != config.glasses ||
      oldDelegate.config.mustache != config.mustache;
}
