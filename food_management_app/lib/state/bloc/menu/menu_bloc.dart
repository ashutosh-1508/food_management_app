import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/daily_menu.dart';
import '../../../data/repositories/food_repository.dart';
part 'menu_event.dart';
part 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final FoodRepository repository;
  MenuBloc({required this.repository}) : super(MenuInitial()) {
    on<LoadMenu>((event, emit) async {
      emit(MenuLoading());
      try {
        final list = await repository.getDailyMenus();
        emit(MenuLoaded(list));
      } catch (e) {
        emit(MenuError(e.toString()));
      }
    });
  }
}
