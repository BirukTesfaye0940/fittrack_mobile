import 'package:fittrack_mobile/app/data/models/exercise.dart';
import 'package:fittrack_mobile/app/modules/exercises/exercises_service.dart';
import 'package:fittrack_mobile/app/data/models/workout.dart';

import 'package:fittrack_mobile/app/modules/workouts/workouts_service.dart';
import 'package:get/get.dart';

class WorkoutsController extends GetxController {
  final WorkoutsService _service = WorkoutsService();
  final ExercisesService _exercisesService = ExercisesService();

  final workouts = <Workout>[].obs;
  final exercises = <Exercise>[].obs;
  final isLoading = false.obs;
  final currentWorkout = Rxn<Workout>();

  @override
  void onInit() {
    super.onInit();
    fetchWorkouts();
    fetchExercises();
  }

  Future<void> fetchExercises() async {
    try {
      final data = await _exercisesService.getExercises();
      exercises.assignAll(data);
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch exercises");
    }
  }

  Future<void> fetchWorkouts() async {
    isLoading.value = true;
    try {
      final data = await _service.getWorkouts(limit: 50); // Fetch more for now
      workouts.assignAll(data);
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch workouts: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadWorkoutDetails(String id) async {
    isLoading.value = true;
    try {
      final workout = await _service.getWorkout(id);
      currentWorkout.value = workout;
    } catch (e) {
      Get.snackbar("Error", "Failed to load details: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createManualWorkout() async {
    isLoading.value = true;
    try {
      final workout = await _service.createWorkout(DateTime.now());
      workouts.insert(0, workout);
      currentWorkout.value = workout;
      // Navigate to detail
      Get.toNamed('/workout-detail', arguments: workout.id);
    } catch (e) {
      Get.snackbar("Error", "Failed to create workout: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addSet(
    String exerciseId,
    int reps,
    double weight, {
    double? rpe,
  }) async {
    if (currentWorkout.value == null) return;

    try {
      await _service.addSet(
        currentWorkout.value!.id,
        exerciseId,
        reps,
        weight,
        rpe: rpe,
      );
      // Refresh details
      await loadWorkoutDetails(currentWorkout.value!.id);
      Get.back(); // Close modal
      Get.snackbar("Success", "Set added successfully");
    } catch (e) {
      Get.snackbar("Error", "Failed to add set: $e");
    }
  }

  Future<void> logWorkoutAI(String text) async {
    isLoading.value = true;
    try {
      final workoutId = await _service.logWorkoutAI(text);
      Get.snackbar("Success", "Workout logged successfully!");
      // Load details before navigating
      await loadWorkoutDetails(workoutId);
      // Navigate to detail
      Get.offNamed('/workout-detail', arguments: workoutId);
      // Refresh list in background
      fetchWorkouts();
    } catch (e) {
      Get.snackbar("Error", "AI Logging failed: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
