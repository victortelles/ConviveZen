import 'package:flutter/material.dart';

class MusicPreferencesScreen extends StatefulWidget {
  final Function(List<String>) onMusicSelected;

  const MusicPreferencesScreen({Key? key, required this.onMusicSelected}) : super(key: key);

  @override
  _MusicPreferencesScreenState createState() => _MusicPreferencesScreenState();
}

class _MusicPreferencesScreenState extends State<MusicPreferencesScreen> {
  List<String> _selectedGenres = [];

  final List<Map<String, dynamic>> _musicGenres = [
    {'key': 'classical', 'title': 'Clásica', 'icon': Icons.piano, 'color': Colors.purple},
    {'key': 'ambient', 'title': 'Ambiente/Chill', 'icon': Icons.cloud, 'color': Colors.blue},
    {'key': 'nature', 'title': 'Sonidos de la naturaleza', 'icon': Icons.nature, 'color': Colors.green},
    {'key': 'meditation', 'title': 'Meditación', 'icon': Icons.self_improvement, 'color': Colors.indigo},
    {'key': 'lo_fi', 'title': 'Lo-Fi Hip Hop', 'icon': Icons.headphones, 'color': Colors.orange},
    {'key': 'instrumental', 'title': 'Instrumental', 'icon': Icons.music_note, 'color': Colors.teal},
    {'key': 'pop', 'title': 'Pop suave', 'icon': Icons.star, 'color': Colors.pink},
    {'key': 'jazz', 'title': 'Jazz suave', 'icon': Icons.music_video, 'color': Colors.brown},
    {'key': 'folk', 'title': 'Folk acústico', 'icon': Icons.park, 'color': Colors.amber},
    {'key': 'electronic', 'title': 'Electrónica suave', 'icon': Icons.electrical_services, 'color': Colors.cyan},
    {'key': 'world', 'title': 'Música del mundo', 'icon': Icons.public, 'color': Colors.deepOrange},
    {'key': 'binaural', 'title': 'Frecuencias binaurales', 'icon': Icons.waves, 'color': Colors.deepPurple},
  ];

  void _toggleGenre(String genreKey) {
    setState(() {
      if (_selectedGenres.contains(genreKey)) {
        _selectedGenres.remove(genreKey);
      } else {
        _selectedGenres.add(genreKey);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Text(
            '¿Qué tipo de música te relaja?',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.pink.shade700,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Text(
            'Selecciona los géneros musicales que más te ayudan a relajarte y reducir la ansiedad',
            style: TextStyle(
              fontSize: 16,
              color: Colors.pink.shade600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          Text(
            'Géneros seleccionados: ${_selectedGenres.length}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.pink.shade500,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.2,
              ),
              itemCount: _musicGenres.length,
              itemBuilder: (context, index) {
                final genre = _musicGenres[index];
                final isSelected = _selectedGenres.contains(genre['key']);
                
                return GestureDetector(
                  onTap: () => _toggleGenre(genre['key']),
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.pink.shade100 : Colors.white,
                      border: Border.all(
                        color: isSelected ? Colors.pink.shade400 : Colors.pink.shade200,
                        width: isSelected ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.pink.shade100,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.pink.shade400 : genre['color'].withOpacity(0.7),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Icon(
                            genre['icon'],
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          genre['title'],
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.pink.shade700,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (isSelected) ...[
                          SizedBox(height: 8),
                          Icon(
                            Icons.check_circle,
                            color: Colors.pink.shade400,
                            size: 16,
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: () => widget.onMusicSelected(_selectedGenres),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink.shade400,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 3,
              ),
              child: Text(
                _selectedGenres.isEmpty ? 'Omitir' : 'Continuar',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}