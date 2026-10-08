import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';

class PortfolioChart extends StatefulWidget {
  final List<double>? customData;
  final Color lineColor;
  final bool showTimeframes;
  final Function(double value, String label)? onScrub;

  const PortfolioChart({
    super.key,
    this.customData,
    this.lineColor = AppColors.primary,
    this.showTimeframes = true,
    this.onScrub,
  });

  @override
  State<PortfolioChart> createState() => _PortfolioChartState();
}

class _PortfolioChartState extends State<PortfolioChart> with SingleTickerProviderStateMixin {
  String selectedTimeframe = '1W';
  int? hoveredIndex;
  double? hoveredPrice;
  Offset? touchPosition;
  late AnimationController _animController;
  late Animation<double> _anim;

  final Map<String, List<double>> timeframeData = {
    '1H': [24600, 24650, 24590, 24710, 24680, 24790, 24850.50],
    '24H': [23900, 24100, 24050, 24400, 24200, 24600, 24850.50],
    '1W': [22100, 22600, 22400, 23800, 23400, 24200, 24850.50],
    '1M': [19800, 20500, 21900, 21200, 23500, 24100, 24850.50],
    '1Y': [14200, 16500, 18200, 26000, 21500, 23900, 24850.50],
    'ALL': [8500, 12000, 15400, 28000, 19000, 22500, 24850.50],
  };

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _anim = CurvedAnimation(parent: _animController, curve: Curves.easeInOutCubic);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _onTimeframeChanged(String tf) {
    if (selectedTimeframe == tf) return;
    setState(() {
      selectedTimeframe = tf;
      hoveredIndex = null;
      touchPosition = null;
    });
    _animController.reset();
    _animController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.customData ?? timeframeData[selectedTimeframe] ?? timeframeData['1W']!;
    final currencyFormatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hoveredPrice != null) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: widget.lineColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: widget.lineColor.withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.touch_app, size: 14, color: widget.lineColor),
                      const SizedBox(width: 4),
                      Text(
                        currencyFormatter.format(hoveredPrice),
                        style: TextStyle(
                          color: widget.lineColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  'Point ${hoveredIndex! + 1} of ${data.length}',
                  style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],

        // Interactive Chart Canvas
        LayoutBuilder(
          builder: (context, constraints) {
            return GestureDetector(
              onHorizontalDragUpdate: (details) => _handleTouch(details.localPosition, constraints.maxWidth, data),
              onTapDown: (details) => _handleTouch(details.localPosition, constraints.maxWidth, data),
              onTapUp: (_) => _resetHover(),
              onHorizontalDragEnd: (_) => _resetHover(),
              child: AnimatedBuilder(
                animation: _anim,
                builder: (context, child) {
                  return SizedBox(
                    width: constraints.maxWidth,
                    height: 180,
                    child: CustomPaint(
                      painter: _InteractiveChartPainter(
                        data: data,
                        progress: _anim.value,
                        lineColor: widget.lineColor,
                        touchPos: touchPosition,
                        hoveredIndex: hoveredIndex,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),

        if (widget.showTimeframes) ...[
          const SizedBox(height: 14),
          // Timeframe Pills
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.card.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: ['1H', '24H', '1W', '1M', '1Y', 'ALL'].map((tf) {
                final isSelected = selectedTimeframe == tf;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => _onTimeframeChanged(tf),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? widget.lineColor.withValues(alpha: 0.18) : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        border: isSelected
                            ? Border.all(color: widget.lineColor.withValues(alpha: 0.6), width: 1)
                            : Border.all(color: Colors.transparent),
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          tf,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isSelected ? widget.lineColor : AppColors.textSecondary,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ],
    );
  }

  void _handleTouch(Offset localPos, double width, List<double> data) {
    if (data.isEmpty) return;
    final stepX = width / (data.length - 1);
    final index = (localPos.dx / stepX).round().clamp(0, data.length - 1);
    setState(() {
      hoveredIndex = index;
      hoveredPrice = data[index];
      touchPosition = localPos;
    });
    if (widget.onScrub != null) {
      widget.onScrub!(data[index], 'Point $index');
    }
  }

  void _resetHover() {
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          hoveredIndex = null;
          hoveredPrice = null;
          touchPosition = null;
        });
      }
    });
  }
}

class _InteractiveChartPainter extends CustomPainter {
  final List<double> data;
  final double progress;
  final Color lineColor;
  final Offset? touchPos;
  final int? hoveredIndex;

  _InteractiveChartPainter({
    required this.data,
    required this.progress,
    required this.lineColor,
    this.touchPos,
    this.hoveredIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.length < 2) return;

    final minVal = data.reduce(min);
    final maxVal = data.reduce(max);
    final range = (maxVal - minVal) == 0 ? 1.0 : (maxVal - minVal);

    // Draw horizontal reference grid lines
    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.04)
      ..strokeWidth = 1.0;

    for (int i = 1; i <= 3; i++) {
      final y = size.height * (i / 4);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final path = Path();
    final fillPath = Path();
    final stepX = size.width / (data.length - 1);

    final points = <Offset>[];

    for (int i = 0; i < data.length; i++) {
      final x = i * stepX;
      final normalizedY = (data[i] - minVal) / range;
      // Animate from bottom to top
      final targetY = size.height - (normalizedY * (size.height - 30)) - 15;
      final y = size.height - (size.height - targetY) * progress;

      points.add(Offset(x, y));

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        final prev = points[i - 1];
        final controlX = (prev.dx + x) / 2;
        path.cubicTo(controlX, prev.dy, controlX, y, x, y);
        fillPath.cubicTo(controlX, prev.dy, controlX, y, x, y);
      }
    }

    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    // Gradient Fill
    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          lineColor.withValues(alpha: 0.28 * progress),
          lineColor.withValues(alpha: 0.05 * progress),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    canvas.drawPath(fillPath, fillPaint);

    // Glow Effect
    final glowPaint = Paint()
      ..color = lineColor.withValues(alpha: 0.4 * progress)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawPath(path, glowPaint);

    // Primary Stroke
    final strokePaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, strokePaint);

    // Draw End point pulsating dot
    if (points.isNotEmpty && hoveredIndex == null) {
      final lastPoint = points.last;
      final outerDotPaint = Paint()
        ..color = lineColor.withValues(alpha: 0.3)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(lastPoint, 8, outerDotPaint);

      final innerDotPaint = Paint()
        ..color = lineColor
        ..style = PaintingStyle.fill;
      canvas.drawCircle(lastPoint, 4, innerDotPaint);
    }

    // Draw touch indicator crosshair & cursor
    if (hoveredIndex != null && hoveredIndex! < points.length) {
      final targetPoint = points[hoveredIndex!];

      // Vertical dashed indicator line
      final linePaint = Paint()
        ..color = Colors.white.withValues(alpha: 0.4)
        ..strokeWidth = 1.2
        ..style = PaintingStyle.stroke;

      _drawDashedLine(canvas, Offset(targetPoint.dx, 0), Offset(targetPoint.dx, size.height), linePaint);

      // Glowing touch point
      final haloPaint = Paint()
        ..color = lineColor.withValues(alpha: 0.35)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(targetPoint, 10, haloPaint);

      final dotPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
      canvas.drawCircle(targetPoint, 5, dotPaint);

      final corePaint = Paint()
        ..color = lineColor
        ..style = PaintingStyle.fill;
      canvas.drawCircle(targetPoint, 3, corePaint);
    }
  }

  void _drawDashedLine(Canvas canvas, Offset p1, Offset p2, Paint paint) {
    const dashHeight = 4.0;
    const dashSpace = 4.0;
    double startY = p1.dy;
    while (startY < p2.dy) {
      canvas.drawLine(
        Offset(p1.dx, startY),
        Offset(p1.dx, min(startY + dashHeight, p2.dy)),
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant _InteractiveChartPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.hoveredIndex != hoveredIndex ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.data != data;
  }
}
