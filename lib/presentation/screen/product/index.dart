import 'package:flutter/material.dart';
import 'package:worker_manager/worker_manager.dart';
import 'package:workmanager/workmanager.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});
  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  int _currentSum = 0;
  bool _isRunning = false;
  Cancelable<int>? _task;

  void _startTask() {
    setState(() {
      _isRunning = true;
      _currentSum = 0;
    });

    // We pass the task to worker_manager
    _task = workerManager.execute(() => performSummation());

    _task!.then((result) {
      setState(() {
        _currentSum = result;
        _isRunning = false;
      });
    });
  }

  // This function runs in the background isolate
  static int performSummation() {
    int sum = 0;
    for (int i = 1; i <= 900000; i++) {
      sum += i;
    }
    return sum;
  }

  void _cancelTask() {
    _task?.cancel();
    setState(() => _isRunning = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Background Summation")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Sum result: $_currentSum",
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            _isRunning
                ? ElevatedButton(
                    onPressed: _cancelTask,
                    child: const Text("Cancel"),
                  )
                : ElevatedButton(
                    onPressed: _startTask,
                    child: const Text("Start Sum to 100k"),
                  ),

            ElevatedButton(
              onPressed: () {
                Workmanager().registerPeriodicTask(
                  "1", // Unique name for this task
                  "syncData",
                  initialDelay: Duration(seconds: 5), // Minimum is 15 minutes
                );
              },
              child: Text("Run Background"),
            ),
          ],
        ),
      ),
    );
  }
}
