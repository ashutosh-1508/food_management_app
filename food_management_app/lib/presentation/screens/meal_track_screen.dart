import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../state/bloc/attendance/attendance_bloc.dart';

class MealTrackScreen extends StatelessWidget {
  const MealTrackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AttendanceBloc, AttendanceState>(
      builder: (context, state) {
         if (state is AttendanceLoading) return const Center(child: CircularProgressIndicator());
         if (state is AttendanceLoaded) {
           return ListView.builder(
             padding: const EdgeInsets.all(12),
             itemCount: state.attendanceList.length,
             itemBuilder: (context, index) {
                final att = state.attendanceList[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Text('Meal ID: ${att.mealId}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                         const SizedBox(height: 8),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceAround,
                           children: [
                             Column(
                               children: [
                                 Text('${att.present}', style: const TextStyle(color: Colors.green, fontSize: 20, fontWeight: FontWeight.bold)),
                                 const Text('Present'),
                               ],
                             ),
                             Column(
                               children: [
                                 Text('${att.absent}', style: const TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold)),
                                 const Text('Absent'),
                               ],
                             ),
                           ],
                         )
                      ],
                    ),
                  ),
                );
             },
           );
         }
         return const SizedBox();
      },
    );
  }
}
