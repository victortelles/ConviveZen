import 'package:flutter/material.dart';
import '../../screens/community.dart';

class CommunityCard extends StatelessWidget {
  const CommunityCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CommunityScreen(),
          ),
        );
      },
      child: Card(
        color: Colors.blue.shade900,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          title: Text("Comunidad 👥", style: TextStyle(color: Colors.white)),
          subtitle: Text("Entérate de los hábitos de tus amigos",
              style: TextStyle(color: Colors.white70)),
          trailing: Icon(Icons.arrow_forward_ios, color: Colors.white),
        ),
      ),
    );
  }
}
