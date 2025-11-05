import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/app_state.dart';
import '../../services/music_service.dart';
import '../../models/user_preferences.dart';
import 'widgets/music_genre_card.dart';
import 'widgets/music_loading_overlay.dart';

// Pantalla principal de seleccion de musica de emergencia
class MusicScreen extends StatefulWidget {
  @override
  _MusicScreenState createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  bool _isLoading = false;
  String? _selectedGenre;
  bool _autoLaunched = false;

  // Abrir app de musica con genero seleccionado
  Future<void> _openMusicApp(String genre) async {
    print('=== Abriendo app de musica ===');
    print('Genero: $genre');
    
    setState(() {
      _isLoading = true;
    });

    final success = await MusicService.openMusicAppWithGenre(genre);
    
    print('Resultado: ${success ? "EXITO" : "FALLO"}');

    setState(() {
      _isLoading = false;
    });

    if (!success) {
      print('Mostrando dialogo de error');
      _showNoMusicAppDialog();
    } else {
      print('Cerrando pantalla de musica');
      // Cerrar la pantalla despues de abrir la app
      if (mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  // Mostrar dialogo cuando no hay apps de musica instaladas
  void _showNoMusicAppDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('No se encontró app de música'),
        content: Text(
          'No se pudo abrir ninguna aplicación de música. Por favor, instala Spotify, YouTube Music o Apple Music.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Entendido'),
          ),
        ],
      ),
    );
  }

  // Auto-lanzar musica cuando se carga la pantalla
  Future<void> _autoLaunchMusic(UserPreferences preferences) async {
    print('=== Auto-launch Music Debug ===');
    print('_autoLaunched: $_autoLaunched');
    print('musicGenres: ${preferences.musicGenres}');
    print('musicGenres.length: ${preferences.musicGenres.length}');
    
    if (!_autoLaunched && preferences.musicGenres.isNotEmpty) {
      _autoLaunched = true;
      _selectedGenre = preferences.musicGenres.first;
      print('Genero seleccionado: $_selectedGenre');
      
      // Esperar un momento antes de abrir
      await Future.delayed(Duration(milliseconds: 500));
      await _openMusicApp(_selectedGenre!);
    } else {
      print('No se auto-lanzo: _autoLaunched=$_autoLaunched, isEmpty=${preferences.musicGenres.isEmpty}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      appBar: AppBar(
        title: Text('Música de Contención'),
        backgroundColor: Colors.pink.shade100,
        elevation: 0,
      ),
      body: FutureBuilder<UserPreferences>(
        future: appState.getUserPreferences(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.pink.shade400),
              ),
            );
          }

          final preferences = snapshot.data ?? UserPreferences();

          // Auto-lanzar musica al cargar
          if (!_autoLaunched) {
            Future.microtask(() => _autoLaunchMusic(preferences));
          }

          return Stack(
            children: [
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header con icono
                      Icon(
                        Icons.music_note,
                        size: 80,
                        color: Colors.pink.shade400,
                      ),
                      SizedBox(height: 20),

                      // Titulo
                      Text(
                        'Abriendo música relajante',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.pink.shade700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10),
                      
                      // Debug info
                      if (preferences.musicGenres.isNotEmpty)
                        Text(
                          'Debug: ${preferences.musicGenres.length} géneros en Firebase',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),

                      // Subtitulo con genero seleccionado
                      if (_selectedGenre != null)
                        Text(
                          'Género: ${_selectedGenre![0].toUpperCase()}${_selectedGenre!.substring(1)}',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.pink.shade600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      SizedBox(height: 30),

                      // Lista de generos disponibles
                      if (preferences.musicGenres.isNotEmpty)
                        Expanded(
                          child: ListView.builder(
                            itemCount: preferences.musicGenres.length,
                            itemBuilder: (context, index) {
                              final genre = preferences.musicGenres[index];
                              return MusicGenreCard(
                                genre: genre,
                                isSelected: genre == _selectedGenre,
                                onTap: () {
                                  setState(() {
                                    _selectedGenre = genre;
                                  });
                                  _openMusicApp(genre);
                                },
                              );
                            },
                          ),
                        )
                      else
                        Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.music_off,
                                  size: 60,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 20),
                                Text(
                                  'No has configurado géneros musicales',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade600,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Ve a tu perfil para configurarlos',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey.shade500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),

                      // Boton de cancelar
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade300,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Cancelar',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Loading overlay
              if (_isLoading) MusicLoadingOverlay(),
            ],
          );
        },
      ),
    );
  }
}
