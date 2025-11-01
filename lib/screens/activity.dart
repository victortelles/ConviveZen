import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../widgets/nav_bar.dart';
import '../providers/app_state.dart';

import 'package:convivezen/screens/profile/profile.dart';
import 'package:convivezen/screens/home/home.dart';

class ActivityScreen extends StatefulWidget {
  @override
  _ActivityScreenState createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen> {
  int _selectedIndex = 3;

  void _onItemTapped(int index) {
    // var appState = Provider.of<AppState>(context, listen: false);

    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else if (index == 1) {
      _showAlert("Función de comunidad temporalmente deshabilitada");
    } else if (index == 2) {
      _showAlert("Función de explorar temporalmente deshabilitada");
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
            Row(
              children: [
                Icon(Icons.analytics_outlined, color: Colors.blue.shade700),
                SizedBox(width: 8),
                Text("Estadísticas de Crisis", 
                    style: GoogleFonts.poppins(
                        fontSize: 16, fontWeight: FontWeight.bold, color: appState.isDarkMode ? Colors.white : Colors.black)),
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange.shade300),
                  ),
                  child: Text(
                    'PREMIUM',
                    style: TextStyle(
                      color: Colors.orange.shade700,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              "Accede a estadísticas detalladas de tus crisis de ansiedad, patrones y mejoras con la suscripción Premium",
              style: TextStyle(
                fontSize: 14,
                color: appState.isDarkMode ? Colors.white70 : Colors.black54,
              ),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _statColumn("Crisis/Mes", "--", Colors.blue, appState),
                _statColumn("Mejora", "--", Colors.green, appState),
                _statColumn("Duración Prom", "--", Colors.orange, appState),
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
          children: [
            Row(
              children: [
                Icon(Icons.trending_up, color: Colors.blue.shade700),
                SizedBox(width: 8),
                Text("Análisis de Progreso", 
                    style: GoogleFonts.poppins(
                        fontSize: 16, fontWeight: FontWeight.bold, color: appState.isDarkMode ? Colors.white : Colors.black)),
                Spacer(),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.orange.shade300),
                  ),
                  child: Text(
                    'PREMIUM',
                    style: TextStyle(
                      color: Colors.orange.shade700,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: appState.isDarkMode ? Colors.grey[700] : Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.orange.shade300.withOpacity(0.3),
                  style: BorderStyle.solid,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lock_outline, 
                        color: Colors.orange.shade600, size: 30),
                    SizedBox(height: 4),
                    Text(
                      "Gráficos Premium",
                      style: TextStyle(
                        color: appState.isDarkMode ? Colors.white70 : Colors.black54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
        leading: Icon(Icons.psychology, color: Colors.blue.shade600, size: 30),
        title: Row(
          children: [
            Text("Estado Emocional", 
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.bold, color: appState.isDarkMode ? Colors.white : Colors.black)),
            Spacer(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'GRATIS',
                style: TextStyle(
                  color: Colors.green.shade700,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        subtitle: Text("Registra tu estado emocional diariamente", 
            style: TextStyle(color: appState.isDarkMode ? Colors.white70 : Colors.black54)),
        onTap: () {
          _showAlert("Registro de estado emocional - próximamente disponible");
        },
      ),
    );
  }
}
