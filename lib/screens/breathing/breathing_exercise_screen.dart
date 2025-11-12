import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/breathing_exercise.dart';

// Pantalla principal para ejercicios de respiración guiada
class BreathingExerciseScreen extends StatefulWidget {
  final BreathingExercise? exercise;

  const BreathingExerciseScreen({
    Key? key,
    this.exercise,
  }) : super(key: key);

  @override
  _BreathingExerciseScreenState createState() =>
      _BreathingExerciseScreenState();
}

class _BreathingExerciseScreenState extends State<BreathingExerciseScreen>
    with TickerProviderStateMixin {
  late BreathingExercise _currentExercise;
  late AnimationController _breathController;
  late AnimationController _pulseController;
  late Animation<double> _breathAnimation;
  late Animation<double> _pulseAnimation;

  bool _showingIntro = true;
  bool _isStarted = false;
  bool _isPaused = false;
  bool _isCompleted = false;

  int _currentCycle = 0;
  int _currentPhaseIndex = 0;
  int _remainingSeconds = 0;
  int _introCountdown = 3; // Countdown: Preparado... Listo... Empecemos!
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // Seleccionar ejercicio (aleatorio si no se proporciona)
    _currentExercise =
        widget.exercise ?? BreathingExercises.getRandomExercise();

    // Configurar controladores de animación
    _breathController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _breathAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _breathController, curve: Curves.easeInOut),
    );

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Mostrar pantalla introductoria con countdown
    _startIntroCountdown();
  }

  // Iniciar countdown de introducción
  void _startIntroCountdown() {
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      if (mounted) {
        setState(() {
          _introCountdown--;
        });

        if (_introCountdown <= 0) {
          timer.cancel();
          setState(() {
            _showingIntro = false;
          });
          _startExercise();
        }
      }
    });
  }

  @override
  void dispose() {
    _breathController.dispose();
    _pulseController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _getBackgroundColor(),
      appBar: _showingIntro ? null : AppBar(
        title: Text(
          _currentExercise.name,
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: _getAppBarColor(),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => _onBackPressed(),
        ),
        elevation: 0,
        actions: [
          // Botón de información durante el ejercicio
          if (_isStarted && !_isCompleted)
            IconButton(
              icon: Icon(Icons.info_outline, color: Colors.white),
              onPressed: _showExerciseInfo,
            ),
        ],
      ),
      body: SafeArea(
        child: _showingIntro 
            ? _buildIntroScreen() 
            : (_isCompleted ? _buildCompletionScreen() : _buildExerciseScreen()),
      ),
    );
  }

  // Pantalla introductoria de preparación
  Widget _buildIntroScreen() {
    String message;
    String emoji;
    
    switch (_introCountdown) {
      case 3:
        message = 'Preparado...';
        emoji = '🧘';
        break;
      case 2:
        message = 'Listo...';
        emoji = '💙';
        break;
      case 1:
        message = '¡Empecemos!';
        emoji = '✨';
        break;
      default:
        message = 'Respira...';
        emoji = '🌟';
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.blue.shade300,
            Colors.blue.shade100,
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Emoji animado
            TweenAnimationBuilder<double>(
              duration: Duration(milliseconds: 500),
              tween: Tween(begin: 0.8, end: 1.0),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Text(
                    emoji,
                    style: TextStyle(fontSize: 80),
                  ),
                );
              },
            ),
            
            SizedBox(height: 40),
            
            // Título del ejercicio
            Text(
              _currentExercise.name,
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            
            SizedBox(height: 20),
            
            // Mensaje de preparación
            Text(
              message,
              style: GoogleFonts.poppins(
                fontSize: 32,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
            
            SizedBox(height: 40),
            
            // Frases calmantes
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                _getCalmingPhrase(),
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.9),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Obtener frase calmante según el countdown
  String _getCalmingPhrase() {
    switch (_introCountdown) {
      case 3:
        return 'Encuentra un lugar cómodo y relájate';
      case 2:
        return 'Vamos a respirar juntos, con calma';
      case 1:
        return 'Todo va a estar bien';
      default:
        return 'Respira profundo';
    }
  }

  // Pantalla del ejercicio
  Widget _buildExerciseScreen() {
    return Column(
      children: [
        // Indicador de progreso
        _buildProgressIndicator(),

        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animación de respiración
                _buildBreathingAnimation(),

                SizedBox(height: 40),

                // Instrucción actual
                _buildCurrentInstruction(),

                SizedBox(height: 20),

                // Contador de tiempo
                _buildTimeCounter(),

                SizedBox(height: 40),

                // Botones de control
                _buildControlButtons(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Indicador de progreso
  Widget _buildProgressIndicator() {
    final progress =
        (_currentCycle * _currentExercise.phases.length + _currentPhaseIndex) /
            (_currentExercise.cycles * _currentExercise.phases.length);

    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ciclo ${_currentCycle + 1} de ${_currentExercise.cycles}',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: TweenAnimationBuilder<double>(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              tween: Tween<double>(
                begin: 0,
                end: progress,
              ),
              builder: (context, value, _) => LinearProgressIndicator(
                value: value,
                backgroundColor: Colors.white.withOpacity(0.3),
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                minHeight: 8,
              ),
            ),
          ),
          //   minHeight: 8,
          //   borderRadius: BorderRadius.circular(4),
          // ),
        ],
      ),
    );
  }

  // Animación de respiración (círculo que crece y decrece)
  Widget _buildBreathingAnimation() {
    return AnimatedBuilder(
      animation: Listenable.merge([_breathAnimation, _pulseAnimation]),
      builder: (context, child) {
        final currentPhase = _currentExercise.phases[_currentPhaseIndex];
        final color = _getPhaseColor(currentPhase.action);

        return Container(
          width: 280,
          height: 280,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Círculo exterior pulsante
              Container(
                width: 280 * _pulseAnimation.value,
                height: 280 * _pulseAnimation.value,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withOpacity(0.1),
                ),
              ),
              // Círculo principal animado
              Container(
                width: 180 * _breathAnimation.value,
                height: 180 * _breathAnimation.value,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      color.withOpacity(0.8),
                      color,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.5),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    _getPhaseIcon(currentPhase.action),
                    color: Colors.white,
                    size: 60 * _breathAnimation.value,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Instrucción actual
  Widget _buildCurrentInstruction() {
    final currentPhase = _currentExercise.phases[_currentPhaseIndex];

    return Column(
      children: [
        Text(
          currentPhase.name.toUpperCase(),
          style: GoogleFonts.poppins(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 2,
          ),
        ),
        SizedBox(height: 8),
        Text(
          currentPhase.instruction,
          style: GoogleFonts.poppins(
            fontSize: 18,
            color: Colors.white.withOpacity(0.9),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // Contador de tiempo
  Widget _buildTimeCounter() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.2),
        border: Border.all(color: Colors.white, width: 3),
      ),
      child: Center(
        child: Text(
          '$_remainingSeconds',
          style: GoogleFonts.poppins(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // Botones de control
  Widget _buildControlButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Botón de pausa/reanudar
        FloatingActionButton(
          onPressed: _isPaused ? _resumeExercise : _pauseExercise,
          backgroundColor: Colors.white,
          child: Icon(
            _isPaused ? Icons.play_arrow : Icons.pause,
            color: _getAppBarColor(),
            size: 32,
          ),
        ),
        SizedBox(width: 20),
        // Botón de reiniciar
        FloatingActionButton(
          onPressed: _resetExercise,
          backgroundColor: Colors.white.withOpacity(0.3),
          child: Icon(
            Icons.refresh,
            color: Colors.white,
            size: 28,
          ),
        ),
      ],
    );
  }

  // Pantalla de completado
  Widget _buildCompletionScreen() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ícono de éxito
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green.shade100,
              ),
              child: Icon(
                Icons.check_circle,
                size: 80,
                color: Colors.green.shade600,
              ),
            ),

            SizedBox(height: 32),

            Text(
              '¡Excelente trabajo!',
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade700,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 16),

            Text(
              'Has completado el ejercicio de respiración',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey.shade700,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 8),

            Text(
              _currentExercise.name,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.blue.shade700,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 48),

            // Pregunta sobre cómo se siente
            Text(
              '¿Cómo te sientes ahora?',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),

            SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildMoodButton('😌', 'Mejor', Colors.green),
                SizedBox(width: 16),
                _buildMoodButton('😐', 'Igual', Colors.orange),
                SizedBox(width: 16),
                _buildMoodButton('😟', 'Peor', Colors.red),
              ],
            ),

            SizedBox(height: 48),

            // Botones de acción
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _isCompleted = false;
                  });
                  _resetExercise();
                },
                icon: Icon(Icons.replay),
                label: Text('Repetir ejercicio'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade500,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    _isCompleted = false;
                  });
                  _changeExercise();
                },
                icon: Icon(Icons.shuffle),
                label: Text('Probar otro ejercicio'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.blue.shade600,
                  side: BorderSide(color: Colors.blue.shade600),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            SizedBox(height: 12),

            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Volver al inicio'),
            ),
          ],
        ),
      ),
    );
  }

  // Botón de estado de ánimo
  Widget _buildMoodButton(String emoji, String label, Color color) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            // Aquí se podría guardar el feedback del usuario
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text('Se registro en tu perfil que te sientes: $label'),
                duration: Duration(seconds: 1),
              ),
            );
          },
          child: Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.1),
              border: Border.all(color: color, width: 2),
            ),
            child: Center(
              child: Text(
                emoji,
                style: TextStyle(fontSize: 32),
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }

  // Iniciar ejercicio
  void _startExercise() {
    setState(() {
      _isStarted = true;
      _currentCycle = 0;
      _currentPhaseIndex = 0;
      _remainingSeconds = _currentExercise.phases[0].duration;
    });
    _runPhase();
  }

  // Ejecutar fase actual
  void _runPhase() {
    final currentPhase = _currentExercise.phases[_currentPhaseIndex];

    // Configurar animación según la fase
    _breathController.duration = Duration(seconds: currentPhase.duration);

    switch (currentPhase.action) {
      case BreathingAction.inhale:
        _breathController.forward(from: 0.5);
        break;
      case BreathingAction.exhale:
        _breathController.reverse(from: 1.0);
        break;
      case BreathingAction.hold:
        _breathController.animateTo(1.0);
        break;
      case BreathingAction.pause:
        _breathController.animateTo(0.5);
        break;
    }

    // Iniciar contador
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_isPaused) return;

      setState(() {
        _remainingSeconds--;
      });

      if (_remainingSeconds <= 0) {
        timer.cancel();
        _nextPhase();
      }
    });
  }

  // Pasar a la siguiente fase
  void _nextPhase() {
    setState(() {
      _currentPhaseIndex++;

      // Si completamos todas las fases del ciclo
      if (_currentPhaseIndex >= _currentExercise.phases.length) {
        _currentPhaseIndex = 0;
        _currentCycle++;

        // Si completamos todos los ciclos
        if (_currentCycle >= _currentExercise.cycles) {
          _completeExercise();
          return;
        }
      }

      _remainingSeconds = _currentExercise.phases[_currentPhaseIndex].duration;
    });

    _runPhase();
  }

  // Pausar ejercicio
  void _pauseExercise() {
    setState(() {
      _isPaused = true;
    });
    _breathController.stop();
  }

  // Reanudar ejercicio
  void _resumeExercise() {
    setState(() {
      _isPaused = false;
    });
    _runPhase();
  }

  // Reiniciar ejercicio
  void _resetExercise() {
    _timer?.cancel();
    setState(() {
      _isStarted = true;
      _isPaused = false;
      _currentCycle = 0;
      _currentPhaseIndex = 0;
      _remainingSeconds = _currentExercise.phases[0].duration;
    });
    _runPhase();
  }

  // Completar ejercicio
  void _completeExercise() {
    _timer?.cancel();
    _breathController.stop();
    setState(() {
      _isCompleted = true;
    });
  }

  // Cambiar a otro ejercicio
  void _changeExercise() {
    setState(() {
      _currentExercise = BreathingExercises.getRandomExercise();
      _isStarted = false;
      _isPaused = false;
      _isCompleted = false;
    });
    _timer?.cancel();
    
    // Iniciar el nuevo ejercicio automáticamente
    Future.delayed(Duration(milliseconds: 500), () {
      if (mounted) {
        _startExercise();
      }
    });
  }

  // Confirmar salida
  void _onBackPressed() {
    if (_isStarted && !_isCompleted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Salir del ejercicio',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          content: Text(
            '¿Estás seguro de que deseas salir? Perderás el progreso actual.',
            style: GoogleFonts.poppins(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Continuar', style: GoogleFonts.poppins()),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text(
                'Salir',
                style: GoogleFonts.poppins(color: Colors.red),
              ),
            ),
          ],
        ),
      );
    } else {
      Navigator.pop(context);
    }
  }

  // Mostrar información del ejercicio (botón info)
  void _showExerciseInfo() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: EdgeInsets.all(20),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle visual
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                // Título
                Text(
                  _currentExercise.name,
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                ),
                SizedBox(height: 8),

                // Descripción
                Text(
                  _currentExercise.description,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey.shade700,
                  ),
                ),
                SizedBox(height: 20),

                // Patrón de respiración
                Text(
                  'Patrón',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue.shade800,
                  ),
                ),
                SizedBox(height: 8),
                ..._currentExercise.phases.map((phase) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Icon(
                          _getPhaseIcon(phase.action),
                          color: _getPhaseColor(phase.action),
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            phase.instruction,
                            style: GoogleFonts.poppins(fontSize: 13),
                          ),
                        ),
                        Text(
                          '${phase.duration}s',
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue.shade600,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                
                SizedBox(height: 20),

                // Beneficios
                if (_currentExercise.benefits.isNotEmpty) ...[
                  Text(
                    'Beneficios',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.green.shade700,
                    ),
                  ),
                  SizedBox(height: 8),
                  ..._currentExercise.benefits.map((benefit) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.check_circle, color: Colors.green.shade600, size: 18),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              benefit,
                              style: GoogleFonts.poppins(fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],

                // Instrucciones especiales
                if (_currentExercise.instructions != null) ...[
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue.shade700, size: 20),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _currentExercise.instructions!,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.blue.shade800,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                SizedBox(height: 20),

                // Botón cerrar
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade500,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Cerrar',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Obtener color de fondo según la fase
  Color _getBackgroundColor() {
    if (!_isStarted || _isCompleted) {
      return Colors.blue.shade50;
    }
    final currentPhase = _currentExercise.phases[_currentPhaseIndex];
    return _getPhaseColor(currentPhase.action).withOpacity(0.3);
  }

  // Obtener color de AppBar
  Color _getAppBarColor() {
    if (!_isStarted || _isCompleted) {
      return Colors.blue.shade400;
    }
    final currentPhase = _currentExercise.phases[_currentPhaseIndex];
    return _getPhaseColor(currentPhase.action);
  }

  // Obtener color según la acción
  Color _getPhaseColor(BreathingAction action) {
    switch (action) {
      case BreathingAction.inhale:
        return Colors.blue.shade500;
      case BreathingAction.hold:
        return Colors.purple.shade500;
      case BreathingAction.exhale:
        return Colors.green.shade500;
      case BreathingAction.pause:
        return Colors.orange.shade500;
    }
  }

  // Obtener ícono según la acción
  IconData _getPhaseIcon(BreathingAction action) {
    switch (action) {
      case BreathingAction.inhale:
        return Icons.arrow_upward;
      case BreathingAction.hold:
        return Icons.pause_circle_filled;
      case BreathingAction.exhale:
        return Icons.arrow_downward;
      case BreathingAction.pause:
        return Icons.remove_circle;
    }
  }

  // Obtener etiqueta de dificultad
  String _getDifficultyLabel() {
    switch (_currentExercise.difficulty) {
      case 'easy':
        return 'Fácil';
      case 'medium':
        return 'Medio';
      case 'hard':
        return 'Difícil';
      default:
        return _currentExercise.difficulty;
    }
  }
}
