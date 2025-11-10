// Modelo para ejercicios de respiración guiada
class BreathingExercise {
  final String id;
  final String name;
  final String description;
  final List<BreathingPhase> phases;
  final int cycles;
  final String difficulty; // 'easy', 'medium', 'hard'
  final List<String> benefits;
  final String? instructions;

  BreathingExercise({
    required this.id,
    required this.name,
    required this.description,
    required this.phases,
    this.cycles = 4,
    this.difficulty = 'easy',
    this.benefits = const [],
    this.instructions,
  });

  // Duración total del ejercicio en segundos
  int get totalDuration {
    final phaseDuration = phases.fold<int>(0, (sum, phase) => sum + phase.duration);
    return phaseDuration * cycles;
  }

  // Obtener descripción del ciclo
  String get cycleDescription {
    return phases.map((phase) => '${phase.name}: ${phase.duration}s').join(' → ');
  }
}

// Fase de un ejercicio de respiración
class BreathingPhase {
  final String name;
  final String instruction;
  final int duration; // en segundos
  final BreathingAction action;

  BreathingPhase({
    required this.name,
    required this.instruction,
    required this.duration,
    required this.action,
  });
}

// Acciones de respiración
enum BreathingAction {
  inhale,   // Inhalar
  hold,     // Sostener
  exhale,   // Exhalar
  pause,    // Pausa
}

// Ejercicios predefinidos
class BreathingExercises {
  // Ejercicio 4-7-8 (Técnica del Dr. Andrew Weil)
  static BreathingExercise get fourSevenEight => BreathingExercise(
        id: '4-7-8',
        name: 'Respiración 4-7-8',
        description: 'Técnica relajante para reducir ansiedad y mejorar el sueño',
        difficulty: 'easy',
        cycles: 4,
        benefits: [
          'Reduce la ansiedad rápidamente',
          'Ayuda a conciliar el sueño',
          'Calma el sistema nervioso',
        ],
        instructions: 'Coloca la punta de tu lengua detrás de los dientes superiores y mantén esa posición durante todo el ejercicio.',
        phases: [
          BreathingPhase(
            name: 'Inhala',
            instruction: 'Inhala profundamente por la nariz',
            duration: 4,
            action: BreathingAction.inhale,
          ),
          BreathingPhase(
            name: 'Sostén',
            instruction: 'Sostén el aire',
            duration: 7,
            action: BreathingAction.hold,
          ),
          BreathingPhase(
            name: 'Exhala',
            instruction: 'Exhala completamente por la boca',
            duration: 8,
            action: BreathingAction.exhale,
          ),
        ],
      );

  // Respiración de caja (Box Breathing)
  static BreathingExercise get boxBreathing => BreathingExercise(
        id: 'box',
        name: 'Respiración Cuadrada',
        description: 'Técnica usada por Navy SEALs para mantener la calma en situaciones de estrés',
        difficulty: 'medium',
        cycles: 4,
        benefits: [
          'Mejora la concentración',
          'Reduce el estrés inmediato',
          'Equilibra el sistema nervioso',
        ],
        phases: [
          BreathingPhase(
            name: 'Inhala',
            instruction: 'Inhala por la nariz',
            duration: 4,
            action: BreathingAction.inhale,
          ),
          BreathingPhase(
            name: 'Sostén',
            instruction: 'Sostén el aire',
            duration: 4,
            action: BreathingAction.hold,
          ),
          BreathingPhase(
            name: 'Exhala',
            instruction: 'Exhala por la boca',
            duration: 4,
            action: BreathingAction.exhale,
          ),
          BreathingPhase(
            name: 'Sostén',
            instruction: 'Sostén sin aire',
            duration: 4,
            action: BreathingAction.pause,
          ),
        ],
      );

  // Respiración profunda simple
  static BreathingExercise get deepBreathing => BreathingExercise(
        id: 'deep',
        name: 'Respiración Profunda',
        description: 'Ejercicio simple y efectivo para calmar la ansiedad',
        difficulty: 'easy',
        cycles: 5,
        benefits: [
          'Reduce la tensión muscular',
          'Calma la mente',
          'Fácil de hacer en cualquier lugar',
        ],
        phases: [
          BreathingPhase(
            name: 'Inhala',
            instruction: 'Inhala profundamente por la nariz',
            duration: 5,
            action: BreathingAction.inhale,
          ),
          BreathingPhase(
            name: 'Sostén',
            instruction: 'Sostén brevemente',
            duration: 2,
            action: BreathingAction.hold,
          ),
          BreathingPhase(
            name: 'Exhala',
            instruction: 'Exhala lentamente por la boca',
            duration: 6,
            action: BreathingAction.exhale,
          ),
        ],
      );

  // Respiración calmante 5-5
  static BreathingExercise get calmBreathing => BreathingExercise(
        id: 'calm',
        name: 'Respiración Calmante',
        description: 'Ritmo equilibrado para tranquilizar cuerpo y mente',
        difficulty: 'easy',
        cycles: 6,
        benefits: [
          'Equilibra energía',
          'Reduce taquicardia',
          'Promueve sensación de paz',
        ],
        phases: [
          BreathingPhase(
            name: 'Inhala',
            instruction: 'Inhala suavemente',
            duration: 5,
            action: BreathingAction.inhale,
          ),
          BreathingPhase(
            name: 'Exhala',
            instruction: 'Exhala completamente',
            duration: 5,
            action: BreathingAction.exhale,
          ),
        ],
      );

  // Respiración triangular
  static BreathingExercise get triangleBreathing => BreathingExercise(
        id: 'triangle',
        name: 'Respiración Triangular',
        description: 'Patrón rítmico de tres pasos para centrarte',
        difficulty: 'medium',
        cycles: 5,
        benefits: [
          'Mejora el enfoque',
          'Reduce ansiedad moderada',
          'Fácil de recordar',
        ],
        phases: [
          BreathingPhase(
            name: 'Inhala',
            instruction: 'Inhala profundamente',
            duration: 4,
            action: BreathingAction.inhale,
          ),
          BreathingPhase(
            name: 'Sostén',
            instruction: 'Sostén el aire',
            duration: 4,
            action: BreathingAction.hold,
          ),
          BreathingPhase(
            name: 'Exhala',
            instruction: 'Exhala completamente',
            duration: 4,
            action: BreathingAction.exhale,
          ),
        ],
      );

  // Lista de todos los ejercicios
  static List<BreathingExercise> get allExercises => [
        fourSevenEight,
        boxBreathing,
        deepBreathing,
        calmBreathing,
        triangleBreathing,
      ];

  // Obtener ejercicio aleatorio
  static BreathingExercise getRandomExercise() {
    final exercises = allExercises;
    exercises.shuffle();
    return exercises.first;
  }

  // Obtener ejercicio por ID
  static BreathingExercise? getExerciseById(String id) {
    try {
      return allExercises.firstWhere((exercise) => exercise.id == id);
    } catch (e) {
      return null;
    }
  }
}
