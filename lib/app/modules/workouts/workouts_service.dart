import 'package:fittrack_mobile/app/core/network/api_client.dart';
import 'package:fittrack_mobile/app/data/models/workout.dart';
import 'package:fittrack_mobile/app/data/models/workout_set.dart';

class WorkoutsService {
  final ApiClient _client = ApiClient();

  /// GET /workouts/
  Future<List<Workout>> getWorkouts({int limit = 10, int skip = 0}) async {
    final response = await _client.dio.get(
      '/workouts/',
      queryParameters: {"limit": limit, "skip": skip},
    );
    return (response.data as List).map((e) => Workout.fromJson(e)).toList();
  }

  /// GET /workouts/{id}
  Future<Workout> getWorkout(String id) async {
    final response = await _client.dio.get('/workouts/$id');
    return Workout.fromJson(response.data);
  }

  /// POST /workouts/
  Future<Workout> createWorkout(
    DateTime date, {
    String? mood,
    String? notes,
  }) async {
    final response = await _client.dio.post(
      '/workouts/', // Ensure no trailing slash if backend dislikes it, or keep consistent
      data: {
        "date": date.toIso8601String().split('T').first,
        "mood": mood,
        "notes": notes,
        "duration_minutes": 0, // Default
      },
    );
    return Workout.fromJson(response.data);
  }

  /// POST /workout-sets/workouts/{workout_id}/sets
  Future<WorkoutSet> addSet(
    String workoutId,
    String exerciseId,
    int reps,
    double weight, {
    double? rpe,
  }) async {
    final response = await _client.dio.post(
      '/workout-sets/workouts/$workoutId/sets',
      data: {
        "exercise_id": exerciseId,
        "reps": reps,
        "weight": weight,
        "rpe": rpe,
      },
    );
    return WorkoutSet.fromJson(response.data);
  }

  /// POST /ai/workouts/log
  Future<String> logWorkoutAI(String text) async {
    final response = await _client.dio.post(
      '/ai/workouts/log',
      data: {"text": text},
    );
    // Returns { "workout_id": "...", "status": "...", ... }
    return response.data['workout_id'];
  }
}
