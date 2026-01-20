import 'package:equatable/equatable.dart';
import '../../../data/models/meal_item.dart';

class MealData extends Equatable {
  final String startTime;
  final String endTime;
  final List<MealItem> items;
  final bool newItemIsVeg;
  final bool showAddInput; // Add this specific flag

  const MealData({
    this.startTime = '09:00',
    this.endTime = '10:30',
    this.items = const [],
    this.newItemIsVeg = true,
    this.showAddInput = false,
  });

  MealData copyWith({
    String? startTime,
    String? endTime,
    List<MealItem>? items,
    bool? newItemIsVeg,
    bool? showAddInput,
  }) {
    return MealData(
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      items: items ?? this.items,
      newItemIsVeg: newItemIsVeg ?? this.newItemIsVeg,
      showAddInput: showAddInput ?? this.showAddInput,
    );
  }

  @override
  List<Object?> get props => [startTime, endTime, items, newItemIsVeg, showAddInput];
}

class SetPlanState extends Equatable {
  final Map<String, MealData> mealData; // Key: mealType (breakfast, etc.)

  const SetPlanState({this.mealData = const {}});

  SetPlanState copyWith({Map<String, MealData>? mealData}) {
    return SetPlanState(mealData: mealData ?? this.mealData);
  }

  @override
  List<Object?> get props => [mealData];
}
