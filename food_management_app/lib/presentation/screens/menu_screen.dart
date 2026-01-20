import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_management_app/data/models/meal.dart';
import 'package:intl/intl.dart';
import '../../data/models/meal_plan.dart';
import '../../state/bloc/meal_plan/meal_plan_bloc.dart';
import '../../state/bloc/navigation/navigation_bloc.dart';
import '../../state/bloc/navigation/navigation_event.dart';
import '../../state/bloc/menu/menu_ui_cubit.dart';

class MenuScreen extends StatelessWidget {
  final MealPlan? plan; // Optional plan to display

  const MenuScreen({super.key, this.plan});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MenuUiCubit(),
      child: BlocBuilder<MenuUiCubit, MenuUiState>(
        builder: (context, uiState) {
          final isDark = Theme.of(context).brightness == Brightness.dark;

          final bgColor = isDark
              ? const Color(0xFF262832)
              : const Color(0xFFF5F5F5);
          final textColor = isDark ? Colors.white : Colors.black87;
          final secondaryTextColor = isDark ? Colors.white54 : Colors.black54;
          final borderColor = isDark ? Colors.white24 : Colors.grey;
          final cardColor = isDark ? const Color(0xFF2F3344) : Colors.white;
          final dateRowBg = isDark ? Colors.grey[500]! : Colors.grey[300];
          final datePillBg = isDark ?   Colors.grey[500] : Colors.white;
          final datePillText = isDark ? const Color(0xFF262832) : Colors.black;

          final now = DateTime.now();
          final formattedDate = DateFormat('d MMMM').format(now);
          final days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

          return BlocBuilder<MealPlanBloc, MealPlanState>(
            builder: (context, state) {
              List<MealPlan> allPlans = [];
              if (state is MealPlanLoaded) {
                allPlans = state.plans;
              }

              final currentPlan =
                  plan ?? (allPlans.isNotEmpty ? allPlans.first : null);

              // Helper to get meal data safely
              Meal? getMeal(String type) {
                if (currentPlan == null) return null;
                try {
                  return currentPlan.meals.firstWhere(
                    (m) => m.type.toLowerCase() == type,
                  );
                } catch (_) {
                  return null;
                }
              }

              final breakfast = getMeal('breakfast');
              final lunch = getMeal('lunch');
              final snacks = getMeal('snacks');
              final dinner = getMeal('dinner');

              return Scaffold(
                backgroundColor: bgColor,
                body: Column(
                  children: [
                    const SizedBox(height: 16),

                    // Plan Dropdown 
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (currentPlan == null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: borderColor),
                                borderRadius: BorderRadius.circular(8),
                                color: cardColor,
                              ),
                              child: Text(
                                'No Plans Available',
                                style: TextStyle(color: textColor),
                              ),
                            )
                          else
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: borderColor,width: 2),
                                borderRadius: BorderRadius.circular(8),
                                color: cardColor,
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<MealPlan>(
                                  value: allPlans.contains(currentPlan)
                                      ? currentPlan
                                      : null,
                                  dropdownColor: cardColor,
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: textColor,
                                  ),
                                  style: TextStyle(color: textColor),
                                  hint: Text(
                                    currentPlan.name,
                                    style: TextStyle(color: textColor),
                                  ),
                                  items: allPlans.map((MealPlan plan) {
                                    return DropdownMenuItem<MealPlan>(
                                      value: plan,
                                      child: Text(
                                        plan.name,
                                        style: TextStyle(color: textColor),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (MealPlan? newValue) {
                                    if (newValue != null) {
                                      context.read<NavigationBloc>().add(
                                        ChangeTab(1, selectedPlan: newValue),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                          
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Days Row
                    Container(
                      color: dateRowBg,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: List.generate(days.length, (index) {
                          final isSelected = index == uiState.selectedDayIndex;
                          return GestureDetector(
                            onTap: () =>
                                context.read<MenuUiCubit>().selectDay(index),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: isSelected
                                  ? BoxDecoration(
                                      color: isDark
                                          ? const Color(0xFF262832)
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                    )
                                  : null,
                              child: Text(
                                days[index],
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.blue
                                      : (isDark
                                            ? const Color(
                                                0xFF262832,
                                              ).withOpacity(0.6)
                                            : Colors.black54),
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

                    // Date Pill
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: datePillBg,
                            borderRadius: BorderRadius.circular(8),
                            border: isDark
                                ? null
                                : Border.all(color: Colors.black12),
                          ),
                          child: Text(
                            formattedDate,
                            style: TextStyle(
                              color: datePillText,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Meal Accordions
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        children: [
                          Column(
                            children: [
                              // Breakfast
                              _buildAccordion(
                                context: context,
                                title: 'Breakfast',
                                time:
                                    breakfast != null &&
                                        breakfast.startTime.isNotEmpty
                                    ? '${breakfast.startTime} - ${breakfast.endTime}'
                                    : '8:00am - 9:30am',
                                isExpanded: true,
                                onTap: () => context
                                    .read<MenuUiCubit>()
                                    .toggleSection('breakfast'),
                                items: breakfast?.items ?? [],
                                isBlueTitle: _isCurrentMeal(
                                  breakfast?.startTime,
                                  breakfast?.endTime,
                                ),
                                isDark: isDark,
                                bgColor: cardColor,
                                textColor: textColor,
                                secondaryTextColor: secondaryTextColor,
                                borderColor: borderColor,
                              ),
                              const SizedBox(height: 12),

                              // Lunch
                              _buildAccordion(
                                context: context,
                                title: 'Lunch',
                                time:
                                    lunch != null && lunch.startTime.isNotEmpty
                                    ? '${lunch.startTime} - ${lunch.endTime}'
                                    : '12:30pm - 2:30pm',
                                isExpanded:true,
                                onTap: () => context
                                    .read<MenuUiCubit>()
                                    .toggleSection('lunch'),
                                items: lunch?.items ?? [],
                                isBlueTitle: _isCurrentMeal(
                                  lunch?.startTime,
                                  lunch?.endTime,
                                ),
                                isDark: isDark,
                                bgColor: cardColor,
                                textColor: textColor,
                                secondaryTextColor: secondaryTextColor,
                                borderColor: borderColor,
                              ),
                              const SizedBox(height: 12),

                              // Snacks
                              _buildAccordion(
                                context: context,
                                title: 'Snacks',
                                time:
                                    snacks != null &&
                                        snacks.startTime.isNotEmpty
                                    ? '${snacks.startTime} - ${snacks.endTime}'
                                    : '5:00pm - 6:30pm',
                                isExpanded: true,
                                onTap: () => context
                                    .read<MenuUiCubit>()
                                    .toggleSection('snacks'),
                                items: snacks?.items ?? [],
                                isBlueTitle: _isCurrentMeal(
                                  snacks?.startTime,
                                  snacks?.endTime,
                                ),
                                isDark: isDark,
                                bgColor: cardColor,
                                textColor: textColor,
                                secondaryTextColor: secondaryTextColor,
                                borderColor: borderColor,
                              ),
                              const SizedBox(height: 12),

                              // Dinner
                              _buildAccordion(
                                context: context,
                                title: 'Dinner',
                                time:
                                    dinner != null &&
                                        dinner.startTime.isNotEmpty
                                    ? '${dinner.startTime} - ${dinner.endTime}'
                                    : '8:30pm - 10:30pm',
                                isExpanded: true,
                                onTap: () => context
                                    .read<MenuUiCubit>()
                                    .toggleSection('dinner'),
                                items: dinner?.items ?? [],
                                isBlueTitle: _isCurrentMeal(
                                  dinner?.startTime,
                                  dinner?.endTime,
                                ),
                                isDark: isDark,
                                bgColor: cardColor,
                                textColor: textColor,
                                secondaryTextColor: secondaryTextColor,
                                borderColor: borderColor,
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  List<dynamic> _getItems({MealPlan? currentPlan, required String type}) {
    if (currentPlan == null) return [];
    try {
      return currentPlan.meals
          .firstWhere((m) => m.type.toLowerCase() == type.toLowerCase())
          .items;
    } catch (_) {
      return [];
    }
  }

  bool _isCurrentMeal(String? startStr, String? endStr) {
    if (startStr == null || endStr == null) return false;
    try {
      final now = TimeOfDay.now();
      final nowMinutes = now.hour * 60 + now.minute;

      int parseTime(String timeStr) {
        timeStr = timeStr.trim().toLowerCase();
        final isPm = timeStr.contains('pm');
        final isAm = timeStr.contains('am');
        timeStr = timeStr.replaceAll(
          RegExp(r'[a-z\s]'),
          '',
        ); // Remove am/pm and spaces

        final parts = timeStr.split(':');
        int hour = int.parse(parts[0]);
        int minute = parts.length > 1 ? int.parse(parts[1]) : 0;

        if (isPm && hour != 12) hour += 12;
        if (isAm && hour == 12) hour = 0;

        return hour * 60 + minute;
      }

      final startMinutes = parseTime(startStr);
      final endMinutes = parseTime(endStr);

      // Handle overnight range (e.g. 10pm to 2am)
      if (endMinutes < startMinutes) {
        return nowMinutes >= startMinutes || nowMinutes <= endMinutes;
      }

      return nowMinutes >= startMinutes && nowMinutes <= endMinutes;
    } catch (e) {
      return false;
    }
  }

  Widget _buildAccordion({
    required BuildContext context,
    required String title,
    required String time,
    required bool isExpanded,
    required VoidCallback onTap,
    required List<dynamic> items,
    bool isBlueTitle = false,
    required bool isDark,
    required Color bgColor,
    required Color textColor,
    required Color secondaryTextColor,
    required Color borderColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isBlueTitle
                              ? (isDark ? Colors.blue : Colors.blue[700])
                              : textColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Timing: $time',
                        style: TextStyle(
                          color: secondaryTextColor,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: secondaryTextColor,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded && items.isNotEmpty)
            Container(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: [
                  Divider(color: borderColor),
                  ...items.map((item) {
                    final isVeg = item.diet == 'veg'; // Assuming model
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            isVeg ? 'assets/veg.svg' : 'assets/non-veg.svg',
                            width: 16,
                            height: 16,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            item.name,
                            style: TextStyle(color: textColor, fontSize: 16),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            )
          else if (isExpanded)
            const SizedBox(height: 0), // Empty state
        ],
      ),
    );
  }
}
