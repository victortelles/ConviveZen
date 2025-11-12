import 'package:flutter/material.dart';

class EmergencyToolButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool isPremium;
  final VoidCallback onTap;

  const EmergencyToolButton({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.isPremium,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isPremium ? Colors.orange.shade300 : color.withOpacity(0.3),
            width: isPremium ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isPremium ? Colors.orange.withOpacity(0.2) : color.withOpacity(0.2),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Badge Premium en la parte superior si es premium
            if (isPremium)
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade500,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'PREMIUM',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            
            // Contenido centrado
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: isPremium ? Colors.grey.shade400 : color,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Icon(
                      isPremium ? Icons.lock : icon,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isPremium ? Colors.grey.shade600 : Colors.pink.shade700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 4),
                  Text(
                    isPremium ? 'Solo Premium' : subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isPremium ? Colors.grey.shade500 : Colors.pink.shade500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}