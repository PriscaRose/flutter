import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/providers/favorites_provider.dart';
import 'package:meals_app/widgets/Ingredient.dart';
import 'package:meals_app/widgets/Step.dart';

import '../models/meal.dart';

class MealDetail extends ConsumerWidget {
  const MealDetail({
    super.key,
    required this.meal,
    // required this.onToogleMeal
  });

  final Meal meal;
  // final void Function(Meal meal) onToogleMeal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoritesMeals = ref.watch(favoritesMealProvider);
    final isFavorite = favoritesMeals.contains(meal);

    return Scaffold(
      appBar: AppBar(
        title: Text(meal.title),
        actions: [
          IconButton(
              onPressed: () {
                final wasAdded =
                ref
                    .read(favoritesMealProvider.notifier)
                    .toggleMealFavoriteStatus(meal);
                // onToogleMeal(meal);
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(wasAdded ? 'Favorited' : 'Unfavorited'),
                  ),
                );
              },
              icon:  Icon(isFavorite ? Icons.star : Icons.star_border))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(meal.imageUrl),
            const SizedBox(
              height: 30,
            ),
            Ingredients(meal: meal, ingredients: meal.ingredients),
            Steps(
              meal: meal,
              steps: meal.steps,
            )
          ],
        ),
      ),
    );
  }
}
