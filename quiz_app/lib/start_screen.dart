import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  const StartScreen(this.statrtQuiz, {super.key});

  final void Function() statrtQuiz;

  @override
  Widget build(context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/quiz-logo.png',
            width: 200,
            color: const Color.fromARGB(150, 255, 255, 255),
          ),
          const SizedBox(
            height: 100,
          ),
          const Text(
            'Learn flutter',
            style: TextStyle(color: Colors.white, fontSize: 28),
          ),
          const SizedBox(height: 30),
          OutlinedButton.icon(
            onPressed: statrtQuiz,
            style: OutlinedButton.styleFrom(foregroundColor: Colors.white),
            icon: const Icon(Icons.arrow_right_alt),
            label: const Text('Start Quiz'),
          )
        ],
      ),
    );
  }
}
