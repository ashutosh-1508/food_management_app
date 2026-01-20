import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/feedback.dart';
import '../../../data/repositories/food_repository.dart';
part 'feedback_event.dart';
part 'feedback_state.dart';

class FeedbackBloc extends Bloc<FeedbackEvent, FeedbackState> {
  final FoodRepository repository;
  FeedbackBloc({required this.repository}) : super(FeedbackInitial()) {
    on<LoadFeedback>((event, emit) async {
      emit(FeedbackLoading());
      try {
        final list = await repository.getFeedback();
        emit(FeedbackLoaded(list));
      } catch (e) {
        emit(FeedbackError(e.toString()));
      }
    });
  }
}
