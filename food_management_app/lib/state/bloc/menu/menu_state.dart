part of 'menu_bloc.dart';
abstract class MenuState extends Equatable {
  const MenuState();
  @override List<Object> get props => [];
}
class MenuInitial extends MenuState {}
class MenuLoading extends MenuState {}
class MenuLoaded extends MenuState {
  final List<DailyMenu> menuList;
  const MenuLoaded(this.menuList);
  @override List<Object> get props => [menuList];
}
class MenuError extends MenuState {
  final String message;
  const MenuError(this.message);
  @override List<Object> get props => [message];
}
