class WorkoutSet {
  final String id;
  final String workoutId;
  final String exerciseId;
  final int reps;
  final double weight;
  final double? rpe;
  final String?
  exerciseName; // Optional, might be populated manually or via join

  WorkoutSet({
    required this.id,
    required this.workoutId,
    required this.exerciseId,
    required this.reps,
    required this.weight,
    this.rpe,
    this.exerciseName,
  });

  factory WorkoutSet.fromJson(Map<String, dynamic> json) {
    return WorkoutSet(
      id: json['id'],
      workoutId: json['workout_id'],
      exerciseId: json['exercise_id'],
      reps: json['reps'],
      weight: (json['weight'] as num).toDouble(),
      rpe: json['rpe'] != null ? (json['rpe'] as num).toDouble() : null,
      exerciseName:
          json['exercise_name'], // Make sure backend sends this or we fetch it
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "exercise_id": exerciseId,
      "reps": reps,
      "weight": weight,
      "rpe": rpe,
    };
  }
}
