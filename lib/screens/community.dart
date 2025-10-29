import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../widgets/nav_bar.dart';

import 'package:convivezen/screens/profile.dart';
import 'package:convivezen/screens/home.dart';
import 'package:convivezen/screens/activity.dart';
import 'package:convivezen/screens/events.dart';

class CommunityScreen extends StatefulWidget {
  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  final Map<String, List<String>> friendsProgress = {
    "Tu agua del día": ["Carlos", "María"],
    "Meditación": ["Luis", "Ana"],
    "Regar tus plantas": ["Sofía", "Daniel"],
    "Lectura diaria": ["Elena"],
    "Tender la cama": ["Juan", "Lucía"],
    "Pasear al perro": ["Pedro", "Diana"]
  };

  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    var appState = Provider.of<AppState>(context, listen: false);

    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ExploreScreen(),
        ),
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ActivityScreen(),
        ),
      );
    } else if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileScreen(),
        ),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<AppState>(context);

    return Scaffold(
      backgroundColor: appState.isDarkMode ? Colors.black : Colors.grey[200],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Comunidad"),
        titleTextStyle: TextStyle(color: appState.isDarkMode ? Colors.white : Colors.black, fontSize: 20),
        backgroundColor: appState.isDarkMode ? Colors.grey[900] : Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Hábitos de la comunidad",
                style: GoogleFonts.poppins(
                    fontSize: 18, fontWeight: FontWeight.bold, color: appState.isDarkMode ? Colors.white : Colors.black)),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: appState.habitStatus.keys.length,
                itemBuilder: (context, index) {
                  String habit = appState.habitStatus.keys.elementAt(index);
                  bool isCompleted = appState.habitStatus[habit] ?? false;
                  List<String> friends = friendsProgress[habit] ?? [];
                  return Card(
                    color: appState.isDarkMode ? Colors.grey[800] : Colors.white,
                    child: ListTile(
                      title: Text(habit, style: TextStyle(color: appState.isDarkMode ? Colors.white : Colors.black)),
                      subtitle: Text(
                        friends.isNotEmpty ? "Completado por: ${friends.join(", ")}" : "Aún nadie lo ha completado",
                        style: TextStyle(color: appState.isDarkMode ? Colors.white70 : Colors.black54),
                      ),
                      leading: Icon(
                        Icons.check_circle,
                        color: isCompleted ? Colors.blue.shade900 : Colors.grey,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
