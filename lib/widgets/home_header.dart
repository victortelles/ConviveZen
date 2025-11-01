import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/app_state.dart';

class HomeHeader extends StatelessWidget {
  final AppState appState;

  const HomeHeader({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    //Obtener nombre y limitarlo
    final name = appState.userProfile?.name ?? 'Usuario';
    final nameParts = name.split(' ');
    String displayName = 'Usuario';

    //Separar el nombre y solo tomar [NombreP] [NombreSec]
    if (nameParts.length == 1) {
      displayName = nameParts[0];
    } else if (nameParts.length >= 2) {
      displayName = '${nameParts[0]} ${nameParts[1].substring(0, 1)}.';
    }

    final greeting = 'Hola, $displayName';
    // Color backgroundColor = appState.isDarkMode ? Colors.black : Colors.white;
    // Color textColor = appState.isDarkMode ? Colors.white : Colors.black;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // Animated Waving Hand Icon
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: -10, end: 10),
          duration: const Duration(milliseconds: 300),
          builder: (context, value, child) {
            // double rotationAngle = value;
            return Transform.rotate(
              angle: value * (3.141592653589793 / 180),
              child: Icon(Icons.waving_hand,
                  color: Colors.blue.shade900, size: 30),
            );
          },
        ),
        const SizedBox(width: 8), // Espacio entre el icono y el texto

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greeting,
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: appState.isDarkMode ? Colors.white : Colors.black,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text("Listo para empezar tu día",
                  style: GoogleFonts.poppins(color: Colors.grey)),
            ],
          ),
        ),
      ],
    );
  }
}
