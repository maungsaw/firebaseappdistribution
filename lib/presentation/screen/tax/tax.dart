import 'dart:ui';
import 'package:flutter/material.dart';

import 'painter.dart';

class StepData {
  final String title;
  final String description;
  StepData(this.title, this.description);
}

class TaxScreen extends StatefulWidget {
  const TaxScreen({super.key});

  @override
  State<TaxScreen> createState() => _TaxScreenState();
}

class _TaxScreenState extends State<TaxScreen> {
  int _currentStep = 0;
  final List<StepData> steps = [
    StepData("Welcome", "Start your tax journey"),
    StepData("Income", "Enter your annual earnings"),
    StepData("Deductions", "List your tax write-offs"),
    StepData("Review", "Verify your information"),
    StepData("Submit", "Finalize and finish"),
  ];

  @override
  Widget build(BuildContext context) {
    const double stepHeight = 120.0; // Fixed height per step for alignment
    final double totalHeight = steps.length * stepHeight;

    return Scaffold(
      appBar: AppBar(title: Text('Tax')),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. The Stepper Column
          SizedBox(
            width: 40,
            height: totalHeight,
            child: GestureDetector(
              onTapDown: (details) {
                int tapped = (details.localPosition.dy / stepHeight).floor();
                if (tapped >= 0 && tapped < steps.length) {
                  setState(() => _currentStep = tapped);
                }
              },
              child: CustomPaint(
                painter: DashedStepperPainter(
                  currentStep: _currentStep,
                  totalSteps: steps.length,
                  itemHeight: stepHeight,
                ),
              ),
            ),
          ),

          // 2. The Dynamic Content Column
          Expanded(
            child: Column(
              children: List.generate(steps.length, (index) {
                return SizedBox(
                  height: stepHeight,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Card(
                      elevation: _currentStep == index ? 4 : 0,
                      color: _currentStep == index
                          ? Colors.white
                          : Colors.grey[100],
                      child: ListTile(
                        title: Text(steps[index].title),
                        subtitle: Text(steps[index].description),
                        leading: Icon(
                          Icons.circle,
                          color: _currentStep >= index
                              ? Colors.blue
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
