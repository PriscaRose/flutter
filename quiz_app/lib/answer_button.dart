import 'package:flutter/material.dart';

class AnswerButton extends StatelessWidget {
  const AnswerButton({super.key, required this.label, required this.handleAnswer});

  final String label;

  final void Function() handleAnswer;

  @override
  Widget build(BuildContext context) {
    return  ElevatedButton(
      onPressed: handleAnswer,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
        backgroundColor: const Color.fromARGB(10, 255, 255, 255),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40))
      ),
      child: Text(label),
    );
  }
}
