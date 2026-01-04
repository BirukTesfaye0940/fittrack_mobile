import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fittrack_mobile/app/modules/workouts/workouts_controller.dart';
import 'package:fittrack_mobile/app/modules/exercises/exercises_controller.dart';

class WorkoutDetailPage extends GetView<WorkoutsController> {
  const WorkoutDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Workout Details")),
      body: Obx(() {
        if (controller.isLoadingDetail.value ||
            controller.currentWorkout.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final workout = controller.currentWorkout.value!;

        return Column(
          children: [
            // Metadata Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Colors.grey[100],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Date: ${workout.date.toString().split(' ')[0]}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Duration: ${workout.durationMinutes ?? 0} min",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text("Mood: ${workout.mood ?? 'Neutral'}"),
                  if (workout.notes != null && workout.notes!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    const Text(
                      "Notes:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      workout.notes!,
                      style: TextStyle(color: Colors.grey[800]),
                    ),
                  ],
                ],
              ),
            ),

            // Sets List
            Expanded(
              child: ListView.builder(
                itemCount: workout.sets.length,
                itemBuilder: (context, index) {
                  final set = workout.sets[index];
                  return ListTile(
                    title: Text(
                      set.exerciseName ?? "Exercise",
                    ), // Needs backend map or local lookup
                    subtitle: Text(
                      "${set.reps} reps @ ${set.weight}kg (RPE: ${set.rpe ?? '-'})",
                    ),
                    leading: Text(
                      "#${index + 1}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddSetSheet(context),
        label: const Text("Add Set"),
        icon: const Icon(Icons.add),
      ),
    );
  }

  void _showAddSetSheet(BuildContext context) {
    final exercisesCtrl = Get.find<ExercisesController>();
    final repsCtrl = TextEditingController();
    final weightCtrl = TextEditingController();
    final rpeCtrl = TextEditingController();
    String? selectedExerciseId;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Add Set",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Dropdown for Exercises (Requires ExercisesController to have data)
            Obx(
              () => DropdownButtonFormField<String>(
                hint: const Text("Select Exercise"),
                items: exercisesCtrl.exercises.map((e) {
                  return DropdownMenuItem(value: e.id, child: Text(e.name));
                }).toList(),
                onChanged: (val) => selectedExerciseId = val,
              ),
            ),

            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: repsCtrl,
                    decoration: const InputDecoration(labelText: "Reps"),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: weightCtrl,
                    decoration: const InputDecoration(labelText: "Weight (kg)"),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            TextField(
              controller: rpeCtrl,
              decoration: const InputDecoration(labelText: "RPE (1-10)"),
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (selectedExerciseId != null &&
                    repsCtrl.text.isNotEmpty &&
                    weightCtrl.text.isNotEmpty) {
                  controller.addSet(
                    selectedExerciseId!,
                    repsCtrl.text,
                    weightCtrl.text,
                    rpeCtrl.text,
                  );
                }
              },
              child: const Text("Save Set"),
            ),
          ],
        ),
      ),
    );
  }
}
