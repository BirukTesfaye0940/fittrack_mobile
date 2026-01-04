import 'package:flutter/material.dart';
import 'package:fittrack_mobile/app/modules/workouts/workouts_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class WorkoutDetailPage extends GetView<WorkoutsController> {
  const WorkoutDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get ID from arguments
    final String workoutId = Get.arguments ?? '';

    return Scaffold(
      appBar: AppBar(title: const Text('Workout Details')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final workout = controller.currentWorkout.value;
        if (workout == null) {
          return const Center(child: Text("Workout not found"));
        }

        return Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat.yMMMMd().format(workout.date),
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      if (workout.mood != null) Text("Mood: ${workout.mood}"),
                      if (workout.notes != null)
                        Text("Notes: ${workout.notes}"),
                      const SizedBox(height: 8),
                      Text("Sets: ${workout.workoutSets.length}"),
                    ],
                  ),
                ),
              ),
            ),

            // Sets List
            Expanded(
              child: ListView.builder(
                itemCount: workout.workoutSets.length,
                itemBuilder: (context, index) {
                  final set = workout.workoutSets[index];
                  // If we don't have exercise name from backend, we might try to find it in controller.exercises
                  // assuming we fetched them. Ideally backend includes it.
                  String exerciseName = set.exerciseName ?? "Unknown Exercise";
                  if (set.exerciseName == null &&
                      controller.exercises.isNotEmpty) {
                    final ex = controller.exercises.firstWhereOrNull(
                      (e) => e.id == set.exerciseId,
                    );
                    if (ex != null) exerciseName = ex.name;
                  }

                  return ListTile(
                    title: Text(exerciseName),
                    subtitle: Text(
                      "${set.reps} reps @ ${set.weight} kg ${set.rpe != null ? '(RPE: ${set.rpe})' : ''}",
                    ),
                  );
                },
              ),
            ),

            // Add Set Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _showAddSetModal(context),
                  icon: const Icon(Icons.add),
                  label: const Text("Add Set"),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  void _showAddSetModal(BuildContext context) {
    final repsController = TextEditingController();
    final weightController = TextEditingController();
    final rpeController = TextEditingController();
    String? selectedExerciseId;

    if (controller.exercises.isNotEmpty) {
      selectedExerciseId = controller.exercises.first.id;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Add Set",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Exercise Dropdown
            Obx(
              () => DropdownButtonFormField<String>(
                value: selectedExerciseId,
                items: controller.exercises
                    .map(
                      (e) => DropdownMenuItem(value: e.id, child: Text(e.name)),
                    )
                    .toList(),
                onChanged: (val) => selectedExerciseId = val,
                decoration: const InputDecoration(labelText: "Exercise"),
              ),
            ),

            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: repsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Reps"),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: weightController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: "Weight (kg)"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: rpeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "RPE (Optional)"),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (selectedExerciseId == null) return;
                  final reps = int.tryParse(repsController.text);
                  final weight = double.tryParse(weightController.text);
                  final rpe = double.tryParse(rpeController.text);

                  if (reps != null && weight != null) {
                    controller.addSet(
                      selectedExerciseId!,
                      reps,
                      weight,
                      rpe: rpe,
                    );
                  }
                },
                child: const Text("Add"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
