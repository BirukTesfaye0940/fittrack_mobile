import 'package:flutter/material.dart';
import 'package:fittrack_mobile/app/modules/workouts/workouts_controller.dart';
import 'package:get/get.dart';

class AiWorkoutPage extends GetView<WorkoutsController> {
  const AiWorkoutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController textController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('AI Workout Logger')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Describe your workout in plain English. For example:\n"
              "\"Bench press 3x8 80kg, Squat 3x5 100kg\"",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: textController,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  hintText: "Type your workout here...",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Obx(
              () => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () {
                          if (textController.text.isNotEmpty) {
                            controller.logWorkoutAI(textController.text);
                          }
                        },
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator()
                      : const Text("Log Workout with AI"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
