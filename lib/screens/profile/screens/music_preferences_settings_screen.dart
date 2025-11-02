import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../providers/app_state.dart';
import '../../../widgets/onboarding_scaffold.dart';

class MusicPreferencesSettingsScreen extends StatefulWidget {
  @override
  _MusicPreferencesSettingsScreenState createState() => _MusicPreferencesSettingsScreenState();
}

class _MusicPreferencesSettingsScreenState extends State<MusicPreferencesSettingsScreen> {
  List<String> _selectedGenres = [];
  List<Map<String, dynamic>> _filteredGenres = [];
  TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;

  // API completa de géneros musicales (igual que en onboarding)
  final List<Map<String, dynamic>> _allGenres = [
    // Relaxing/Therapeutic genres (prioritized)
    {'name': 'Ambient', 'description': 'Música atmosférica y relajante', 'icon': Icons.cloud, 'color': Colors.blue},
    {'name': 'Clásica', 'description': 'Música clásica tradicional', 'icon': Icons.piano, 'color': Colors.purple},
    {'name': 'Meditación', 'description': 'Música específica para meditar', 'icon': Icons.self_improvement, 'color': Colors.indigo},
    {'name': 'New Age', 'description': 'Música espiritual y tranquila', 'icon': Icons.spa, 'color': Colors.teal},
    {'name': 'Sonidos de la naturaleza', 'description': 'Sonidos del entorno natural', 'icon': Icons.nature, 'color': Colors.green},
    {'name': 'Lo-Fi Hip Hop', 'description': 'Hip hop relajado y atmosférico', 'icon': Icons.headphones, 'color': Colors.orange},
    {'name': 'Instrumental', 'description': 'Música sin vocals', 'icon': Icons.music_note, 'color': Colors.cyan},
    {'name': 'Jazz suave', 'description': 'Jazz melódico y tranquilo', 'icon': Icons.music_video, 'color': Colors.brown},
    {'name': 'Folk acústico', 'description': 'Música folk con instrumentos acústicos', 'icon': Icons.park, 'color': Colors.amber},
    {'name': 'Bossa Nova', 'description': 'Estilo brasileño suave y elegante', 'icon': Icons.beach_access, 'color': Colors.lightBlue},
    {'name': 'Chill-out', 'description': 'Música electrónica relajante', 'icon': Icons.ac_unit, 'color': Colors.lightGreen},
    {'name': 'Downtempo', 'description': 'Electrónica de tempo lento', 'icon': Icons.schedule, 'color': Colors.grey},
    
    // Popular genres
    {'name': 'Pop', 'description': 'Música popular contemporánea', 'icon': Icons.star, 'color': Colors.pink},
    {'name': 'Rock', 'description': 'Rock y sus variantes', 'icon': Icons.music_note, 'color': Colors.red},
    {'name': 'Hip Hop', 'description': 'Rap y hip hop', 'icon': Icons.headphones, 'color': Colors.deepOrange},
    {'name': 'R&B', 'description': 'Rhythm and Blues', 'icon': Icons.favorite, 'color': Colors.purple},
    {'name': 'Country', 'description': 'Música country americana', 'icon': Icons.agriculture, 'color': Colors.brown},
    {'name': 'Reggae', 'description': 'Música jamaicana', 'icon': Icons.waves, 'color': Colors.green},
    {'name': 'Blues', 'description': 'Blues tradicional', 'icon': Icons.mood, 'color': Colors.indigo},
    {'name': 'Soul', 'description': 'Música soul y funk', 'icon': Icons.favorite_border, 'color': Colors.deepPurple},
    
    // Electronic genres
    {'name': 'Electronic', 'description': 'Música electrónica general', 'icon': Icons.electrical_services, 'color': Colors.cyan},
    {'name': 'House', 'description': 'House y deep house', 'icon': Icons.home, 'color': Colors.orange},
    {'name': 'Techno', 'description': 'Techno y minimal', 'icon': Icons.computer, 'color': Colors.blue},
    {'name': 'Trance', 'description': 'Trance y progressive', 'icon': Icons.all_inclusive, 'color': Colors.purple},
    {'name': 'Dubstep', 'description': 'Dubstep y bass music', 'icon': Icons.graphic_eq, 'color': Colors.red},
    
    // World music
    {'name': 'World Music', 'description': 'Música del mundo', 'icon': Icons.public, 'color': Colors.deepOrange},
    {'name': 'Latin', 'description': 'Música latina', 'icon': Icons.celebration, 'color': Colors.red},
    {'name': 'Flamenco', 'description': 'Flamenco español', 'icon': Icons.local_fire_department, 'color': Colors.deepOrange},
    {'name': 'Celtic', 'description': 'Música celta', 'icon': Icons.forest, 'color': Colors.green},
    {'name': 'Indian Classical', 'description': 'Música clásica india', 'icon': Icons.temple_hindu, 'color': Colors.orange},
    {'name': 'African', 'description': 'Música africana tradicional', 'icon': Icons.music_note, 'color': Colors.brown},
    
    // Alternative and Indie
    {'name': 'Alternative', 'description': 'Rock alternativo', 'icon': Icons.alt_route, 'color': Colors.grey},
    {'name': 'Indie', 'description': 'Música independiente', 'icon': Icons.lightbulb, 'color': Colors.yellow},
    {'name': 'Grunge', 'description': 'Grunge de los 90s', 'icon': Icons.brush, 'color': Colors.grey},
    {'name': 'Punk', 'description': 'Punk rock', 'icon': Icons.bolt, 'color': Colors.red},
    
    // Other genres
    {'name': 'Funk', 'description': 'Funk y groove', 'icon': Icons.vibration, 'color': Colors.purple},
    {'name': 'Disco', 'description': 'Disco y dance', 'icon': Icons.nightlife, 'color': Colors.pink},
    {'name': 'Gospel', 'description': 'Música gospel', 'icon': Icons.church, 'color': Colors.blue},
    {'name': 'Opera', 'description': 'Ópera clásica', 'icon': Icons.theater_comedy, 'color': Colors.purple},
    {'name': 'Heavy Metal', 'description': 'Metal y sus subgéneros', 'icon': Icons.hardware, 'color': Colors.grey},
    {'name': 'Progressive Rock', 'description': 'Rock progresivo', 'icon': Icons.trending_up, 'color': Colors.blue},
    
    // Specialized therapeutic
    {'name': 'Frecuencias binaurales', 'description': 'Sonidos terapéuticos específicos', 'icon': Icons.waves, 'color': Colors.deepPurple},
    {'name': 'Música para dormir', 'description': 'Diseñada para facilitar el sueño', 'icon': Icons.bedtime, 'color': Colors.indigo},
    {'name': 'Música para concentrarse', 'description': 'Optimizada para el enfoque', 'icon': Icons.psychology, 'color': Colors.teal},
    {'name': 'Cantos gregorianos', 'description': 'Música sacra medieval', 'icon': Icons.church, 'color': Colors.brown},
  ];

  @override
  void initState() {
    super.initState();
    _filteredGenres = List.from(_allGenres);
    _searchController.addListener(_filterGenres);
    _loadCurrentMusicGenres();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterGenres() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredGenres = List.from(_allGenres);
      } else {
        _filteredGenres = _allGenres
            .where((genre) => genre['name'].toLowerCase().contains(query))
            .toList();
      }
    });
  }

  void _loadCurrentMusicGenres() async {
    final appState = Provider.of<AppState>(context, listen: false);
    
    setState(() {
      _isLoading = true;
    });

    try {
      final preferences = await appState.getUserPreferences();
      setState(() {
        _selectedGenres = List<String>.from(preferences.musicGenres);
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading music preferences: $e');
      setState(() {
        _selectedGenres = [];
        _isLoading = false;
      });
    }
  }

  void _toggleMusicGenre(String genreName) {
    setState(() {
      if (_selectedGenres.contains(genreName)) {
        _selectedGenres.remove(genreName);
      } else {
        _selectedGenres.add(genreName);
      }
    });
  }

  Future<void> _saveMusicGenres() async {
    try {
      final appState = Provider.of<AppState>(context, listen: false);
      await appState.updateMusicGenres(_selectedGenres);
      
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Géneros musicales actualizados correctamente')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange.shade50,
      appBar: AppBar(
        title: Text('Música que me Calma'),
        backgroundColor: Colors.orange.shade50,
        foregroundColor: Colors.orange.shade700,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _selectedGenres.isNotEmpty ? _saveMusicGenres : null,
            child: Text(
              _selectedGenres.isEmpty 
                ? 'Guardar' 
                : 'Guardar (${_selectedGenres.length})',
              style: TextStyle(
                color: _selectedGenres.isNotEmpty ? Colors.orange.shade700 : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: _isLoading 
        ? Center(child: CircularProgressIndicator())
        : Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '¿Qué tipo de música te relaja?',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade700,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Busca y selecciona los géneros musicales que más te ayudan a relajarte',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(height: 24),

              // Search bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.shade100.withOpacity(0.3),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Buscar géneros musicales...',
                    prefixIcon: Icon(Icons.search, color: Colors.orange.shade400),
                    suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear, color: Colors.orange.shade300),
                          onPressed: () {
                            _searchController.clear();
                            _filterGenres();
                          },
                        )
                      : null,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    hintStyle: TextStyle(color: Colors.orange.shade300),
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Selected count and filters
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.orange.shade200),
                    ),
                    child: Text(
                      'Seleccionados: ${_selectedGenres.length}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.orange.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Text(
                      '${_filteredGenres.length} géneros',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Genres list
              Expanded(
                child: ListView.builder(
                  itemCount: _filteredGenres.length,
                  itemBuilder: (context, index) {
                    final genre = _filteredGenres[index];
                    final isSelected = _selectedGenres.contains(genre['name']);
                    
                    return OnboardingListItem(
                      icon: genre['icon'],
                      title: genre['name'],
                      description: genre['description'],
                      isSelected: isSelected,
                      onTap: () => _toggleMusicGenre(genre['name']),
                      primaryColor: Colors.orange,
                      iconColor: genre['color'],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
    );
  }
}