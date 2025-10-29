import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
//Provider
import 'package:provider/provider.dart';
import '../widgets/nav_bar.dart';
import '../providers/app_state.dart';
//Widget
import '../widgets/home_header.dart';
import '../widgets/horizontal_date_selector.dart';
import '../widgets/habits_progress_card.dart';
//import '../widgets/community_card.dart';
import '../widgets/habits_list.dart';
//Screens
import 'package:convivezen/screens/profile.dart';
import 'package:convivezen/screens/activity.dart';
//import 'package:convivezen/screens/community.dart';
import 'package:convivezen/screens/events.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    var appState = Provider.of<AppState>(context, listen: false);

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ExploreScreen(),
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
        title: Text("Habit Hub"),
        titleTextStyle: TextStyle(
            color: appState.isDarkMode ? Colors.white : Colors.black,
            fontSize: 20),
        backgroundColor: appState.isDarkMode ? Colors.black : Colors.grey[200],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Widget de HomeHeader
              HomeHeader(appState: appState),
              SizedBox(height: 16),
              //Widget de HorizontalDate
              HorizontalDateSelector(appState: appState),
              SizedBox(height: 16),
              //Widget de HabitProgressCard
              HabitsProgressCard(appState: appState),
              SizedBox(height: 16),
              //Widget de Community
              //CommunityCard(),
              SizedBox(height: 16),
              Text("Tus hábitos",
                  style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color:
                          appState.isDarkMode ? Colors.white : Colors.black)),
              Expanded(
                //Widget de HabitList
                child: HabitsList()),
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
}
