import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fittrack_mobile/app/modules/workouts/workouts_controller.dart';

class AiLogPage extends GetView<WorkoutsController> {
  const AiLogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AI Workout Log")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Describe your workout naturally.",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Example: \"Bench press 3 sets of 8 reps at 80kg, then Squats 5x5 at 120kg.\"",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // Text Input
            TextField(
              controller: controller.aiInputController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: "Type here...",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            // Submit Button
            Obx(
              () => controller.isAiLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton.icon(
                      onPressed: controller.logWorkoutAI,
                      icon: const Icon(Icons.auto_awesome),
                      label: const Text("Log with AI"),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        backgroundColor: Colors.deepPurple, // AI Theme
                        foregroundColor: Colors.white,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
