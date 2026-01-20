import 'package:flutter/material.dart';
import '../../data/models/meal_plan.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MenuScreen extends StatefulWidget {
  final MealPlan? plan; // Optional plan to display

  const MenuScreen({super.key, this.plan});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  // Mock data/state for days and toggling sections
  final List<String> days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  int selectedDayIndex = 4; // Tue roughly matches image active state

  // Expanded states for sections
  bool isBreakfastExpanded = true;
  bool isLunchExpanded = true;
  bool isSnacksExpanded = true;
  bool isDinnerExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF262832),

      body: Column(
        children: [
          const SizedBox(height: 16),

          // Plan Dropdown and Edit Icon
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white24),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Text(
                        widget.plan?.name ?? 'Option Plan 1',
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_drop_down, color: Colors.white),
                    ],
                  ),
                ),
                const Icon(Icons.edit_outlined, color: Colors.white54),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Days Row
          Container(
            color: const Color(0xFFCFD1D6), // Light grey background like image
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(days.length, (index) {
                final isSelected = index == selectedDayIndex;
                return GestureDetector(
                  onTap: () => setState(() => selectedDayIndex = index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: isSelected
                        ? BoxDecoration(
                            color: const Color(0xFF262832),
                            borderRadius: BorderRadius.circular(8),
                          )
                        : null,
                    child: Text(
                      days[index],
                      style: TextStyle(
                        color: isSelected
                            ? Colors.blue
                            : const Color(0xFF262832).withOpacity(0.6),
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
                  color: const Color(0xFFCFD1D6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  '7 October',
                  style: TextStyle(
                    color: Color(0xFF262832),
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
                // Breakfast
                _buildAccordion(
                  title: 'Breakfast',
                  time: '8:00am - 9:30am',
                  isExpanded: isBreakfastExpanded,
                  onTap: () => setState(
                    () => isBreakfastExpanded = !isBreakfastExpanded,
                  ),
                  items:
                      widget.plan?.meals
                          .firstWhere(
                            (m) => m.type == 'breakfast',
                            orElse: () => widget.plan!.meals.first,
                          )
                          .items ??
                      [],
                ),
                const SizedBox(height: 12),

                // Lunch
                _buildAccordion(
                  title: 'Lunch',
                  time: '12:30pm - 2:30pm',
                  isExpanded: isLunchExpanded,
                  onTap: () =>
                      setState(() => isLunchExpanded = !isLunchExpanded),
                  items:
                      widget.plan?.meals
                          .firstWhere(
                            (m) => m.type == 'lunch',
                            orElse: () => widget.plan!.meals.first,
                          )
                          .items ??
                      [],
                  isBlueTitle: true,
                ),
                const SizedBox(height: 12),

                // Snacks
                _buildAccordion(
                  title: 'Snacks',
                  time: '5:00pm - 6:30pm',
                  isExpanded: isSnacksExpanded,
                  onTap: () =>
                      setState(() => isSnacksExpanded = !isSnacksExpanded),
                  items: [],
                ),
                const SizedBox(height: 12),

                // Dinner
                _buildAccordion(
                  title: 'Dinner',
                  time: '8:30pm - 10:30pm',
                  isExpanded: isDinnerExpanded,
                  onTap: () =>
                      setState(() => isDinnerExpanded = !isDinnerExpanded),
                  items: [],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopNav() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem('Meal Plan', Icons.assignment_outlined, false),
          _buildNavItem('Menu', Icons.restaurant_menu, true),
          _buildNavItem('Meal Track', Icons.history, false),
          _buildNavItem('Feedback', Icons.chat_bubble_outline, false),
        ],
      ),
    );
  }

  Widget _buildNavItem(String label, IconData icon, bool isSelected) {
    return Column(
      children: [
        Icon(icon, color: isSelected ? Colors.blue : Colors.grey, size: 24),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.blue : Colors.grey,
            fontSize: 12,
          ),
        ),
        if (isSelected)
          Container(
            margin: const EdgeInsets.only(top: 8),
            height: 2,
            width: 40,
            color: Colors.blue,
          ),
      ],
    );
  }

  Widget _buildAccordion({
    required String title,
    required String time,
    required bool isExpanded,
    required VoidCallback onTap,
    required List<dynamic> items,
    bool isBlueTitle = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2F3344),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
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
                          color: isBlueTitle ? Colors.blue : Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Timing: $time',
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: Colors.white54,
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
                  const Divider(color: Colors.white24),
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
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            )
          else if (isExpanded)
            // Empty state just to keep layout stable if needed
            const SizedBox(height: 0),
        ],
      ),
    );
  }
}
