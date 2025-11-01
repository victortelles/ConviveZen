import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../models/user_preferences.dart';
import '../../models/onboarding_state.dart';
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
  late OnboardingState _onboardingState;

  @override
  void initState() {
    super.initState();
    _onboardingState = OnboardingState();
    _onboardingState.addListener(_onOnboardingStateChanged);
  }

  @override
  void dispose() {
    _onboardingState.removeListener(_onOnboardingStateChanged);
    _onboardingState.dispose();
    super.dispose();
  }

  void _onOnboardingStateChanged() {
    if (_onboardingState.currentStep >= _onboardingState.totalSteps) {
      _completeOnboarding();
    }
    setState(() {});
  }

  Future<void> _completeOnboarding() async {
    print('DEBUG: Starting onboarding completion');
    final appState = Provider.of<AppState>(context, listen: false);
    final currentUserProfile = appState.userProfile!;

    print('DEBUG: Current user profile: ${currentUserProfile.email}, isFirstTime: ${currentUserProfile.isFirstTime}');

    // Update user data using copyWith to preserve existing data and only update what was collected
    final updatedUser = currentUserProfile.copyWith(
      anxietyTypes: _onboardingState.anxietyTypes,
      personalityType: _onboardingState.personalityType!,
      triggers: _onboardingState.triggers,
      isFirstTime: false, // Mark onboarding as complete
    );

    print('DEBUG: Updated user isFirstTime: ${updatedUser.isFirstTime}');

    // Create user preferences
    final preferences = UserPreferences(
      hobbies: _onboardingState.hobbies,
      musicGenres: _onboardingState.musicGenres,
      gameTypes: ['puzzle', 'relaxing'],
      personalAffirmations: [],
      favoriteQuotes: [],
      preferredTone: 'calming',
      favoriteTools: ['breathing', 'meditation', 'music', 'games', 'chat', 'contacts'],
      primaryTool: 'breathing',
      enableAIChat: true,
      autoContactEmergency: false,
      helpStyle: _onboardingState.helpStyle!,
      preferVisual: true,
      preferAudio: true,
      enableNotifications: false,
      sessionDuration: 10,
      lastUpdated: DateTime.now(),
      isOnboardingComplete: true,
    );

    try {
      print('DEBUG: Saving updated user to Firestore');
      await appState.saveUserToFirestore(updatedUser);
      await appState.saveUserPreferencesToFirestore(preferences);
      
      print('DEBUG: Onboarding completed successfully, navigating to home');
      Navigator.of(context).pushReplacementNamed('/home');
    } catch (e) {
      print('DEBUG: Error completing onboarding: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al guardar datos: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _onboardingState,
      child: Scaffold(
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
            // Main content - single screen based on current step
            Consumer<OnboardingState>(
              builder: (context, onboardingState, _) {
                switch (onboardingState.currentStep) {
                  case 0:
                    return AnxietyTypeScreen();
                  case 1:
                    return PersonalityScreen();
                  case 2:
                    return HobbiesScreen();
                  case 3:
                    return TriggersScreen();
                  case 4:
                    return MusicPreferencesScreen();
                  case 5:
                    return HelpStyleScreen();
                  default:
                    return AnxietyTypeScreen();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}