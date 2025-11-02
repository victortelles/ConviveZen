import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/profile_option_tile.dart';

class SubscriptionCard extends StatelessWidget {
  final Function() onShowSubscriptionOptions;

  const SubscriptionCard({
    Key? key,
    required this.onShowSubscriptionOptions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ProfileOptionTile(
              title: "Plan Actual: ConviveZen Gratis",
              subtitle: "Acceso a herramientas básicas de bienestar",
              icon: Icons.health_and_safety,
              color: Colors.green,
              onTap: onShowSubscriptionOptions,
              trailing: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'ACTIVO',
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}