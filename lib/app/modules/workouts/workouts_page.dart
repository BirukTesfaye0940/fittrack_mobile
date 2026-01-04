import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fittrack_mobile/app/modules/workouts/workouts_controller.dart';
import 'package:fittrack_mobile/app/routes/app_routes.dart';
import 'package:intl/intl.dart';

class WorkoutsPage extends GetView<WorkoutsController> {
  const WorkoutsPage({super.key});

  void _showCreateWorkoutSheet(BuildContext context) {
    final durationController = TextEditingController(text: '45');
    final moodController = TextEditingController();
    final notesController = TextEditingController();

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.only(
          top: 20,
          left: 20,
          right: 20,
          // Ensures the sheet rises above the keyboard
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const Text(
                'New Workout Session',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Duration Field
              TextField(
                controller: durationController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Duration (min)',
                  prefixIcon: const Icon(Icons.timer_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Mood Field
              TextField(
                controller: moodController,
                decoration: InputDecoration(
                  labelText: 'How do you feel?',
                  hintText: 'e.g. Pumped, Focused, Tired',
                  prefixIcon: const Icon(Icons.sentiment_satisfied_alt),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Notes Field
              TextField(
                controller: notesController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Notes',
                  alignLabelWithHint: true,
                  prefixIcon: const Icon(Icons.edit_note),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Action Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    final duration = int.tryParse(durationController.text) ?? 0;
                    controller.createWorkout(
                      date: DateTime.now(),
                      durationMinutes: duration,
                      mood: moodController.text,
                      notes: notesController.text,
                    );
                    Get.back();
                  },
                  child: const Text(
                    'Start Workout',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled:
          true, // Necessary for the sheet to expand properly with keyboard
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Workouts'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.auto_awesome,
              color: Colors.deepPurple,
            ), // Styled AI Icon
            onPressed: () => Get.toNamed(Routes.AI_LOG),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoadingList.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.workouts.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.history, size: 64, color: Colors.grey[300]),
                const SizedBox(height: 16),
                const Text(
                  "No workouts yet. Let's get moving!",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (scrollInfo.metrics.pixels >=
                scrollInfo.metrics.maxScrollExtent * 0.8) {
              controller.loadMoreWorkouts();
            }
            return false;
          },
          child: RefreshIndicator(
            onRefresh: controller.fetchWorkouts,
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount:
                  controller.workouts.length +
                  (controller.hasMore.value ? 1 : 0),
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                // Show loading indicator at the bottom
                if (index == controller.workouts.length) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: controller.isLoadingMore.value
                          ? const CircularProgressIndicator()
                          : const SizedBox.shrink(),
                    ),
                  );
                }

                final workout = controller.workouts[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    title: Text(
                      DateFormat('EEEE, MMM d').format(workout.date),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        children: [
                          Icon(Icons.bolt, size: 16, color: Colors.orange[700]),
                          const SizedBox(width: 4),
                          Text("${workout.sets.length} sets"),
                          const SizedBox(width: 12),
                          Icon(
                            Icons.timer_outlined,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text("${workout.durationMinutes ?? 0}m"),
                        ],
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            Get.dialog(
                              AlertDialog(
                                title: const Text('Delete Workout'),
                                content: const Text(
                                  'Are you sure you want to delete this workout? This action cannot be undone.',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Get.back(),
                                    child: const Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                    ),
                                    onPressed: () {
                                      Get.back();
                                      controller.deleteWorkout(workout.id);
                                    },
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        const Icon(Icons.arrow_forward_ios, size: 16),
                      ],
                    ),
                    onTap: () {
                      controller.loadWorkoutDetail(workout.id);
                      Get.toNamed(Routes.WORKOUT_DETAIL);
                    },
                  ),
                );
              },
            ),
          ),
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateWorkoutSheet(context),
        label: const Text('Log Workout'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
