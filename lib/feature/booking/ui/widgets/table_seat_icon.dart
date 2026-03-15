import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tavo/core/theme/colors.dart';

class TableSeatIcon extends StatelessWidget {
  final int seats;
  final bool isSelected;
  final double size;

  const TableSeatIcon({
    super.key,
    required this.seats,
    this.isSelected = false,
    this.size = 50,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          painter: _TableSeatPainter(seats: seats, isSelected: isSelected),
        ),
      ),
    );
  }
}

class _TableSeatPainter extends CustomPainter {
  final int seats;
  final bool isSelected;

  _TableSeatPainter({required this.seats, required this.isSelected});

  @override
  void paint(Canvas canvas, Size size) {
    final primaryColor = ColorsManager.primaryColor;
    final whiteColor = Colors.white;

    final tableWidth = size.width * 0.45;
    final tableHeight = size.height * 0.32;
    final tableLeft = (size.width - tableWidth) / 2;
    final tableTop = (size.height - tableHeight) / 2;
    final seatRadius = size.width * 0.1;

    final tablePaint = Paint()
      ..color = isSelected ? primaryColor : primaryColor.withValues(alpha: 0.85)
      ..style = PaintingStyle.fill;

    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.12)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    final tableRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(tableLeft + 2, tableTop + 3, tableWidth, tableHeight),
      Radius.circular(size.width * 0.1),
    );
    canvas.drawRRect(tableRect, shadowPaint);

    final tableRect2 = RRect.fromRectAndRadius(
      Rect.fromLTWH(tableLeft, tableTop, tableWidth, tableHeight),
      Radius.circular(size.width * 0.1),
    );
    canvas.drawRRect(tableRect2, tablePaint);

    final seatFillPaint = Paint()
      ..color = isSelected ? whiteColor : primaryColor
      ..style = PaintingStyle.fill;

    final seatBorderPaint = Paint()
      ..color = isSelected ? primaryColor.withValues(alpha: 0.3) : whiteColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final positions = _getSeatPositions(seats, size, seatRadius);
    for (int i = 0; i < positions.length; i++) {
      final pos = positions[i];
      final animProgress = isSelected ? 1.0 : 0.0;
      final scale = isSelected ? 1.0 + (i * 0.05) : 1.0;
      final currentRadius = seatRadius * scale;

      canvas.drawCircle(pos, currentRadius, seatFillPaint);
      canvas.drawCircle(pos, currentRadius, seatBorderPaint);
    }
  }

  List<Offset> _getSeatPositions(int seats, Size size, double radius) {
    final positions = <Offset>[];
    final s = seats.clamp(0, 10);
    final w = size.width;
    final h = size.height;
    final padding = radius * 0.8;

    if (s == 1) {
      positions.add(Offset(w * 0.5, h * 0.08));
    } else if (s == 2) {
      positions.add(Offset(w * 0.22, h * 0.25));
      positions.add(Offset(w * 0.78, h * 0.25));
    } else if (s == 3) {
      positions.add(Offset(w * 0.5, h * 0.08));
      positions.add(Offset(w * 0.18, h * 0.68));
      positions.add(Offset(w * 0.82, h * 0.68));
    } else if (s == 4) {
      positions.add(Offset(w * 0.18, h * 0.18));
      positions.add(Offset(w * 0.82, h * 0.18));
      positions.add(Offset(w * 0.18, h * 0.72));
      positions.add(Offset(w * 0.82, h * 0.72));
    } else if (s == 5) {
      positions.add(Offset(w * 0.5, h * 0.06));
      positions.add(Offset(w * 0.15, h * 0.42));
      positions.add(Offset(w * 0.85, h * 0.42));
      positions.add(Offset(w * 0.15, h * 0.78));
      positions.add(Offset(w * 0.85, h * 0.78));
    } else if (s == 6) {
      positions.add(Offset(w * 0.15, h * 0.12));
      positions.add(Offset(w * 0.5, h * 0.06));
      positions.add(Offset(w * 0.85, h * 0.12));
      positions.add(Offset(w * 0.15, h * 0.72));
      positions.add(Offset(w * 0.5, h * 0.84));
      positions.add(Offset(w * 0.85, h * 0.72));
    } else if (s == 7) {
      positions.add(Offset(w * 0.12, h * 0.1));
      positions.add(Offset(w * 0.42, h * 0.05));
      positions.add(Offset(w * 0.72, h * 0.1));
      positions.add(Offset(w * 0.95, h * 0.38));
      positions.add(Offset(w * 0.12, h * 0.62));
      positions.add(Offset(w * 0.5, h * 0.9));
      positions.add(Offset(w * 0.88, h * 0.78));
    } else {
      positions.add(Offset(w * 0.1, h * 0.1));
      positions.add(Offset(w * 0.38, h * 0.05));
      positions.add(Offset(w * 0.66, h * 0.1));
      positions.add(Offset(w * 0.92, h * 0.35));
      positions.add(Offset(w * 0.1, h * 0.6));
      positions.add(Offset(w * 0.38, h * 0.9));
      positions.add(Offset(w * 0.66, h * 0.9));
      positions.add(Offset(w * 0.92, h * 0.75));
    }

    return positions;
  }

  @override
  bool shouldRepaint(covariant _TableSeatPainter oldDelegate) {
    return oldDelegate.seats != seats || oldDelegate.isSelected != isSelected;
  }
}
