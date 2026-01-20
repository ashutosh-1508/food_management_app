import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TopTabToggle extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onChanged;

  const TopTabToggle({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tabimg = [
      'assets/notepad.svg',
      'assets/group.svg',
      'assets/food-tracking.svg',
      'assets/feedback.svg',
    ];
    final tabs = ['Meal Plan', 'Menu', 'Meal Track', 'Feedback'];

    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(tabs.length, (index) {
            final isSelected = index == selectedIndex;
            return GestureDetector(
              onTap: () => onChanged(index),
              child: Column(
                children: [
                  Column(
                    children: [
                      SvgPicture.asset(
                        height: 30,
                        width: 30,  
                        tabimg[index],
                        colorFilter: ColorFilter.mode(
                          isSelected 
                            ? Colors.lightBlue 
                            : (isDark ? Colors.white54 : Colors.grey[800]!),
                          BlendMode.srcIn,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        tabs[index],
                        style: TextStyle(
                          color: isSelected 
                            ? Colors.lightBlue 
                            : (isDark ? Colors.white54 : Colors.grey[800]),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                  if (isSelected)
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      height: 2,
                      width: 100,
                      color: Colors.lightBlue,
                    ),
                ],
              ),
            );
          }),
        );
      },
    );
  }
}
