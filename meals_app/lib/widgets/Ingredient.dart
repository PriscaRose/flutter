import 'package:flutter/material.dart';

import '../models/meal.dart';

class Ingredients extends StatelessWidget {
  const Ingredients(
      {super.key, required, required this.meal, required this.ingredients});

  final Meal meal;
  final List<String> ingredients;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Ingredients',
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ...meal.ingredients.map(
          (ingredient) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
            child: Text(
              ingredient,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontWeight: FontWeight.normal,
                  ),
            ),
          ),
        ),
      ],
    );
  }
}
