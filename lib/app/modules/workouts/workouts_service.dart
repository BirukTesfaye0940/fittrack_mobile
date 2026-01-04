import 'package:fittrack_mobile/app/core/network/api_client.dart';
import 'package:fittrack_mobile/app/data/models/workout.dart';
import 'package:fittrack_mobile/app/data/models/workout_set.dart';

class WorkoutsService {
  final ApiClient _client = ApiClient();

  /// GET /workouts/
  Future<List<Workout>> getWorkouts({int limit = 10, int skip = 0}) async {
    final response = await _client.dio.get(
      '/workouts/',
      queryParameters: {'limit': limit, 'skip': skip},
    );
    return (response.data as List).map((e) => Workout.fromJson(e)).toList();
  }

  /// GET /workouts/{id} (Assuming you have a detail endpoint, otherwise we use the list data)
  /// Note: Based on your API docs, you might need to rely on the list or a specific Get endpoint.
  /// If the list doesn't return "sets", you might need a separate call.
  /// For this example, I'll assume fetching the list includes sets or you have a detail endpoint.
  Future<Workout> getWorkoutDetail(String id) async {
    // If your backend doesn't have a specific GET /workouts/{id},
    // you might need to rely on the data passed from the list or implement that endpoint.
    // I will assume standard REST practice here:
    final response = await _client.dio.get('/workouts/$id');
    return Workout.fromJson(response.data);
  }

  /// POST /workouts/
  Future<Workout> createWorkout({
    required DateTime date,
    int durationMinutes = 0,
    String? mood,
    String? notes,
  }) async {
    final response = await _client.dio.post(
      '/workouts/',
      data: {
        "date": date.toIso8601String().split('T')[0], // YYYY-MM-DD
        "duration_minutes": durationMinutes,
        "mood": mood ?? "Neutral",
        "notes": notes ?? "",
      },
    );
    return Workout.fromJson(response.data);
  }

  /// POST /workout-sets/workouts/{workout_id}/sets
  Future<WorkoutSet> addSet(
    String workoutId,
    String exerciseId,
    int reps,
    double weight,
    int? rpe,
  ) async {
    final response = await _client.dio.post(
      '/workout-sets/workouts/$workoutId/sets',
      data: {
        "exercise_id": exerciseId,
        "reps": reps,
        "weight": weight,
        "rpe": rpe ?? 0,
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
    // Returns the created workout ID
    return response.data['workout_id'];
  }

  /// DELETE /workouts/{id}
  Future<void> deleteWorkout(String id) async {
    await _client.dio.delete('/workouts/$id');
  }
}
