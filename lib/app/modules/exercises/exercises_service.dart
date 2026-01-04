import 'dart:io';
import 'package:dio/dio.dart';
import 'package:fittrack_mobile/app/core/network/api_client.dart';
import 'package:fittrack_mobile/app/data/models/exercise.dart';

class ExercisesService {
  final ApiClient _client = ApiClient();

  /// GET /exercises/
  Future<List<Exercise>> getExercises() async {
    final response = await _client.dio.get('/exercises/');
    return (response.data as List).map((e) => Exercise.fromJson(e)).toList();
  }

  /// POST /exercises/
  Future<Exercise> createExercise(
    String name,
    String muscleGroup,
    String equipment,
  ) async {
    final response = await _client.dio.post(
      '/exercises/',
      data: {"name": name, "muscle_group": muscleGroup, "equipment": equipment},
    );
    return Exercise.fromJson(response.data);
  }

  /// PATCH /exercises/{id}/
  Future<Exercise> updateExercise(String id, Map<String, dynamic> data) async {
    final response = await _client.dio.patch('/exercises/$id', data: data);
    return Exercise.fromJson(response.data);
  }

  /// DELETE /exercises/{id}/
  Future<void> deleteExercise(String id) async {
    await _client.dio.delete('/exercises/$id');
  }

  /// POST /exercises/{id}/image/
  Future<void> uploadImage(String id, File imageFile) async {
    String fileName = imageFile.path.split('/').last;

    // Create FormData for file upload
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(imageFile.path, filename: fileName),
    });

    await _client.dio.post('/exercises/$id/image', data: formData);
  }
}
