import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../widgets/nav_bar.dart';
import '../providers/app_state.dart';

import 'package:convivezen/screens/profile.dart';
import 'package:convivezen/screens/home.dart';
import 'package:convivezen/screens/community.dart';
import 'package:convivezen/screens/events.dart';

class ActivityScreen extends StatefulWidget {
  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  int _selectedIndex = 3;

  void _onItemTapped(int index) {
    var appState = Provider.of<AppState>(context, listen: false);

    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CommunityScreen()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ExploreScreen(),
        ),
      );
    } else if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfileScreen()),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _showAlert(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Funcionalidad pendiente'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var appState = Provider.of<AppState>(context);

    return Scaffold(
      backgroundColor: appState.isDarkMode ? Colors.black : Colors.grey[200],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Actividad"),
        titleTextStyle: TextStyle(color: appState.isDarkMode ? Colors.white : Colors.black, fontSize: 20),
        backgroundColor: appState.isDarkMode ? Colors.grey[900] : Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDateSelector(appState),
              SizedBox(height: 16),
              _buildStatsCard(appState),
              SizedBox(height: 16),
              _buildHabitsChart(appState),
              SizedBox(height: 16),
              _buildMoodCard(appState),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }

  Widget _buildDateSelector(AppState appState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _dateButton("Día", appState),
        _dateButton("Semana", appState, isSelected: true),
        _dateButton("Mes", appState),
      ],
    );
  }

  Widget _dateButton(String text, AppState appState, {bool isSelected = false}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.blue.shade900 : (appState.isDarkMode ? Colors.grey[800] : Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      onPressed: () {
        _showAlert("Puchurraste en un botón de fecha");
      },
      child: Text(
        text,
        style: TextStyle(color: isSelected ? Colors.white : (appState.isDarkMode ? Colors.white70 : Colors.black)),
      ),
    );
  }

  Widget _buildStatsCard(AppState appState) {
    return Card(
      color: appState.isDarkMode ? Colors.grey[800] : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Todos tus hábitos", 
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.bold, color: appState.isDarkMode ? Colors.white : Colors.black)),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _statColumn("Éxitos", "96%", Colors.green, appState),
                _statColumn("Completados", "244", Colors.blue, appState),
                _statColumn("Puntos", "+332", Colors.orange, appState),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statColumn(String title, String value, Color color, AppState appState) {
    return Column(
      children: [
        Text(value, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 4),
        Text(title, style: TextStyle(fontSize: 12, color: appState.isDarkMode ? Colors.white70 : Colors.black)),
      ],
    );
  }

  Widget _buildHabitsChart(AppState appState) {
    return Card(
      color: appState.isDarkMode ? Colors.grey[800] : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          // Placeholder para el gráfico (feature que agregaremos próximamente)

          children: [
            Text("Hábitos", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: appState.isDarkMode ? Colors.white : Colors.black)),
            SizedBox(height: 8),
            Container(height: 100, color: appState.isDarkMode ? Colors.grey[700] : Colors.grey[300]),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodCard(AppState appState) {
    return Card(
      color: appState.isDarkMode ? Colors.grey[800] : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(Icons.emoji_emotions, color: Colors.yellow, size: 30),
        title: Text("Alegre", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: appState.isDarkMode ? Colors.white : Colors.black)),
        subtitle: Text("Estado de ánimo", style: TextStyle(color: appState.isDarkMode ? Colors.white70 : Colors.black54)),
      ),
    );
  }
}
