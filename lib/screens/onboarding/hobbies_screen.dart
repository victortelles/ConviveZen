import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/onboarding_state.dart';
import '../../widgets/onboarding_scaffold.dart';

class HobbiesScreen extends StatefulWidget {
  const HobbiesScreen({Key? key}) : super(key: key);

  @override
  _HobbiesScreenState createState() => _HobbiesScreenState();
}

class _HobbiesScreenState extends State<HobbiesScreen> {
  final List<Map<String, dynamic>> _hobbies = [
    {'key': 'reading', 'title': 'Lectura', 'description': 'Leer libros, revistas y artículos', 'icon': Icons.book},
    {'key': 'music', 'title': 'Música', 'description': 'Escuchar o crear música', 'icon': Icons.music_note},
    {'key': 'sports', 'title': 'Deportes', 'description': 'Actividades físicas y ejercicio', 'icon': Icons.sports_soccer},
    {'key': 'art', 'title': 'Arte y Dibujo', 'description': 'Expresión artística y creativa', 'icon': Icons.palette},
    {'key': 'cooking', 'title': 'Cocinar', 'description': 'Preparar comidas y experimentar con recetas', 'icon': Icons.restaurant},
    {'key': 'gaming', 'title': 'Videojuegos', 'description': 'Juegos digitales y entretenimiento', 'icon': Icons.sports_esports},
    {'key': 'nature', 'title': 'Naturaleza', 'description': 'Actividades al aire libre', 'icon': Icons.nature},
    {'key': 'photography', 'title': 'Fotografía', 'description': 'Capturar momentos y paisajes', 'icon': Icons.camera_alt},
    {'key': 'dancing', 'title': 'Bailar', 'description': 'Expresión corporal y movimiento', 'icon': Icons.music_video},
    {'key': 'writing', 'title': 'Escribir', 'description': 'Crear textos, historias o diarios', 'icon': Icons.edit},
    {'key': 'travel', 'title': 'Viajar', 'description': 'Explorar nuevos lugares', 'icon': Icons.flight},
    {'key': 'crafts', 'title': 'Manualidades', 'description': 'Crear objetos con las manos', 'icon': Icons.handyman},
    {'key': 'movies', 'title': 'Películas/Series', 'description': 'Entretenimiento audiovisual', 'icon': Icons.movie},
    {'key': 'meditation', 'title': 'Meditación', 'description': 'Prácticas de mindfulness y relajación', 'icon': Icons.self_improvement},
    {'key': 'socializing', 'title': 'Socializar', 'description': 'Pasar tiempo con amigos y familia', 'icon': Icons.people},
    {'key': 'learning', 'title': 'Aprender cosas nuevas', 'description': 'Cursos, talleres y educación continua', 'icon': Icons.school},
  ];

  void _toggleHobby(String hobbyKey) {
    final onboardingState = Provider.of<OnboardingState>(context, listen: false);
    List<String> currentHobbies = List.from(onboardingState.hobbies);
    
    if (currentHobbies.contains(hobbyKey)) {
      currentHobbies.remove(hobbyKey);
    } else {
      currentHobbies.add(hobbyKey);
    }
    
    onboardingState.setHobbies(currentHobbies);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OnboardingState>(
      builder: (context, onboardingState, _) {
        return OnboardingScaffold(
          title: '¿Cuáles son tus hobbies o intereses?',
          subtitle: 'Selecciona todas las actividades que disfrutas. Esto nos ayuda a personalizar tus herramientas de relajación',
          buttonText: onboardingState.hobbies.isNotEmpty 
            ? 'Continuar (${onboardingState.hobbies.length} seleccionado${onboardingState.hobbies.length > 1 ? 's' : ''})'
            : 'Selecciona al menos uno',
          isValid: onboardingState.hobbies.isNotEmpty,
          onContinue: () => onboardingState.nextStep(),
          child: Column(
            children: [
              // Selected count
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.pink.shade50,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.pink.shade200),
                ),
                child: Text(
                  'Seleccionados: ${onboardingState.hobbies.length}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.pink.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 20),
              
              // Hobbies list
              Expanded(
                child: ListView.builder(
                  itemCount: _hobbies.length,
                  itemBuilder: (context, index) {
                    final hobby = _hobbies[index];
                    final isSelected = onboardingState.hobbies.contains(hobby['key']);
                    
                    return OnboardingListItem(
                      icon: hobby['icon'],
                      title: hobby['title'],
                      description: hobby['description'],
                      isSelected: isSelected,
                      onTap: () => _toggleHobby(hobby['key']),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}