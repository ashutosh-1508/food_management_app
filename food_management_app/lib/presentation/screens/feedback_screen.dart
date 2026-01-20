import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../state/bloc/feedback/feedback_bloc.dart';

class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) {
     return BlocBuilder<FeedbackBloc, FeedbackState>(
      builder: (context, state) {
         if (state is FeedbackLoading) return const Center(child: CircularProgressIndicator());
         if (state is FeedbackLoaded) {
           return ListView.builder(
             padding: const EdgeInsets.all(12),
             itemCount: state.feedbackList.length,
             itemBuilder: (context, index) {
                final fb = state.feedbackList[index];
                return Card(
                   margin: const EdgeInsets.only(bottom: 12),
                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: CircleAvatar(child: Text(fb.userAvatar)),
                    title: Text(fb.userName),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(fb.comment),
                        Text(fb.mealType.toUpperCase(), style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 20),
                        Text('${fb.rating}'),
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
