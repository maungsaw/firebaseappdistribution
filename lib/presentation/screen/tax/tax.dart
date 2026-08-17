import 'package:flutter/material.dart';
import 'provider.dart';

class TaxScreen extends StatefulWidget {
  const TaxScreen({super.key});

  @override
  State<TaxScreen> createState() => _TaxScreenState();
}

class _TaxScreenState extends State<TaxScreen> {
  late final WorkflowController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WorkflowController(
      initialSteps: [
        StepData(
          title: "Custom Init Step",
          description: "Init step description",
        ),
        StepData(title: "Custom Step 1", description: "First step description"),
        StepData(
          title: "Custom Step 2",
          description:
              "Second step description\nThis takes up the full page content area now!",
        ),
        StepData(title: "Custom Step 3", description: "Third step description"),
        StepData(
          title: "Custom Step 4",
          description: "Fourth step description",
        ),
        StepData(title: "Custom Step 5", description: "Final step description"),
      ],
    );
  }

  @override
  void dispose() {
    _controller.stepsNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Policy Workflow",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: ListenableBuilder(
        listenable: _controller.stepsNotifier,
        builder: (context, child) {
          final steps = _controller.stepsNotifier.value;
          final currentIndex = _controller.currentStep;
          final currentStep = steps[currentIndex];

          return Column(
            children: [
              // 1. Top Horizontal Timeline Stepper
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                color: const Color(0xFFF8FAFC),
                child: Row(
                  children: List.generate(steps.length, (index) {
                    final isDone = steps[index].status == StepStatus.approved;
                    final isActive = index == currentIndex;
                    final isLast = index == steps.length - 1;

                    return Expanded(
                      flex: isLast ? 0 : 1,
                      child: Row(
                        children: [
                          // Dot Indicator
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isDone
                                  ? Colors.green
                                  : (isActive
                                        ? Colors.indigo
                                        : Colors.grey.shade300),
                            ),
                            child: Icon(
                              isDone ? Icons.check : Icons.circle,
                              color: Colors.white,
                              size: 12,
                            ),
                          ),
                          // Connecting Horizontal Line
                          if (!isLast)
                            Expanded(
                              child: Container(
                                height: 2,
                                color: isDone
                                    ? Colors.green
                                    : Colors.grey.shade300,
                              ),
                            ),
                        ],
                      ),
                    );
                  }),
                ),
              ),

              // 2. Full Page Step Body (Replaced PageView with AnimatedSwitcher)
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: _buildFullPageStep(
                    key: ValueKey(
                      currentIndex,
                    ), // Triggers animation on index change
                    step: currentStep,
                    isDone: currentStep.status == StepStatus.approved,
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: ListenableBuilder(
        listenable: _controller.stepsNotifier,
        builder: (context, child) {
          final steps = _controller.stepsNotifier.value;
          final isComplete =
              _controller.currentStep >= steps.length - 1 &&
              steps.isNotEmpty &&
              steps.last.status == StepStatus.approved;

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: .spaceEvenly,
              spacing: 8.0,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 16,
                    ),
                  ),
                  onPressed: isComplete ? null : _controller.previousStep,
                  child: Text(
                    "Prev Stage",
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isComplete ? Colors.green : Colors.indigo,
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 16,
                    ),
                  ),
                  onPressed: isComplete ? null : _controller.advanceStep,
                  child: Text(
                    isComplete ? "Workflow Complete" : "Next Stage",
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFullPageStep({
    required Key key,
    required StepData step,
    required bool isDone,
  }) {
    return Container(
      key: key,
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            step.title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            step.description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
          ),
          const Spacer(),

          // Status & Metadata Badges
          if (step.gapTime != null && step.status != StepStatus.draft)
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.hourglass_empty,
                    size: 16,
                    color: Colors.orange,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Wait time: ${_controller.formatDuration(step.gapTime!)}",
                    style: const TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

          if (isDone && step.startTime != null && step.endTime != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.timer_outlined,
                    size: 16,
                    color: Colors.green,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Completed in: ${_controller.formatDuration(step.endTime!.difference(step.startTime!))}",
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
