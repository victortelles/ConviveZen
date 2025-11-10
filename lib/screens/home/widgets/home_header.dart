import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  final String userName;
  final VoidCallback onProfileTap;

  const HomeHeader({
    Key? key,
    required this.userName,
    required this.onProfileTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hola, $userName',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.pink.shade700,
                ),
              ),
              // Text(
              //   '¿Cómo te sientes hoy?',
              //   style: TextStyle(
              //     fontSize: 16,
              //     color: Colors.pink.shade600,
              //   ),
              // ),
            ],
          ),
          GestureDetector(
            onTap: onProfileTap,
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.pink.shade200,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}