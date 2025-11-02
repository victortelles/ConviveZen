import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/onboarding_state.dart';

class OnboardingScaffold extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;
  final String? buttonText;
  final VoidCallback? onContinue;
  final bool isValid;

  const OnboardingScaffold({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.child,
    this.buttonText,
    this.onContinue,
    this.isValid = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<OnboardingState>(
      builder: (context, onboardingState, _) {
        return Scaffold(
          backgroundColor: Colors.pink.shade50,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Back button and progress bar
                  Row(
                    children: [
                      if (onboardingState.canGoBack)
                        IconButton(
                          onPressed: () => onboardingState.previousStep(),
                          icon: Icon(Icons.arrow_back, color: Colors.pink.shade700),
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: EdgeInsets.all(8),
                          ),
                        ),
                      if (onboardingState.canGoBack) SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          children: [
                            LinearProgressIndicator(
                              value: onboardingState.progress,
                              backgroundColor: Colors.pink.shade100,
                              valueColor: AlwaysStoppedAnimation(Colors.pink.shade400),
                              minHeight: 8,
                            ),
                            SizedBox(height: 8),
                            Text(
                              '${onboardingState.currentStep + 1}/${onboardingState.totalSteps}',
                              style: TextStyle(
                                color: Colors.pink.shade700,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  
                  // Main content
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.pink.shade700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 16),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.pink.shade600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 30),
                        Expanded(child: child),
                        SizedBox(height: 20),
                        
                        // Continue button
                        if (buttonText != null)
                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              onPressed: isValid ? onContinue : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isValid ? Colors.pink.shade400 : Colors.grey.shade300,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                elevation: 3,
                              ),
                              child: Text(
                                buttonText!,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// Widget común para listas de selección múltiple
class OnboardingListItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? description;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? primaryColor; // Color principal para personalización
  final Color? iconColor; // Color específico del icono

  const OnboardingListItem({
    Key? key,
    required this.icon,
    required this.title,
    this.description,
    required this.isSelected,
    required this.onTap,
    this.primaryColor,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Usar colores personalizados o defaults
    final MaterialColor mainColor = primaryColor is MaterialColor 
        ? primaryColor as MaterialColor 
        : Colors.pink;
    final Color itemIconColor = iconColor ?? mainColor;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected ? mainColor.shade100 : Colors.white,
            border: Border.all(
              color: isSelected ? mainColor.shade300 : Colors.grey.shade300,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: isSelected ? mainColor.shade200.withOpacity(0.3) : Colors.grey.shade200,
                blurRadius: isSelected ? 6 : 4,
                offset: Offset(0, isSelected ? 3 : 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected ? itemIconColor : itemIconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: isSelected ? Colors.white : itemIconColor,
                  size: 24,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: mainColor.shade700,
                      ),
                    ),
                    if (description != null) ...[
                      SizedBox(height: 4),
                      Text(
                        description!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600, // Texto descripción en gris
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: mainColor.shade500,
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }
}