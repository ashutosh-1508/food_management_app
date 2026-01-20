import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/attendance.dart';
import '../../../data/repositories/food_repository.dart';
part 'attendance_event.dart';
part 'attendance_state.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final FoodRepository repository;
  AttendanceBloc({required this.repository}) : super(AttendanceInitial()) {
    on<LoadAttendance>((event, emit) async {
      emit(AttendanceLoading());
      try {
        final list = await repository.getAttendance();
        emit(AttendanceLoaded(list));
      } catch (e) {
        emit(AttendanceError(e.toString()));
      }
    });
  }
}
