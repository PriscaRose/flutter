import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/models/meal.dart';

class FavoritesMealsNotifier extends StateNotifier<List<Meal>> {
  FavoritesMealsNotifier() : super([]);

  bool toggleMealFavoriteStatus(Meal meal) {
    final isFavMeals = state.contains(meal);

    if(isFavMeals) {
      state = state.where((element) => element.id != meal.id).toList();
      return false;
    }else {
      state = [...state, meal];
      return true;
    }

  }
}

final favoritesMealProvider = StateNotifierProvider<FavoritesMealsNotifier, List<Meal>>((ref) {
  return FavoritesMealsNotifier();
});