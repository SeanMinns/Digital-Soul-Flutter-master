import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class GradientProgressBar extends StatelessWidget {
  final double size;
  final int totalSteps;
  final int curStep;
  final Color leftColor;
  final Color rightColor;
  final Color unselectedColor;
  GradientProgressBar(
      {required this.size,
      required this.totalSteps,
      required this.curStep,
      required this.leftColor,
      required this.rightColor,
      required this.unselectedColor});

  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: StepProgressIndicator(
        totalSteps: totalSteps,
        currentStep: curStep,
        size: size,
        padding: 0,
        unselectedColor: unselectedColor,
        selectedGradientColor: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [leftColor, rightColor],
        ),
      ),
    );
  }
}
