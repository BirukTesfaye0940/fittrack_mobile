import 'package:flutter/material.dart';
import 'package:fittrack_mobile/app/modules/workouts/workouts_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class WorkoutsPage extends GetView<WorkoutsController> {
  const WorkoutsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Workouts'), centerTitle: true),
      body: Obx(() {
        if (controller.isLoading.value && controller.workouts.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(
          onRefresh: controller.fetchWorkouts,
          child: ListView.builder(
            itemCount: controller.workouts.length,
            itemBuilder: (context, index) {
              final workout = controller.workouts[index];
              return ListTile(
                title: Text(DateFormat.yMMMd().format(workout.date)),
                subtitle: Text(
                  "${workout.workoutSets.length} sets • ${workout.durationMinutes} min",
                ),
                onTap: () {
                  controller.loadWorkoutDetails(workout.id);
                  Get.toNamed('/workout-detail', arguments: workout.id);
                },
              );
            },
          ),
        );
      }),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "ai_log",
            onPressed: () => Get.toNamed('/ai-workout-log'),
            child: const Icon(Icons.psychology),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: "manual_log",
            onPressed: () => controller.createManualWorkout(),
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
