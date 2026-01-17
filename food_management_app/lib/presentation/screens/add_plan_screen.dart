import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:food_management_app/state/bloc/meal_checkbox_bloc.dart';

class AddPlanScreen extends StatelessWidget {
  AddPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(38, 40, 50, 1),
      appBar: AppBar(
        title: const Text('Add Plan'),
        backgroundColor: const Color.fromRGBO(38, 40, 50, 1),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Enter Plan Name',
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 18),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.white, width: 1),
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
                        'assets/plan.svg',
                        height: 30,
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ),

                filled: true,
                fillColor: const Color.fromRGBO(38, 40, 50, 1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Show price breakdown per meal'),
              value: true,
              onChanged: (_) {},
            ),
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 47, 51, 68),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white, width: 1),
              ),
              child: BlocBuilder<MealCheckboxBloc, MealCheckboxState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: state.isBreakfast,
                            onChanged: (_) {
                              context.read<MealCheckboxBloc>().add(
                                IsBreakfastCheck(),
                              );
                            },
                          ),
                          Text('Breakfast', style: TextStyle(fontSize: 18)),
                        ],
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: state.isLunch,
                            onChanged: (Val) {
                              context.read<MealCheckboxBloc>().add(
                                IsLunchCheck(),
                              );
                            },
                          ),
                          Text('Lunch', style: TextStyle(fontSize: 18)),
                        ],
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: state.isSnacks,
                            onChanged: (Val) {
                              context.read<MealCheckboxBloc>().add(
                                IsSnacksCheck(),
                              );
                            },
                          ),
                          Text('Snacks', style: TextStyle(fontSize: 18)),
                        ],
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: state.isDinner,
                            onChanged: (Val) {
                              context.read<MealCheckboxBloc>().add(
                                IsDinnerCheck(),
                              );
                            },
                          ),
                          Text('Dinner', style: TextStyle(fontSize: 18)),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Save & Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
