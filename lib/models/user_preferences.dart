class UserPreferences {
  String? gender;
  //Lista de seleccion usuario
  List<String> selectedHabits;
  List<String> selectedExercises;
  List<String> selectedSports;
  List<String> selectedDays;

  //Constructur con valores defecto si son nulos
  UserPreferences({
    this.gender,
    List<String>? selectedHabits,
    List<String>? selectedExercises,
    List<String>? selectedSports,
    List<String>? selectedDays,
  }): selectedHabits = selectedHabits ?? [],
      selectedExercises = selectedExercises ?? [],
      selectedSports = selectedSports ?? [],
      selectedDays = selectedDays ?? [];

  //Convertir a JSON (para almacenar o enviar)
  Map<String, dynamic> toJson() {
    return {
      'gender': gender,
      'selectedHabits': selectedHabits,
      'selectedExercises': selectedExercises,
      'selectedSports': selectedSports,
      'selectedDays': selectedDays,
    };
  }

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      gender: json['gender'],
      selectedHabits: List<String>.from(json['selectedHabits'] ?? []),
      selectedExercises: List<String>.from(json['selectedExercises'] ?? []),
      selectedSports: List<String>.from(json['selectedSports'] ?? []),
      selectedDays: List<String>.from(json['selectedDays'] ?? []),
    );
  }
}
