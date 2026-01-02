import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fittrack_mobile/app/data/models/exercise.dart';
import 'package:fittrack_mobile/app/modules/exercises/exercises_service.dart';
import 'package:fittrack_mobile/app/core/network/api_exception.dart';

class ExercisesController extends GetxController {
  final ExercisesService _service = ExercisesService();

  // Observables
  var exercises = <Exercise>[].obs;
  var isLoading = true.obs;

  // Text Controllers for Add/Edit Forms
  final nameController = TextEditingController();
  final muscleController = TextEditingController();
  final equipmentController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchExercises();
  }

  Future<void> fetchExercises() async {
    try {
      isLoading.value = true;
      final result = await _service.getExercises();
      exercises.assignAll(result);
    } catch (e) {
      Get.snackbar("Error", "Failed to load exercises");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addExercise() async {
    try {
      isLoading.value = true;
      await _service.createExercise(
        nameController.text,
        muscleController.text,
        equipmentController.text,
      );
      Get.back(); // Close dialog/sheet
      fetchExercises(); // Refresh list
      _clearControllers();
      Get.snackbar("Success", "Exercise added!");
    } catch (e) {
      Get.snackbar("Error", "Failed to add exercise");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteExercise(String id) async {
    try {
      await _service.deleteExercise(id);
      exercises.removeWhere((e) => e.id == id);
    } catch (e) {
      Get.snackbar("Error", "Failed to delete exercise");
    }
  }

  Future<void> uploadImage(String id, File file) async {
    try {
      await _service.uploadImage(id, file);
      Get.snackbar("Success", "Image uploaded successfully");
    } catch (e) {
      Get.snackbar("Error", "Failed to upload image");
    }
  }

  void _clearControllers() {
    nameController.clear();
    muscleController.clear();
    equipmentController.clear();
  }

  @override
  void onClose() {
    nameController.dispose();
    muscleController.dispose();
    equipmentController.dispose();
    super.onClose();
  }
}
