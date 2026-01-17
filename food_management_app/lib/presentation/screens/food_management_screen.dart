import 'package:flutter/material.dart';
import 'add_plan_screen.dart';
import '../widgets/top_tab_toggle.dart';
import '../widgets/plan_card.dart';

class FoodManagementScreen extends StatefulWidget {
  const FoodManagementScreen({super.key});

  @override
  State<FoodManagementScreen> createState() => _FoodManagementScreenState();
}

class _FoodManagementScreenState extends State<FoodManagementScreen> {
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: const Color.fromRGBO(38, 40, 50, 1),
      appBar: AppBar(
        title: const Text('Food Management'),
         backgroundColor: const Color.fromRGBO(38, 40, 50, 1),
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) =>  AddPlanScreen()),
              );
            },
            icon: const Icon(Icons.add, color: Colors.lightBlue),
            label: const Text('Add Plan', style: TextStyle(color: Colors.lightBlue)),
          )
        ],
      ),
      body: Column(
        children: [
          TopTabToggle(
            selectedIndex: selectedTab,
            onChanged: (index) {
              setState(() => selectedTab = index);
            },
          ),
          const SizedBox(height: 12),
          Expanded(child: _buildTabContent()),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    switch (selectedTab) {
      case 0:
        return ListView(
          padding: const EdgeInsets.all(12),
          children: const [
            PlanCard(title: 'Option Plan 1', amount: 200),
            PlanCard(title: 'Option Plan 2', amount: 3000),
            PlanCard(title: 'Option Plan 3', amount: 980),
            PlanCard(title: 'Option Plan 4', amount: 6000),
          ],
        );
      case 1:
        return const Center(child: Text('Menu Screen'));
      case 2:
        return const Center(child: Text('Meal Track Screen'));
      case 3:
        return const Center(child: Text('Feedback Screen'));
      default:
        return const SizedBox();
    }
  }
}
