class Exercise {
  final String id;
  final String name;
  final String muscleGroup;
  final String equipment;
  final String? imageUrl; // Optional, in case you return it later

  Exercise({
    required this.id,
    required this.name,
    required this.muscleGroup,
    required this.equipment,
    this.imageUrl,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'],
      name: json['name'],
      muscleGroup: json['muscle_group'], // backend uses snake_case
      equipment: json['equipment'],
    );
  }

  Map<String, dynamic> toJson() {
    return {"name": name, "muscle_group": muscleGroup, "equipment": equipment};
  }
}
