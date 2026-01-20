import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../data/models/meal_plan.dart';
import '../../data/models/meal.dart';
import '../../state/bloc/meal_plan/meal_plan_bloc.dart';
import '../../state/bloc/set_plan/set_plan_bloc.dart';
import '../../state/bloc/set_plan/set_plan_event.dart';
import '../../state/bloc/set_plan/set_plan_state.dart';

class SetPlanScreen extends StatefulWidget {
  final String planName;
  final String frequency;
  final int amount;
  final List<String> selectedMeals;
  final Map<String, int> mealPrices;

  const SetPlanScreen({
    super.key,
    required this.planName,
    required this.frequency,
    required this.amount,
    required this.selectedMeals,
    this.mealPrices = const {},
  });

  @override
  State<SetPlanScreen> createState() => _SetPlanScreenState();
}

class _SetPlanScreenState extends State<SetPlanScreen> {
  // We keep controllers here to preserve text during other bloc updates
  final Map<String, TextEditingController> _itemControllers = {};

  @override
  void initState() {
    super.initState();
    for (var meal in widget.selectedMeals) {
      _itemControllers[meal] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (var controller in _itemControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color.fromRGBO(38, 40, 50, 1) : const Color(0xFFF5F7FA);
    final surfaceColor = isDark ? const Color(0xFF2F3344) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF2D3142);

    return BlocProvider(
      create: (context) => SetPlanBloc()..add(InitializeSetPlan(widget.selectedMeals)),
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          title: Text('Set Plan', style: TextStyle(color: textColor)),
          backgroundColor: bgColor,
          elevation: 0,
          iconTheme: IconThemeData(color: textColor),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: textColor),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: BlocBuilder<SetPlanBloc, SetPlanState>(
          builder: (context, state) {
            return Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    children: widget.selectedMeals.map((type) => _buildMealCard(context, type, state, isDark)).toList(),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  width: double.infinity,
                  color: bgColor,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[400],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: () => _onSave(context, state),
                    child: const Text('Save', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildMealCard(BuildContext context, String type, SetPlanState state, bool isDark) {
    final mealData = state.mealData[type];
    if (mealData == null) return const SizedBox();

    final surfaceColor = isDark ? const Color(0xFF2F3344) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF2D3142);
    final subTextColor = isDark ? Colors.white70 : Colors.grey[600];
    final borderColor = isDark ? Colors.white24 : Colors.grey[500]!;
    final iconColor = isDark ? Colors.white70 : Colors.grey[600];

    final title = '${type[0].toUpperCase()}${type.substring(1)}';
    String iconPath = 'assets/breakfast.svg';
    if (type == 'lunch') iconPath = 'assets/lunch.svg';
    if (type == 'snacks') iconPath = 'assets/croissant.svg';
    if (type == 'dinner') iconPath = 'assets/dinner.svg';

    final textController = _itemControllers[type]!;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 24),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderColor, width: 1),
            boxShadow: !isDark ? [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ] : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  SvgPicture.asset(
                    iconPath, 
                    width: 24, 
                    height: 24, 
                    colorFilter: ColorFilter.mode(iconColor!, BlendMode.srcIn)
                  ),
                  const SizedBox(width: 12),
                  Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
                ],
              ),
              const SizedBox(height: 20),
              
              // Time Inputs
              Row(
                children: [
                  Expanded(
                    child: _buildTimeInput(
                      'Start Time', 
                      mealData.startTime, 
                      (val) => context.read<SetPlanBloc>().add(UpdateMealTime(mealType: type, time: val, isStartTime: true)),
                      textColor: textColor,
                      borderColor: borderColor,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTimeInput(
                      'End Time', 
                      mealData.endTime, 
                      (val) => context.read<SetPlanBloc>().add(UpdateMealTime(mealType: type, time: val, isStartTime: false)),
                      textColor: textColor,
                      borderColor: borderColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text('$title List', style: TextStyle(color: subTextColor, fontSize: 16)),
              const SizedBox(height: 12),
              
              // Existing Items
              if (mealData.items.isNotEmpty)
                ...mealData.items.asMap().entries.map((entry) {
                   final index = entry.key;
                   final item = entry.value;
                   return Padding(
                     padding: const EdgeInsets.only(bottom: 12),
                     child: _buildItemRow(
                       context: context,
                       mealType: type,
                       index: index,
                       name: item.name,
                       isVeg: item.diet == 'veg',
                       textColor: subTextColor!,
                       checkboxColor: isDark ? const Color(0xFF3E4357) : Colors.grey[200]!,
                     ),
                   );
                }),
              
              // Add Item Row (Visible only if showAddInput is true)
              if (mealData.showAddInput)
                 Padding(
                   padding: const EdgeInsets.only(top: 8),
                   child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: textController,
                          style: TextStyle(color: textColor, fontSize: 16),
                          decoration: InputDecoration(
                            hintText: 'Enter Item',
                            hintStyle: TextStyle(color: isDark ? Colors.white38 : Colors.grey[400]),
                            border: UnderlineInputBorder(borderSide: BorderSide(color: isDark ? Colors.white38 : Colors.grey[400]!)),
                            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: isDark ? Colors.white38 : Colors.grey[400]!)),
                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: isDark ? Colors.white70 : Colors.grey[600]!)),
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Veg Selection
                      InkWell(
                        onTap: () => context.read<SetPlanBloc>().add(ToggleNewItemDiet(type, true)),
                        child: SvgPicture.asset('assets/veg.svg', width: 16, height: 16),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () => context.read<SetPlanBloc>().add(ToggleNewItemDiet(type, true)),
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            border: Border.all(color: isDark ? Colors.white54 : Colors.grey),
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.transparent, 
                          ),
                          child: mealData.newItemIsVeg ? const Icon(Icons.check, size: 14, color: Colors.green) : null,
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Non-Veg Selection
                      InkWell(
                        onTap: () => context.read<SetPlanBloc>().add(ToggleNewItemDiet(type, false)),
                        child: SvgPicture.asset('assets/non-veg.svg', width: 16, height: 16),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () => context.read<SetPlanBloc>().add(ToggleNewItemDiet(type, false)),
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            border: Border.all(color: isDark ? Colors.white54 : Colors.grey),
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.transparent,
                          ),
                          child: !mealData.newItemIsVeg ? const Icon(Icons.check, size: 14, color: Colors.red) : null,
                        ),
                      ),
                    ],
                   ),
                 ),
            ],
          ),
        ),
        
        // Floating Action Button
        Positioned(
          right: 20,
          bottom: 4, 
          child: SizedBox(
            width: 44,
            height: 44,
            child: FloatingActionButton(
              heroTag: 'add_$type',
              onPressed: () {
                if (!mealData.showAddInput) {
                  // Show the input row
                  context.read<SetPlanBloc>().add(ToggleAddInput(type, true));
                } else {
                  // Try to add item
                  if (textController.text.isNotEmpty) {
                    context.read<SetPlanBloc>().add(AddItemToMeal(type, textController.text));
                    textController.clear();
                  } else {
                     // Optionally hide input if empty?
                  }
                }
              },
              backgroundColor: const Color(0xFF5A9DFF),
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeInput(String label, String value, Function(String) onChanged, {required Color textColor, required Color borderColor}) {
    return TextField(
      controller: TextEditingController(text: value)..selection = TextSelection.fromPosition(TextPosition(offset: value.length)),
      style: TextStyle(color: textColor, fontSize: 16),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.blue),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.access_time, color: textColor.withOpacity(0.7), size: 20),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blue),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
    );
  }

  Widget _buildItemRow({
    required BuildContext context,
    required String mealType,
    required int index,
    required String name,
    required bool isVeg,
    required Color textColor,
    required Color checkboxColor,
  }) {
    return Row(
      children: [
        Expanded(child: Text(name, style: TextStyle(color: textColor, fontSize: 16))),
        InkWell(
          onTap: () => context.read<SetPlanBloc>().add(UpdateItemDiet(mealType: mealType, index: index, diet: 'veg')),
          child: SvgPicture.asset('assets/veg.svg', width: 16, height: 16),
        ),
        const SizedBox(width: 8),
        InkWell(
          onTap: () => context.read<SetPlanBloc>().add(UpdateItemDiet(mealType: mealType, index: index, diet: 'veg')),
          child: Container( // Modified to simple checkbox style
            width: 20,
            height: 20,
            decoration: BoxDecoration(
               color: checkboxColor,
               borderRadius: BorderRadius.circular(4),
            ),
            child: isVeg ? const Icon(Icons.check, size: 14, color: Colors.green) : null,
          ),
        ),
        const SizedBox(width: 16),
        InkWell(
          onTap: () => context.read<SetPlanBloc>().add(UpdateItemDiet(mealType: mealType, index: index, diet: 'non-veg')),
          child: SvgPicture.asset('assets/non-veg.svg', width: 16, height: 16),
        ),
        const SizedBox(width: 8),
         InkWell(
          onTap: () => context.read<SetPlanBloc>().add(UpdateItemDiet(mealType: mealType, index: index, diet: 'non-veg')),
          child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
               color: checkboxColor,
               borderRadius: BorderRadius.circular(4),
            ),
            child: !isVeg ? const Icon(Icons.check, size: 14, color: Colors.red) : null,
          ),
        ),
        // Add Close icon if needed, but image doesn't show it for existing items explicitly, only for edit? 
        // User didn't say remove it, but said "UI should look like this". 
        // Image shows list items with toggle boxes. No delete icon visible in the small crop.
        // I will keep the delete icon but maybe make it subtle, or logic demands it.
        const SizedBox(width: 16),
        InkWell(
          onTap: () => context.read<SetPlanBloc>().add(RemoveItemFromMeal(mealType, index)),
          child: const Icon(Icons.close, size: 18, color: Colors.grey),
        ),
      ],
    );
  }

  void _onSave(BuildContext context, SetPlanState state) {
    List<Meal> meals = [];
    state.mealData.forEach((type, data) {
      meals.add(Meal(
        id: 'meal_${DateTime.now().millisecondsSinceEpoch}_$type',
        type: type,
        startTime: data.startTime,
        endTime: data.endTime,
        items: data.items,
        price: widget.mealPrices[type] ?? 0,
      ));
    });

    final newPlan = MealPlan(
      id: 'plan_${DateTime.now().millisecondsSinceEpoch}',
      name: widget.planName,
      frequency: widget.frequency.toLowerCase(),
      amount: widget.amount,
      isActive: true,
      createdAt: DateTime.now().toIso8601String(),
      meals: meals,
    );

    context.read<MealPlanBloc>().add(AddMealPlan(newPlan));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Plan Saved Successfully')),
    );
    Navigator.popUntil(context, (route) => route.isFirst);
  }
}
