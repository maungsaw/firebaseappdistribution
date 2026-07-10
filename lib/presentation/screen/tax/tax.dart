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
        StepData(title: "Custom Step 1", description: "First step description"),
        StepData(
          title: "Custom Step 2",
          description:
              "Second step description\nThis card is now taller but the line will adapt perfectly!",
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
      backgroundColor: const Color(0xFFF8FAFC),
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

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            itemCount: steps.length,
            itemBuilder: (context, index) {
              final step = steps[index];
              final isDone = step.status == StepStatus.approved;
              final isActive = index == _controller.currentStep;

              return _buildStepCard(
                step,
                isDone,
                isActive,
                index == steps.length - 1,
              );
            },
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
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black12)],
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isComplete ? Colors.green : Colors.indigo,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: isComplete ? null : _controller.advanceStep,
              child: Text(
                isComplete ? "Workflow Complete" : "Proceed to Next Stage",
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStepCard(
    StepData step,
    bool isDone,
    bool isActive,
    bool isLast,
  ) {
    // 1. Wrap the Row in IntrinsicHeight so it matches the tallest child (the card)
    return IntrinsicHeight(
      child: Row(
        // 2. Stretch the children vertically
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Visual Timeline Indicator
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDone
                      ? Colors.green
                      : (isActive ? Colors.indigo : Colors.grey.shade300),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: Colors.indigo.withValues(alpha: .3),
                            blurRadius: 8,
                          ),
                        ]
                      : [],
                ),
                child: Icon(
                  isDone ? Icons.check : Icons.circle,
                  color: Colors.white,
                  size: 16,
                ),
              ),
              if (!isLast)
                // 3. Replace fixed height with Expanded so the line stretches to the bottom
                Expanded(
                  child: Container(
                    width: 2,
                    color: isDone ? Colors.green : Colors.grey.shade300,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 20),

          // Content Card
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 30),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: isActive
                    ? Border.all(color: Colors.indigo, width: 2)
                    : Border.all(color: Colors.transparent),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    step.description,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                  const SizedBox(height: 12),

                  if (step.gapTime != null && step.status != StepStatus.draft)
                    Row(
                      children: [
                        const Icon(
                          Icons.hourglass_empty,
                          size: 14,
                          color: Colors.orange,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "Wait time: ${_controller.formatDuration(step.gapTime!)}",
                          style: const TextStyle(
                            color: Colors.orange,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                  if (step.gapTime != null && isDone) const SizedBox(height: 4),

                  if (isDone && step.startTime != null && step.endTime != null)
                    Row(
                      children: [
                        const Icon(
                          Icons.timer_outlined,
                          size: 14,
                          color: Colors.green,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "Completed in: ${_controller.formatDuration(step.endTime!.difference(step.startTime!))}",
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
