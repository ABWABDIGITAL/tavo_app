import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tavo/core/localization/locale_keys.dart';
import 'package:tavo/core/theme/colors.dart';
import 'package:tavo/core/theme/text_styles.dart';
import 'package:tavo/core/theme/theme_extensions.dart';
import 'package:tavo/feature/booking/data/model/available_table_model.dart';

class VisualTableMap extends StatefulWidget {
  final List<AvailableTable> tables;
  final Set<String> selectedTableIds;
  final Function(String) onTableTap;

  const VisualTableMap({
    super.key,
    required this.tables,
    required this.selectedTableIds,
    required this.onTableTap,
  });

  @override
  State<VisualTableMap> createState() => _VisualTableMapState();
}

class _VisualTableMapState extends State<VisualTableMap>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  String? _lastSelectedId;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onTableTap(String tableId) {
    if (_lastSelectedId != tableId) {
      _animationController.forward().then(
        (_) => _animationController.reverse(),
      );
    }
    _lastSelectedId = tableId;
    widget.onTableTap(tableId);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: context.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLegend(),
          SizedBox(height: 16.h),
          Expanded(child: _buildFloorPlan()),
          if (widget.selectedTableIds.isNotEmpty) ...[
            SizedBox(height: 12.h),
            _buildSelectedInfo(),
          ],
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem(ColorsManager.primaryColor, LocaleKeys.available.tr()),
        SizedBox(width: 20.w),
        _buildLegendItem(const Color(0xFF9E9E9E), LocaleKeys.unavailable.tr()),
        SizedBox(width: 20.w),
        _buildLegendItem(const Color(0xFF1976D2), LocaleKeys.selected.tr()),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 14.r,
          height: 14.r,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4.r),
          ),
        ),
        SizedBox(width: 6.w),
        Text(
          label,
          style: TextStyle(
            color: ColorsManager.darkGray300,
            fontSize: 11.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildFloorPlan() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [_buildBackground(), ..._buildTables(constraints)],
        );
      },
    );
  }

  Widget _buildBackground() {
    return Positioned.fill(child: CustomPaint(painter: _FloorPlanPainter()));
  }

  List<Widget> _buildTables(BoxConstraints constraints) {
    if (widget.tables.isEmpty) {
      return [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.table_restaurant,
                size: 48.r,
                color: ColorsManager.grey200,
              ),
              SizedBox(height: 8.h),
              Text(
                LocaleKeys.noTablesAvailable.tr(),
                style: TextStyles.font14DarkGray400Weight(context),
              ),
            ],
          ),
        ),
      ];
    }

    final List<Widget> tableWidgets = [];

    for (int i = 0; i < widget.tables.length; i++) {
      final table = widget.tables[i];
      final position = _getTablePosition(i, widget.tables.length, constraints);
      final isSelected = widget.selectedTableIds.contains(table.id);

      tableWidgets.add(
        Positioned(
          left: position.dx,
          top: position.dy,
          child: GestureDetector(
            onTap: () => _onTableTap(table.id),
            child: AnimatedScale(
              scale: isSelected ? 1.1 : 1.0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: _getTableWidth(table.seats),
                height: _getTableHeight(table.seats),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF1976D2)
                      : ColorsManager.primaryColor,
                  borderRadius: _getTableShape(table.seats),
                  boxShadow: [
                    BoxShadow(
                      color:
                          (isSelected
                                  ? const Color(0xFF1976D2)
                                  : ColorsManager.primaryColor)
                              .withValues(alpha: 0.3),
                      blurRadius: isSelected ? 12 : 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.table_restaurant,
                      color: ColorsManager.white,
                      size: 20.r,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      table.code,
                      style: TextStyle(
                        color: ColorsManager.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '${table.seats}',
                      style: TextStyle(
                        color: ColorsManager.white.withValues(alpha: 0.8),
                        fontSize: 8.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    return tableWidgets;
  }

  Offset _getTablePosition(int index, int total, BoxConstraints constraints) {
    final positions = [
      const Offset(20, 20),
      const Offset(100, 20),
      const Offset(180, 20),
      const Offset(20, 100),
      const Offset(100, 100),
      const Offset(180, 100),
      const Offset(20, 180),
      const Offset(100, 180),
      const Offset(180, 180),
    ];

    if (index < positions.length) {
      return positions[index];
    }
    return Offset(20 + (index % 3) * 80.0, 20 + (index ~/ 3) * 80.0);
  }

  double _getTableWidth(int seats) {
    if (seats <= 2) return 50.w;
    if (seats <= 4) return 60.w;
    if (seats <= 6) return 75.w;
    return 90.w;
  }

  double _getTableHeight(int seats) {
    return _getTableWidth(seats) * 0.7;
  }

  BorderRadius _getTableShape(int seats) {
    if (seats <= 2) {
      return BorderRadius.circular(30.r);
    } else if (seats <= 4) {
      return BorderRadius.circular(12.r);
    } else {
      return BorderRadius.circular(16.r);
    }
  }

  Widget _buildSelectedInfo() {
    final selectedTables = widget.tables
        .where((t) => widget.selectedTableIds.contains(t.id))
        .toList();

    final totalSeats = selectedTables.fold(0, (sum, t) => sum + t.seats);
    final tableNames = selectedTables.map((t) => t.code).join(', ');

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFF1976D2).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: const Color(0xFF1976D2), size: 20.r),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${widget.selectedTableIds.length} ${LocaleKeys.tables.tr()} ($tableNames)',
                  style: TextStyle(
                    color: ColorsManager.black,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '$totalSeats ${LocaleKeys.seats.tr()}',
                  style: TextStyle(
                    color: ColorsManager.darkGray300,
                    fontSize: 10.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FloorPlanPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ColorsManager.grey200
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Draw grid lines
    for (double i = 0; i < size.width; i += 40) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += 40) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }

    // Draw entrance
    final entrancePaint = Paint()
      ..color = ColorsManager.darkGray300
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(size.width / 2 - 20, size.height - 10),
      Offset(size.width / 2 + 20, size.height - 10),
      entrancePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
