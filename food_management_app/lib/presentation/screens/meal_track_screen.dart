import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../../data/models/meal_plan.dart';
import '../../state/bloc/attendance/attendance_bloc.dart';
import '../../state/bloc/meal_plan/meal_plan_bloc.dart';
import '../../state/bloc/meal_track/meal_track_ui_cubit.dart';

class MealTrackScreen extends StatelessWidget {
  const MealTrackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MealTrackUiCubit(),
      child: BlocBuilder<MealTrackUiCubit, MealTrackUiState>(
        builder: (context, uiState) {
          final isDark = Theme.of(context).brightness == Brightness.dark;

          final bgColor = isDark
              ? const Color(0xFF1E2026)
              : const Color(0xFFF5F7FA);
          final cardBg = isDark ? const Color(0xFF2F3344) : Colors.white;
          final textColor = isDark ? Colors.white : const Color(0xFF2D3142);
          final subTextColor = isDark ? Color(0xFF2D3142) : Colors.grey[600];

          final now = DateTime.now();
          final formattedDate = DateFormat('d MMMM').format(now);
          final days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

          return Scaffold(
            backgroundColor: bgColor,
            body: Column(
              children: [
                const SizedBox(height: 16),

                // --- Plan Selector ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: BlocBuilder<MealPlanBloc, MealPlanState>(
                      builder: (context, state) {
                        List<MealPlan> allPlans = [];
                        if (state is MealPlanLoaded) allPlans = state.plans;
                        final currentPlan = allPlans.isNotEmpty
                            ? allPlans.first
                            : null;

                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isDark
                                  ? Colors.white30
                                  : Colors.grey.shade400,
                            ),
                            borderRadius: BorderRadius.circular(8),
                            color: isDark
                                ? const Color(0xFF2F3344)
                                : Colors.transparent,
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<MealPlan>(
                              value: currentPlan,
                              dropdownColor: isDark
                                  ? const Color(0xFF2F3344)
                                  : Colors.white,
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: textColor,
                              ),
                              style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.w500,
                              ),
                             
                              isDense: true,
                              items: allPlans
                                  .map(
                                    (p) => DropdownMenuItem(
                                      value: p,
                                      child: Text(p.name),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (val) {
                                // Handle plan change
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // --- Day Selector ---
                Container(
                  color: isDark ?  Colors.grey[500] : Colors.grey[200],
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(days.length, (index) {
                      final isSelected = index == uiState.selectedDayIndex;
                      return GestureDetector(
                        onTap: () =>
                            context.read<MealTrackUiCubit>().selectDay(index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: isSelected
                              ? BoxDecoration(
                                  color: isDark
                                      ? Color(0xFF2F3344)
                                      : Colors.white, // Selected dark bg
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: !isDark ? [
                                    BoxShadow(
                                      color: Colors.grey[400]!,
                                      blurRadius: 2,
                                      offset: Offset(0, 1),
                                    ),
                                  ]: [],
                                )
                              : null,
                          child: Text(
                            days[index],
                            style: TextStyle(
                              color: isSelected
                                  ? const Color(
                                      0xFF4A90E2,
                                    ) // Blue text for selected
                                  : subTextColor,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),

                // --- Date Pill ---
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF4C4F5A)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        formattedDate,
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ),

                // --- Stats List ---
                Expanded(
                  child: BlocBuilder<AttendanceBloc, AttendanceState>(
                    builder: (context, attendanceState) {
                      return ListView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        children: [
                          _buildMealCard(
                            context,
                            'Breakfast',
                            'assets/breakfast.svg',
                            16,
                            12,
                            isDark,
                            0,
                          ),
                          const SizedBox(height: 12),
                          _buildMealCard(
                            context,
                            'Lunch',
                            'assets/lunch.svg',
                            15,
                            10,
                            isDark,
                            1,
                          ),
                          const SizedBox(height: 12),
                          _buildMealCard(
                            context,
                            'Snacks',
                            'assets/croissant.svg',
                            15,
                            6,
                            isDark,
                            2,
                          ),
                          const SizedBox(height: 12),
                          _buildMealCard(
                            context,
                            'Dinner',
                            'assets/dinner.svg',
                            16,
                            12,
                            isDark,
                            3,
                          ),
                          const SizedBox(height: 20),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMealCard(
    BuildContext context,
    String title,
    String iconPath,
    int present,
    int absent,
    bool isDark,
    int index,
  ) {
    final cardBg = isDark ? const Color(0xFF2F3344) : Colors.white;
    final borderColor = isDark ? Colors.white10 : Colors.black12;
    // Alternate slant based on index (Evens: Top-Right to Bottom-Right-Out, Odds: Top-Right-Out to Bottom-Right)
    final bool isEven = index % 2 == 0;

    return Container(
      height: 110,
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Stack(
        children: [
          // Content Layer
          Row(
            children: [
              // Left Side (Icon + Title) - Placeholder for size
              const SizedBox(width: 120),

              // Right Side (Stats)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Present
                          _buildStatBadge(present, Colors.green, true),
                          // Absent
                          _buildStatBadge(absent, Colors.red, false),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '$absent people are unable to\nattend $title.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.grey[700],
                          fontSize: 12,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Slash Background Layer (Positioned on top of content for the left side)
          ClipPath(
            clipper: SlashClipper(reverse: !isEven),
            child: Container(
              width: 120, // Width must match the placeholder above
              decoration: BoxDecoration(
                color: const Color(0xFF3C4155), // Dark blue/purple accent
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [const Color(0xFF4B4F65), const Color(0xFF383C4F)]
                      : [
                          Color.fromARGB(255, 210, 234, 252),
                          const Color.fromARGB(255, 210, 234, 252),
                        ],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      iconPath,
                      width: 45,
                      height: 45,
                      colorFilter: isDark
                          ? ColorFilter.mode(Colors.white, BlendMode.srcIn)
                          : ColorFilter.mode(
                              Colors.grey[800]!,
                              BlendMode.srcIn,
                            ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      title,
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.grey[800],
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatBadge(int count, Color color, bool isPresent) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            border: Border.all(color: color, width: 2),
            borderRadius: BorderRadius.circular(4),
          ),
          alignment: Alignment.center,
          child: isPresent
              ? Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                )
              : Icon(
                  Icons.change_history,
                  size: 14,
                  color: color,
                ), // Triangle approximation
        ),
        const SizedBox(width: 8),
        Text(
          '$count',
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class SlashClipper extends CustomClipper<Path> {
  final bool reverse;
  SlashClipper({this.reverse = false});

  @override
  Path getClip(Size size) {
    var path = Path();
    if (!reverse) {
      // Standard: / Shape (leaning right)
      path.lineTo(size.width - 30, 0);
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
    } else {
      // Reverse: \ Shape (leaning left)
      path.lineTo(size.width, 0);
      path.lineTo(size.width - 30, size.height);
      path.lineTo(0, size.height);
    }
    path.close();
    return path;
  }

  @override
  bool shouldReclip(SlashClipper oldClipper) => oldClipper.reverse != reverse;
}
