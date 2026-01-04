class WorkoutSet {
  final String id;
  final String exerciseId;
  final String?
  exerciseName; // Often useful if backend provides it, or we join locally
  final int reps;
  final double weight;
  final int? rpe;

  WorkoutSet({
    required this.id,
    required this.exerciseId,
    this.exerciseName,
    required this.reps,
    required this.weight,
    this.rpe,
  });

  factory WorkoutSet.fromJson(Map<String, dynamic> json) {
    return WorkoutSet(
      id: json['id'],
      exerciseId: json['exercise_id'],
      // If your backend nests exercise details inside the set response, handle it here.
      // Otherwise, you might need to lookup the name from your ExercisesController.
      exerciseName: json['exercise']?['name'] ?? 'Unknown Exercise',
      reps: json['reps'],
      weight: (json['weight'] as num).toDouble(),
      rpe: json['rpe'],
    );
  }
}
