import 'package:flutter/material.dart';

class PremiumFeatureDialog extends StatelessWidget {
  final String featureName;

  const PremiumFeatureDialog({
    Key? key,
    required this.featureName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.star, color: Colors.orange.shade600),
          SizedBox(width: 8),
          Text('Función Premium'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$featureName es una función premium.',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text('Con la suscripción Premium tendrás acceso a:'),
          SizedBox(height: 8),
          Text('• Meditaciones personalizadas'),
          Text('• Chat de IA compasiva'),
          Text('• Juegos calmantes avanzados'),
          Text('• Análisis detallado de progreso'),
          Text('• Alertas inteligentes'),
          SizedBox(height: 10),
          Text(
            'Suscríbete para desbloquear todas las herramientas de manejo de ansiedad.',
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Más tarde'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Suscripción Premium próximamente disponible'),
                backgroundColor: Colors.orange.shade600,
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange.shade600,
            foregroundColor: Colors.white,
          ),
          child: Text('Suscribirse'),
        ),
      ],
    );
  }
}