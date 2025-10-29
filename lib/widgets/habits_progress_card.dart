import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/app_state.dart';

class HabitsProgressCard extends StatelessWidget {
  final AppState appState;

  const HabitsProgressCard({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    int completedHabits =
        appState.habitStatus.values.where((status) => status).length;
   final  int totalHabits = appState.habitStatus.length;
    double progress = totalHabits > 0 ? completedHabits / totalHabits : 0;
    Color cardColor = progress == 1.0 ? Colors.green : Colors.blue.shade900;

    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Progreso de hábitos",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 4),
            Text("$completedHabits de $totalHabits completados",
                style: GoogleFonts.poppins(color: Colors.white)),
            SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white.withOpacity(0.5),
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
