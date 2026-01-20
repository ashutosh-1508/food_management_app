import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_management_app/state/bloc/meal_checkbox_bloc.dart';
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

  String? selectedFrequency;
  bool showPriceBreakdown = false;

  final List<String> frequency = ['Weekly', 'Monthly', 'Yearly'];

  @override
  void initState() {
    super.initState();
    breakfastPriceController.addListener(_calculateTotalAmount);
    lunchPriceController.addListener(_calculateTotalAmount);
    snacksPriceController.addListener(_calculateTotalAmount);
    dinnerPriceController.addListener(_calculateTotalAmount);
  }

  void _calculateTotalAmount() {
    if (showPriceBreakdown) {
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
    return Scaffold(
      backgroundColor: const Color.fromRGBO(38, 40, 50, 1),
      appBar: AppBar(
        title: const Text('Add Plan'),
        backgroundColor: const Color.fromRGBO(38, 40, 50, 1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildTextField(
              controller: nameController,
              hint: 'Enter Plan Name',
              iconPath: 'assets/plan.svg',
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              activeColor: Colors.blue,
              title: const Text('Show price breakdown per meal', style: TextStyle(color: Colors.white)),
              value: showPriceBreakdown,
              onChanged: (val) {
                setState(() {
                  showPriceBreakdown = val;
                  if (val) _calculateTotalAmount();
                });
              },
            ),
            const SizedBox(height: 16),
            _buildMealSelectionArea(),
            const SizedBox(height: 30),
            _buildTextField(
              controller: amountController,
              hint: 'Enter Amount',
              iconPath: 'assets/rupee.svg',
              inputType: TextInputType.number,
            ),
            const SizedBox(height: 30),
            _buildFrequencyDropdown(),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _onSaveAndContinue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Save & Continue', style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required String iconPath,
    TextInputType inputType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      keyboardType: inputType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 18),
        filled: true,
        fillColor: const Color(0xFF2F3344),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.grey, width: 1),
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 47, 51, 68),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: SvgPicture.asset(
                iconPath,
                height: 24,
                colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMealSelectionArea() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF2F3344),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white, width: 1),
      ),
      child: BlocBuilder<MealCheckboxBloc, MealCheckboxState>(
        builder: (context, state) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Column: Checkboxes
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCheckbox('Breakfast', state.isBreakfast, () => context.read<MealCheckboxBloc>().add(IsBreakfastCheck())),
                    _buildCheckbox('Lunch', state.isLunch, () => context.read<MealCheckboxBloc>().add(IsLunchCheck())),
                    _buildCheckbox('Snacks', state.isSnacks, () => context.read<MealCheckboxBloc>().add(IsSnacksCheck())),
                    _buildCheckbox('Dinner', state.isDinner, () => context.read<MealCheckboxBloc>().add(IsDinnerCheck())),
                  ],
                ),
              ),
              // Right Column: Price Inputs (if enabled)
              if (showPriceBreakdown)
                Expanded(
                  child: Column(
                    children: [
                      _buildPriceInput(state.isBreakfast, breakfastPriceController),
                      _buildPriceInput(state.isLunch, lunchPriceController),
                      _buildPriceInput(state.isSnacks, snacksPriceController),
                      _buildPriceInput(state.isDinner, dinnerPriceController),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCheckbox(String label, bool value, VoidCallback onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            height: 24,
            width: 24,
            child: Checkbox(
              value: value,
              onChanged: (_) => onChanged(),
              activeColor: Colors.blue,
            ),
          ),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 16, color: Colors.white)),
        ],
      ),
    );
  }

  Widget _buildPriceInput(bool isEnabled, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: SizedBox(
        height: 40,
        child: TextField(
          controller: controller,
          enabled: isEnabled,
          keyboardType: TextInputType.number,
          style: const TextStyle(fontSize: 14, color: Colors.white),
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
            prefixText: '₹ ',
            prefixStyle: TextStyle(color: isEnabled ? Colors.white : Colors.grey),
            hintText: '0',
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: isEnabled ? const Color(0xFF3E4357) : Colors.transparent,
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

  Widget _buildFrequencyDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2F3344),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey, width: 1),
      ),
      child: DropdownButtonFormField<String>(
        value: selectedFrequency,
        dropdownColor: const Color(0xFF2F3344),
        iconEnabledColor: Colors.white,
        borderRadius: BorderRadius.circular(10),
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 47, 51, 68),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/calendar.svg',
                  height: 24,
                  colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                ),
              ),
            ),
          ),
          hintText: 'Select Frequency',
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 18),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        ),
        items: frequency.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
        onChanged: (value) => setState(() => selectedFrequency = value),
      ),
    );
  }

  void _onSaveAndContinue() {
    final state = context.read<MealCheckboxBloc>().state;
    
    if (nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter plan name')));
      return;
    }
    if (selectedFrequency == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select frequency')));
      return;
    }

    final selectedMeals = <String>[];
    if (state.isBreakfast) selectedMeals.add('breakfast');
    if (state.isLunch) selectedMeals.add('lunch');
    if (state.isSnacks) selectedMeals.add('snacks');
    if (state.isDinner) selectedMeals.add('dinner');

    if (selectedMeals.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select at least one meal')));
      return;
    }

    final mealPrices = <String, int>{};
    if (showPriceBreakdown) {
       if (state.isBreakfast) mealPrices['breakfast'] = int.tryParse(breakfastPriceController.text) ?? 0;
       if (state.isLunch) mealPrices['lunch'] = int.tryParse(lunchPriceController.text) ?? 0;
       if (state.isSnacks) mealPrices['snacks'] = int.tryParse(snacksPriceController.text) ?? 0;
       if (state.isDinner) mealPrices['dinner'] = int.tryParse(dinnerPriceController.text) ?? 0;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SetPlanScreen(
          planName: nameController.text,
          frequency: selectedFrequency!,
          amount: int.tryParse(amountController.text) ?? 0,
          selectedMeals: selectedMeals,
          mealPrices: mealPrices,
        ),
      ),
    );
  }
}
