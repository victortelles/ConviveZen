import 'package:flutter/material.dart';

// Widget de card para mostrar genero musical
class MusicGenreCard extends StatelessWidget {
  final String genre;
  final bool isSelected;
  final VoidCallback onTap;

  const MusicGenreCard({
    Key? key,
    required this.genre,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  // Obtener icono segun genero
  IconData _getGenreIcon() {
    switch (genre.toLowerCase()) {
      case 'pop':
        return Icons.stars;
      case 'rock':
        return Icons.music_note;
      case 'jazz':
        return Icons.piano;
      case 'classical':
        return Icons.music_note;
      case 'electronic':
        return Icons.graphic_eq;
      case 'reggae':
        return Icons.waves;
      case 'indie':
        return Icons.album;
      case 'r&b':
        return Icons.favorite;
      case 'hip-hop':
        return Icons.headphones;
      case 'latin':
        return Icons.celebration;
      case 'country':
        return Icons.landscape;
      case 'folk':
        return Icons.nature_people;
      case 'blues':
        return Icons.nights_stay;
      case 'metal':
        return Icons.bolt;
      case 'ambient':
        return Icons.cloud;
      case 'lofi':
        return Icons.nightlight;
      default:
        return Icons.music_note;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: isSelected ? 8 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isSelected ? Colors.pink.shade400 : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: isSelected
                ? LinearGradient(
                    colors: [
                      Colors.pink.shade100,
                      Colors.pink.shade50,
                    ],
                  )
                : null,
          ),
          child: Row(
            children: [
              // Icono del genero
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.pink.shade300
                      : Colors.pink.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getGenreIcon(),
                  color: Colors.white,
                  size: 28,
                ),
              ),
              SizedBox(width: 16),
              
              // Nombre del genero
              Expanded(
                child: Text(
                  '${genre[0].toUpperCase()}${genre.substring(1)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected
                        ? Colors.pink.shade700
                        : Colors.grey.shade800,
                  ),
                ),
              ),
              
              // Indicador de seleccion
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: Colors.pink.shade600,
                  size: 28,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
