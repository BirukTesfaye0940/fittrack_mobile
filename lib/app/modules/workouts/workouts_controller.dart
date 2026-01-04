import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fittrack_mobile/app/data/models/workout.dart';
import 'package:fittrack_mobile/app/modules/workouts/workouts_service.dart';
import 'package:fittrack_mobile/app/modules/exercises/exercises_controller.dart'; // To pick exercises
import 'package:fittrack_mobile/app/routes/app_routes.dart';

class WorkoutsController extends GetxController {
  final WorkoutsService _service = WorkoutsService();

  // -- List State --
  var workouts = <Workout>[].obs;
  var isLoadingList = true.obs;
  var isLoadingMore = false.obs;
  var hasMore = true.obs;
  var currentSkip = 0;
  final int pageSize = 10;

  // -- Detail State --
  var currentWorkout = Rxn<Workout>();
  var isLoadingDetail = false.obs;

  // -- AI Log State --
  final aiInputController = TextEditingController();
  var isAiLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchWorkouts();
  }

  // 1. Fetch List (Initial Load)
  Future<void> fetchWorkouts() async {
    try {
      isLoadingList.value = true;
      currentSkip = 0;
      hasMore.value = true;
      final result = await _service.getWorkouts(limit: pageSize, skip: 0);
      workouts.assignAll(result);
      currentSkip = result.length;
      hasMore.value = result.length >= pageSize;
    } catch (e) {
      Get.snackbar("Error", "Failed to load workouts");
    } finally {
      isLoadingList.value = false;
    }
  }

  // 1b. Load More Workouts (Pagination)
  Future<void> loadMoreWorkouts() async {
    if (isLoadingMore.value || !hasMore.value) return;

    try {
      isLoadingMore.value = true;
      final result = await _service.getWorkouts(
        limit: pageSize,
        skip: currentSkip,
      );
      if (result.isNotEmpty) {
        workouts.addAll(result);
        currentSkip += result.length;
        hasMore.value = result.length >= pageSize;
      } else {
        hasMore.value = false;
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load more workouts");
    } finally {
      isLoadingMore.value = false;
    }
  }

  // 2. Load Detail
  Future<void> loadWorkoutDetail(String id) async {
    try {
      isLoadingDetail.value = true;
      final result = await _service.getWorkoutDetail(id);
      currentWorkout.value = result;
    } catch (e) {
      Get.snackbar("Error", "Failed to load workout details");
    } finally {
      isLoadingDetail.value = false;
    }
  }

  // 3. Add Manual Set
  Future<void> addSet(
    String exerciseId,
    String reps,
    String weight,
    String rpe,
  ) async {
    if (currentWorkout.value == null) return;

    try {
      await _service.addSet(
        currentWorkout.value!.id,
        exerciseId,
        int.parse(reps),
        double.parse(weight),
        int.tryParse(rpe),
      );

      // Refresh the detail view to show the new set
      await loadWorkoutDetail(currentWorkout.value!.id);
      Get.back(); // Close bottom sheet
      Get.snackbar("Success", "Set added!");
    } catch (e) {
      Get.snackbar("Error", "Failed to add set");
    }
  }

  // 4. AI Log
  Future<void> logWorkoutAI() async {
    if (aiInputController.text.isEmpty) {
      Get.snackbar("Error", "Please enter workout details");
      return;
    }

    try {
      isAiLoading.value = true;
      final workoutId = await _service.logWorkoutAI(aiInputController.text);

      aiInputController.clear();
      Get.snackbar("Success", "Workout logged by AI!");

      // Navigate to the newly created workout
      await loadWorkoutDetail(workoutId);
      Get.offNamed(Routes.WORKOUT_DETAIL, arguments: workoutId);

      // Refresh list in background
      fetchWorkouts();
    } catch (e) {
      Get.snackbar("Error", "AI Logging failed. Try again.");
    } finally {
      isAiLoading.value = false;
    }
  }

  // 5. Create Workout
  Future<void> createWorkout({
    required DateTime date,
    int durationMinutes = 0,
    String? mood,
    String? notes,
  }) async {
    try {
      isLoadingList.value = true;
      final newWorkout = await _service.createWorkout(
        date: date,
        durationMinutes: durationMinutes,
        mood: mood,
        notes: notes,
      );

      // Add to list and refresh
      await fetchWorkouts();

      // Navigate to detail
      await loadWorkoutDetail(newWorkout.id);
      Get.toNamed(Routes.WORKOUT_DETAIL);

      Get.snackbar("Success", "Workout created!");
    } catch (e) {
      Get.snackbar("Error", "Failed to create workout");
    } finally {
      isLoadingList.value = false;
    }
  }

  // 6. Delete Workout
  Future<void> deleteWorkout(String id) async {
    try {
      await _service.deleteWorkout(id);
      workouts.removeWhere((workout) => workout.id == id);
      Get.snackbar("Success", "Workout deleted!");
    } catch (e) {
      Get.snackbar("Error", "Failed to delete workout");
    }
  }
}
