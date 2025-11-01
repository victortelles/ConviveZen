import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../models/user.dart';
import '../../models/user_preferences.dart';
import 'age_selection_screen.dart';
import 'anxiety_type_screen.dart';
import 'personality_screen.dart';
import 'hobbies_screen.dart';
import 'triggers_screen.dart';
import 'music_preferences_screen.dart';
import 'help_style_screen.dart';

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({Key? key}) : super(key: key);

  @override
  _OnboardingFlowState createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  PageController _pageController = PageController();
  int _currentPage = 0;

  // Temporary data storage during onboarding
  int? _age;
  String? _anxietyType;
  String? _personalityType;
  List<String> _hobbies = [];
  List<String> _triggers = [];
  List<String> _musicGenres = [];
  String? _helpStyle;

  void _nextPage() {
    if (_currentPage < 6) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _completeOnboarding() async {
    final appState = Provider.of<AppState>(context, listen: false);
    final currentUserProfile = appState.userProfile!;

    // Update user data
    final updatedUser = UserModel(
      uid: currentUserProfile.uid,
      email: currentUserProfile.email,
      name: currentUserProfile.name,
      profilePic: currentUserProfile.profilePic,
      authProvider: currentUserProfile.authProvider,
      age: _age!,
      anxietyType: _anxietyType!,
      personalityType: _personalityType!,
      triggers: _triggers,
      createdAt: currentUserProfile.createdAt,
    );

    // Create user preferences
    final preferences = UserPreferences(
      hobbies: _hobbies,
      musicGenres: _musicGenres,
      gameTypes: ['puzzle', 'relaxing'],
      personalAffirmations: [],
      favoriteQuotes: [],
      preferredTone: 'calming',
      favoriteTools: ['breathing', 'meditation', 'music', 'games', 'chat', 'contacts'],
      primaryTool: 'breathing',
      enableAIChat: true,
      autoContactEmergency: false,
      helpStyle: _helpStyle!,
      preferVisual: true,
      preferAudio: true,
      enableNotifications: false,
      sessionDuration: 10,
      lastUpdated: DateTime.now(),
      isOnboardingComplete: true,
    );

    try {
      await appState.saveUserToFirestore(updatedUser);
      await appState.saveUserPreferencesToFirestore(preferences);
      
      Navigator.of(context).pushReplacementNamed('/home');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar datos: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      body: Stack(
        children: [
          // Background with logo
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/logo_background.png'),
                fit: BoxFit.cover,
                opacity: 0.1,
              ),
            ),
          ),
          // Main content
          PageView(
            controller: _pageController,
            onPageChanged: (page) {
              setState(() {
                _currentPage = page;
              });
            },
            children: [
              AgeSelectionScreen(
                onAgeSelected: (age) {
                  _age = age;
                  _nextPage();
                },
              ),
              AnxietyTypeScreen(
                onAnxietyTypeSelected: (type) {
                  _anxietyType = type;
                  _nextPage();
                },
              ),
              PersonalityScreen(
                onPersonalitySelected: (type) {
                  _personalityType = type;
                  _nextPage();
                },
              ),
              HobbiesScreen(
                onHobbiesSelected: (hobbies) {
                  _hobbies = hobbies;
                  _nextPage();
                },
              ),
              TriggersScreen(
                onTriggersSelected: (triggers) {
                  _triggers = triggers;
                  _nextPage();
                },
              ),
              MusicPreferencesScreen(
                onMusicSelected: (genres) {
                  _musicGenres = genres;
                  _nextPage();
                },
              ),
              HelpStyleScreen(
                onHelpStyleSelected: (style) {
                  _helpStyle = style;
                  _nextPage();
                },
              ),
            ],
          ),
          // Progress indicator
          Positioned(
            top: 60,
            left: 20,
            right: 20,
            child: Row(
              children: [
                if (_currentPage > 0)
                  IconButton(
                    onPressed: _previousPage,
                    icon: Icon(Icons.arrow_back, color: Colors.pink.shade700),
                  ),
                Expanded(
                  child: LinearProgressIndicator(
                    value: (_currentPage + 1) / 7,
                    backgroundColor: Colors.pink.shade100,
                    valueColor: AlwaysStoppedAnimation(Colors.pink.shade400),
                  ),
                ),
                Text(
                  '${_currentPage + 1}/7',
                  style: TextStyle(
                    color: Colors.pink.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}