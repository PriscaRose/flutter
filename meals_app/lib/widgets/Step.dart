import 'package:flutter/material.dart';
import 'package:meals_app/models/meal.dart';

class Steps extends StatelessWidget {
  const Steps({super.key, required this.steps, required this.meal});

  final List<String> steps;
  final Meal meal;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Steps',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 30),
        ...steps.map(
          (ingredient) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
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
