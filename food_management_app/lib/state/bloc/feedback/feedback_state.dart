part of 'feedback_bloc.dart';
abstract class FeedbackState extends Equatable {
  const FeedbackState();
  @override List<Object> get props => [];
}
class FeedbackInitial extends FeedbackState {}
class FeedbackLoading extends FeedbackState {}
class FeedbackLoaded extends FeedbackState {
  final List<MealFeedback> feedbackList;
  const FeedbackLoaded(this.feedbackList);
  @override List<Object> get props => [feedbackList];
}
class FeedbackError extends FeedbackState {
  final String message;
  const FeedbackError(this.message);
  @override List<Object> get props => [message];
}
