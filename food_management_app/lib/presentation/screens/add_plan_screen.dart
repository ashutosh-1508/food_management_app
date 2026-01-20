import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../state/bloc/meal_checkbox_bloc.dart';
import '../../state/bloc/add_plan/add_plan_cubit.dart';
import 'set_plan_screen.dart';

class AddPlanScreen extends StatefulWidget {
  const AddPlanScreen({super.key});

  @override
  State<AddPlanScreen> createState() => _AddPlanScreenState();
}

class _AddPlanScreenState extends State<AddPlanScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  // Price breakdown controllers
  final TextEditingController breakfastPriceController = TextEditingController();
  final TextEditingController lunchPriceController = TextEditingController();
  final TextEditingController snacksPriceController = TextEditingController();
  final TextEditingController dinnerPriceController = TextEditingController();

  final List<String> frequency = ['Weekly', 'Monthly', 'Yearly'];

  @override
  void initState() {
    super.initState();
    // We attach listeners to controllers. Logic for calculation will be handled 
    // by checking current state in the build or inside the listener context if accessible.
    // However, since we need to access the bloc state inside the listener, 
    // and listeners are added in initState where context is not fully ready for provider lookup 
    // without listen: false, we'll do it carefully.
  }

  void _calculateTotalAmount(BuildContext context) {
    final state = context.read<AddPlanCubit>().state;
    if (state.showPriceBreakdown) {
      int total = 0;
      total += int.tryParse(breakfastPriceController.text) ?? 0;
      total += int.tryParse(lunchPriceController.text) ?? 0;
      total += int.tryParse(snacksPriceController.text) ?? 0;
      total += int.tryParse(dinnerPriceController.text) ?? 0;
      amountController.text = total.toString();
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    amountController.dispose();
    breakfastPriceController.dispose();
    lunchPriceController.dispose();
    snacksPriceController.dispose();
    dinnerPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final bgColor = isDark ? const Color.fromRGBO(38, 40, 50, 1) : const Color(0xFFF5F7FA);
    final surfaceColor = isDark ? const Color(0xFF2F3344) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF2D3142);
    final inputFillColor = isDark ? const Color(0xFF2F3344) : Colors.white;
    final iconBgColor = isDark ? const Color.fromARGB(255, 66, 74, 107) : Colors.grey.shade200;
    final borderColor = isDark ? Colors.grey : Colors.grey;

    return BlocProvider(
      create: (context) => AddPlanCubit(),
      child: Builder(
        builder: (context) {
          // Attach listeners here where we have access to the provided Cubit context
          breakfastPriceController.addListener(() => _calculateTotalAmount(context));
          lunchPriceController.addListener(() => _calculateTotalAmount(context));
          snacksPriceController.addListener(() => _calculateTotalAmount(context));
          dinnerPriceController.addListener(() => _calculateTotalAmount(context));
          
          return Scaffold(
            backgroundColor: bgColor,
            appBar: AppBar(
              title: Text('Add Plan', style: TextStyle(color: textColor)),
              backgroundColor: bgColor,
              iconTheme: IconThemeData(color: textColor),
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: BlocBuilder<AddPlanCubit, AddPlanState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      _buildTextField(
                        controller: nameController,
                        hint: 'Enter Plan Name',
                        iconPath: 'assets/plan.svg',
                        textColor: textColor,
                        fillColor: inputFillColor,
                        iconBgColor: iconBgColor,
                        borderColor: borderColor,
                      ),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        activeColor: Colors.blue,
                        title: Text(
                          'Show price breakdown per meal',
                          style: TextStyle(color: textColor),
                        ),
                        value: state.showPriceBreakdown,
                        onChanged: (val) {
                          context.read<AddPlanCubit>().togglePriceBreakdown(val);
                          // Trigger calculation if enabling
                          if (val) _calculateTotalAmount(context);
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildMealSelectionArea(
                        surfaceColor: surfaceColor,
                        textColor: textColor,
                        borderColor: borderColor,
                        showPriceBreakdown: state.showPriceBreakdown,
                      ),
                      const SizedBox(height: 30),
                      _buildTextField(
                        controller: amountController,
                        hint: 'Enter Amount',
                        iconPath: 'assets/rupee.svg',
                        inputType: TextInputType.number,
                        textColor: textColor,
                        fillColor: inputFillColor,
                        iconBgColor: iconBgColor,
                        borderColor: borderColor,
                      ),
                      const SizedBox(height: 30),
                      _buildFrequencyDropdown(
                        fillColor: inputFillColor,
                        textColor: textColor,
                        iconBgColor: iconBgColor,
                        borderColor: borderColor,
                        selectedFrequency: state.selectedFrequency,
                        context: context,
                      ),
                      const SizedBox(height: 40),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => _onSaveAndContinue(context, state),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: const Text(
                            'Save & Continue',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        }
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required String iconPath,
    required Color textColor,
    required Color fillColor,
    required Color iconBgColor,
    required Color borderColor,
    TextInputType inputType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      style: TextStyle(color: textColor),
      keyboardType: inputType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 18),
        filled: true,
        fillColor: fillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: borderColor, width: 1),
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: SvgPicture.asset(
                iconPath,
                height: 24,
                colorFilter: const ColorFilter.mode(
                  Colors.grey,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMealSelectionArea({
    required Color surfaceColor,
    required Color textColor,
    required Color borderColor,
    required bool showPriceBreakdown,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: BlocBuilder<MealCheckboxBloc, MealCheckboxState>(
        builder: (context, state) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left Column: Checkboxes
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildCheckbox(
                      'Breakfast',
                      state.isBreakfast,
                      () => context.read<MealCheckboxBloc>().add(
                        IsBreakfastCheck(),
                      ),
                      textColor,
                    ),
                    _buildCheckbox(
                      'Lunch',
                      state.isLunch,
                      () =>
                          context.read<MealCheckboxBloc>().add(IsLunchCheck()),
                      textColor,
                    ),
                    _buildCheckbox(
                      'Snacks',
                      state.isSnacks,
                      () =>
                          context.read<MealCheckboxBloc>().add(IsSnacksCheck()),
                      textColor,
                    ),
                    _buildCheckbox(
                      'Dinner',
                      state.isDinner,
                      () =>
                          context.read<MealCheckboxBloc>().add(IsDinnerCheck()),
                      textColor,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 120),
              // Right Column: Price Inputs (if enabled)
              if (showPriceBreakdown)
                Expanded(
                  child: Column(
                    children: [
                      _buildPriceInput(
                        state.isBreakfast,
                        breakfastPriceController,
                        textColor,
                      ),
                      _buildPriceInput(state.isLunch, lunchPriceController, textColor),
                      _buildPriceInput(state.isSnacks, snacksPriceController, textColor),
                      _buildPriceInput(state.isDinner, dinnerPriceController, textColor),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCheckbox(String label, bool value, VoidCallback onChanged, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 13),
      child: Row(
        children: [
          SizedBox(
            height: 30,
            width: 20,
            child: Checkbox(
              value: value,
              onChanged: (_) => onChanged(),
              activeColor: Colors.blue,
              side: BorderSide(color: textColor.withOpacity(0.6), width: 2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(fontSize: 16, color: textColor),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceInput(bool isEnabled, TextEditingController controller, Color textColor) {
    final isDark = textColor == Colors.white; 
    final enabledFill = isDark ? const Color.fromARGB(255, 39, 41, 54) : Colors.grey[200];
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SizedBox(
        width: 100,
        height: 40,
        child: TextField(
          controller: controller,
          enabled: isEnabled,
          keyboardType: TextInputType.number,
          style: TextStyle(fontSize: 14, color: textColor),
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
            prefixText: '₹ ',
            prefixStyle: TextStyle(
              fontSize: 20,
              color: isEnabled ? textColor : Colors.grey,
            ),
            hintText: '0',
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 20),
            filled: true,
            fillColor: isEnabled
                ? enabledFill
                : Colors.transparent,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFrequencyDropdown({
    required Color fillColor,
    required Color textColor,
    required Color iconBgColor,
    required Color borderColor,
    required String? selectedFrequency,
    required BuildContext context,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: DropdownButtonFormField<String>(
        value: selectedFrequency,
        dropdownColor: fillColor,
        iconEnabledColor: textColor,
        borderRadius: BorderRadius.circular(10),
        style: TextStyle(color: textColor),
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/calendar.svg',
                  height: 24,
                  colorFilter: const ColorFilter.mode(
                    Colors.grey,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
          hintText: 'Select Frequency',
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 18),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 16,
          ),
        ),
        items: frequency
            .map((item) => DropdownMenuItem(value: item, child: Text(item)))
            .toList(),
        onChanged: (value) => context.read<AddPlanCubit>().selectFrequency(value),
      ),
    );
  }

  void _onSaveAndContinue(BuildContext context, AddPlanState addPlanState) {
    final state = context.read<MealCheckboxBloc>().state;

    if (nameController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter plan name')));
      return;
    }
    if (addPlanState.selectedFrequency == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select frequency')));
      return;
    }

    final selectedMeals = <String>[];
    if (state.isBreakfast) selectedMeals.add('breakfast');
    if (state.isLunch) selectedMeals.add('lunch');
    if (state.isSnacks) selectedMeals.add('snacks');
    if (state.isDinner) selectedMeals.add('dinner');

    if (selectedMeals.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one meal')),
      );
      return;
    }

    final mealPrices = <String, int>{};
    if (addPlanState.showPriceBreakdown) {
      if (state.isBreakfast)
        mealPrices['breakfast'] =
            int.tryParse(breakfastPriceController.text) ?? 0;
      if (state.isLunch)
        mealPrices['lunch'] = int.tryParse(lunchPriceController.text) ?? 0;
      if (state.isSnacks)
        mealPrices['snacks'] = int.tryParse(snacksPriceController.text) ?? 0;
      if (state.isDinner)
        mealPrices['dinner'] = int.tryParse(dinnerPriceController.text) ?? 0;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SetPlanScreen(
          planName: nameController.text,
          frequency: addPlanState.selectedFrequency!,
          amount: int.tryParse(amountController.text) ?? 0,
          selectedMeals: selectedMeals,
          mealPrices: mealPrices,
        ),
      ),
    );
  }
}
