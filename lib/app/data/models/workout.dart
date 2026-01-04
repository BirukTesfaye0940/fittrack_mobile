import 'package:fittrack_mobile/app/data/models/workout_set.dart';

class Workout {
  final String id;
  final DateTime date;
  final int? durationMinutes;
  final String? mood;
  final String? notes;
  final List<WorkoutSet> sets; // Populated in detail view

  Workout({
    required this.id,
    required this.date,
    this.durationMinutes,
    this.mood,
    this.notes,
    this.sets = const [],
  });

  factory Workout.fromJson(Map<String, dynamic> json) {
    var list = json['sets'] as List? ?? [];
    List<WorkoutSet> setsList = list
        .map((i) => WorkoutSet.fromJson(i))
        .toList();

    return Workout(
      id: json['id'],
      date: DateTime.parse(json['date']),
      durationMinutes: json['duration_minutes'],
      mood: json['mood'],
      notes: json['notes'],
      sets: setsList,
    );
  }
}
