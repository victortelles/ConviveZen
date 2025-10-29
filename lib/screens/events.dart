import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/nav_bar.dart';
import '../providers/app_state.dart';

import 'package:convivezen/screens/profile.dart';
import 'package:convivezen/screens/home.dart';
import 'package:convivezen/screens/qr_scanner.dart';

class ExploreScreen extends StatefulWidget {
  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}



class _ExploreScreenState extends State<ExploreScreen> {
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
          builder: (context) => ProfileScreen(),
        ),
      );
    }else {
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
        title: Text("Explorar eventos"),
        titleTextStyle: TextStyle(
          color: appState.isDarkMode ? Colors.white : Colors.black,
          fontSize: 20,
        ),
        backgroundColor: appState.isDarkMode ? Colors.black : Colors.grey[200],
        iconTheme: IconThemeData(
          color: appState.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      body: Column(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const QrScanner()),
                  );
                },
                icon: const Icon(Icons.camera_alt),
                label: const Text("Escanear QR"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue.shade900,
                ),
              ),
            ),
          ),
          Expanded(
            child: Consumer<AppState>(
              builder: (context, appState, _) {
                final events = appState.eventos;

                if (events.isEmpty) {
                  return const Center(child: Text('No hay eventos agregados.'));
                }

                return ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final e = events[index];
                    return Card(
                      child: ListTile(
                        title: Text(e.summary),
                        subtitle: Text('${e.location} - ${e.start.toLocal()}'),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
