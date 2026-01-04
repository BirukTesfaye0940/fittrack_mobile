import 'package:fittrack_mobile/app/data/models/workout_set.dart';

class Workout {
  final String id;
  final DateTime date;
  final int durationMinutes;
  final String? mood;
  final String? notes;
  final List<WorkoutSet> workoutSets;

  Workout({
    required this.id,
    required this.date,
    required this.durationMinutes,
    this.mood,
    this.notes,
    this.workoutSets = const [],
  });

  factory Workout.fromJson(Map<String, dynamic> json) {
    var setsList = <WorkoutSet>[];
    if (json['workout_sets'] != null) {
      setsList = (json['workout_sets'] as List)
          .map((e) => WorkoutSet.fromJson(e))
          .toList();
    }

    return Workout(
      id: json['id'],
      date: DateTime.parse(json['date']),
      durationMinutes: json['duration_minutes'] ?? 0,
      mood: json['mood'],
      notes: json['notes'],
      workoutSets: setsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "date": date.toIso8601String().split('T').first, // Format YYYY-MM-DD
      "duration_minutes": durationMinutes,
      "mood": mood,
      "notes": notes,
    };
  }
}
