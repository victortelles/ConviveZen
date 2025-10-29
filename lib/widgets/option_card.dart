import 'package:flutter/material.dart';

class OptionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const OptionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {

    //Color principal
    final Color primaryColor = const Color(0xFF3942FF);

    return GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          //Animacion y duracion
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,

          // Decoracion del contenedor animado.
          decoration: BoxDecoration(
              color: isSelected
                  ? primaryColor.withOpacity(0.2)
                  : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? primaryColor
                    : Colors.grey.shade300,
                width: 2,
              ),

              //Sombreado
              boxShadow: [
                BoxShadow(
                  color: isSelected
                      ? primaryColor.withOpacity(0.2)
                      : Colors.grey.withOpacity(0.2),
                  spreadRadius: isSelected ? 2 : 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
            ],
          ),

          child: AspectRatio(
            aspectRatio: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedScale(
                  duration: const Duration(milliseconds: 300),
                  scale: isSelected ? 1.1 : 1.0,
                  child: Icon(
                    icon,
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : Colors.grey.shade600,
                    size: 28,
                  ),
                ),

                //Espaciado
                const SizedBox(height: 12),

                //Texto
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected
                        ? primaryColor
                        : Colors.black,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),

                //Si esta seleccionado, bordearle el color
                AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: isSelected ? 30 : 0,
                    margin: const EdgeInsets.only(top: 8),
                    padding: EdgeInsets.symmetric(
                      horizontal: isSelected ? 12: 0,
                      vertical: isSelected ? 4 : 0
                    ),

                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),

                    child: isSelected
                      ? const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 16,
                      )
                    : const SizedBox(),
                  ),
              ],
            ),
          ),
        ),
      );
  }
}
