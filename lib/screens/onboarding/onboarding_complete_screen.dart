import 'package:flutter/material.dart';

class OnboardingCompleteScreen extends StatelessWidget {
  const OnboardingCompleteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.pink.shade400,
              borderRadius: BorderRadius.circular(60),
            ),
            child: Icon(
              Icons.check,
              color: Colors.white,
              size: 60,
            ),
          ),
          SizedBox(height: 30),
          Text(
            '¡Configuración completa!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.pink.shade700,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Text(
            'Hemos personalizado ConviveZen especialmente para ti',
            style: TextStyle(
              fontSize: 18,
              color: Colors.pink.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30),
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.pink.shade50,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.pink.shade200),
            ),
            child: Column(
              children: [
                Text(
                  'Tu botón de emergencia está listo',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink.shade700,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Ahora tienes acceso a herramientas personalizadas que te ayudarán en momentos de ansiedad',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.pink.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/home');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink.shade400,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 3,
              ),
              child: Text(
                'Ir a mi pantalla principal',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}