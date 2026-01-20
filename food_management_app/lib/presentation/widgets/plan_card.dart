import 'package:flutter/material.dart';
import 'dotted_line_painter.dart';

class PlanCard extends StatelessWidget {
  final String title;
  final int amount;
  final List<String> mealTypes;
  final String frequency;
  final VoidCallback? onTap;

  const PlanCard({
    super.key,
    required this.title,
    required this.amount,
    required this.mealTypes,
    this.frequency = '',
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final containerBg = isDark ? const Color(0xFF2F3344) : Colors.white;
    final titleBg = isDark ? Colors.grey[400] : Colors.white;
    final titleColor = Colors.grey[700];
    final textColor = isDark ? Colors.grey[400] : Colors.grey[700];
    final bottomBg = isDark
        ? const Color.fromARGB(255, 40, 38, 61)
        : Colors.blue[100];
    final bottomLabelColor = isDark ? Colors.white70 : Colors.black54;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shadowColor: isDark ? Colors.white12 : Colors.black12,
        margin: const EdgeInsets.only(bottom: 12),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              width: double.infinity,
              decoration: BoxDecoration(color: titleBg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    !isDark && frequency.isNotEmpty
                        ? '${frequency[0].toUpperCase()}${frequency.substring(1)} $title'
                        : title,
                    style: TextStyle(
                      fontSize: 18,
                      color: titleColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (!isDark) ...[
                     const SizedBox(height: 8),
                     CustomPaint(
                       size: const Size(double.infinity, 1),
                       painter: DottedLinePainter(),
                     ),
                  ],
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(color: containerBg),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  if (mealTypes.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 90,
                        right: 12.0,
                        top: 12,
                        bottom: 12,
                      ),
                      child: GridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        childAspectRatio: 5,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        children: mealTypes
                            .map(
                              (type) => Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.circle, size: 6, color: textColor),
                                  const SizedBox(width: 8),
                                  Text(
                                    type,
                                    style: TextStyle(
                                      color: textColor,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                            )
                            .toList(),
                      ),
                    ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              color: bottomBg,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Amount',
                    style: TextStyle(color: bottomLabelColor, fontSize: 16),
                  ),
                  Text(
                    '₹ $amount',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
