import 'package:flutter/material.dart';

enum StepStatus { draft, inProgress, approved }

class StepData {
  final String title;
  final String description;
  StepStatus status;
  DateTime? startTime;
  DateTime? endTime;
  Duration? gapTime;

  StepData({
    required this.title,
    required this.description,
    this.status = StepStatus.draft,
  });
}

class WorkflowController extends ChangeNotifier {
  late final ValueNotifier<List<StepData>> stepsNotifier;

  int currentStep = 0;
  DateTime? _lastStepEndTime;
  WorkflowController({required List<StepData> initialSteps}) {
    stepsNotifier = ValueNotifier(initialSteps);

    final steps = stepsNotifier.value;
    if (steps.isNotEmpty) {
      steps[0].startTime = DateTime.now();
      steps[0].status = StepStatus.inProgress;
    }
  }

  String formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    if (minutes > 0) return "${minutes}m ${seconds}s";
    return "${seconds}s";
  }

  void advanceStep() {
    final steps = stepsNotifier.value;

    if (currentStep >= steps.length - 1) {
      steps[currentStep].status = StepStatus.approved;
      steps[currentStep].endTime = DateTime.now();
      stepsNotifier.notifyListeners();
      return;
    }

    final now = DateTime.now();

    // Finish current step
    steps[currentStep].endTime = now;
    steps[currentStep].status = StepStatus.approved;

    if (_lastStepEndTime != null) {
      steps[currentStep].gapTime = now.difference(_lastStepEndTime!);
    }

    // Move to next step
    currentStep++;
    steps[currentStep].startTime = now;
    steps[currentStep].status = StepStatus.inProgress;
    _lastStepEndTime = now;

    // Trigger the UI to rebuild
    stepsNotifier.notifyListeners();
  }
}
