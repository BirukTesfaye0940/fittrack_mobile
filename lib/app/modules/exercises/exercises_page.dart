import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fittrack_mobile/app/modules/exercises/exercises_controller.dart';
import 'package:fittrack_mobile/app/data/models/exercise.dart';

class ExercisesPage extends GetView<ExercisesController> {
  const ExercisesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exercises')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.exercises.isEmpty) {
          return const Center(child: Text("No exercises found. Add one!"));
        }

        return ListView.builder(
          itemCount: controller.exercises.length,
          itemBuilder: (context, index) {
            final exercise = controller.exercises[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.fitness_center)),
                title: Text(exercise.name),
                subtitle: Text(
                  "${exercise.muscleGroup} • ${exercise.equipment}",
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _confirmDelete(exercise),
                ),
                onTap: () {
                  // Navigate to details or show edit dialog here
                },
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddExerciseSheet(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _confirmDelete(Exercise exercise) {
    Get.defaultDialog(
      title: "Delete Exercise",
      middleText: "Are you sure you want to delete ${exercise.name}?",
      textConfirm: "Delete",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      onConfirm: () {
        controller.deleteExercise(exercise.id);
        Get.back();
      },
    );
  }

  void _showAddExerciseSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "New Exercise",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller.nameController,
              decoration: const InputDecoration(
                labelText: "Name (e.g. Bench Press)",
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller.muscleController,
              decoration: const InputDecoration(
                labelText: "Muscle Group (e.g. Chest)",
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller.equipmentController,
              decoration: const InputDecoration(
                labelText: "Equipment (e.g. Barbell)",
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.addExercise,
                child: const Text("Create Exercise"),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}
