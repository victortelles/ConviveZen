import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

// Enum para tipos de apps de musica
enum MusicApp {
  spotify,
  youtubeMusic,
  appleMusic,
  none,
}

// Servicio para gestionar la apertura de apps de musica externas
class MusicService {
  // Mapeo de generos musicales a terminos de busqueda
  static const Map<String, String> _genreSearchTerms = {
    'pop': 'pop relaxing',
    'rock': 'rock calming',
    'jazz': 'jazz relaxing',
    'classical': 'classical relaxing',
    'electronic': 'electronic chill',
    'reggae': 'reggae peaceful',
    'indie': 'indie calming',
    'r&b': 'r&b smooth',
    'hip-hop': 'hip-hop chill',
    'latin': 'latin relaxing',
    'country': 'country peaceful',
    'folk': 'folk calming',
    'blues': 'blues relaxing',
    'metal': 'metal instrumental',
    'ambient': 'ambient meditation',
    'lofi': 'lofi chill beats',
  };

  // Detectar y abrir app de musica segun genero
  static Future<bool> openMusicAppWithGenre(String genre) async {
    print('=== MusicService.openMusicAppWithGenre ===');
    print('Genero recibido: $genre');
    
    final searchTerm = _genreSearchTerms[genre.toLowerCase()] ?? '$genre relaxing';
    print('Termino de busqueda: $searchTerm');
    print('Plataforma: ${Platform.isAndroid ? "Android" : Platform.isIOS ? "iOS" : "Otra"}');
    
    // Intentar abrir apps en orden de prioridad
    if (Platform.isAndroid) {
      print('Probando apps en Android...');
      // Prioridad en Android: Spotify > YouTube Music > Apple Music
      if (await _openSpotify(searchTerm)) {
        print('Exito con Spotify');
        return true;
      }
      print('Spotify no funciono, probando YouTube Music...');
      if (await _openYouTubeMusic(searchTerm)) {
        print('Exito con YouTube Music');
        return true;
      }
      print('YouTube Music no funciono, probando Apple Music...');
      if (await _openAppleMusic(searchTerm)) {
        print('Exito con Apple Music');
        return true;
      }
      print('Ninguna app de musica funciono');
    } else if (Platform.isIOS) {
      print('Probando apps en iOS...');
      // Prioridad en iOS: Apple Music > Spotify > YouTube Music
      if (await _openAppleMusic(searchTerm)) return true;
      if (await _openSpotify(searchTerm)) return true;
      if (await _openYouTubeMusic(searchTerm)) return true;
    }
    
    return false;
  }

  // Abrir Spotify con busqueda de genero
  static Future<bool> _openSpotify(String searchTerm) async {
    try {
      print('Intentando abrir Spotify con termino: $searchTerm');
      
      // Intentar URL scheme de Spotify primero (funciona mejor en apps instaladas)
      final spotifyUrl = Uri.parse('spotify:search:$searchTerm');
      
      try {
        final launched = await launchUrl(
          spotifyUrl,
          mode: LaunchMode.externalApplication,
        );
        if (launched) {
          print('Spotify abierto exitosamente con URL scheme');
          return true;
        }
      } catch (e) {
        print('Error con URL scheme de Spotify: $e');
      }
      
      // Fallback a URL web de Spotify
      print('Intentando abrir Spotify via web URL');
      final webUrl = Uri.parse('https://open.spotify.com/search/${Uri.encodeComponent(searchTerm)}');
      
      try {
        final launched = await launchUrl(
          webUrl,
          mode: LaunchMode.externalApplication,
        );
        if (launched) {
          print('Spotify abierto exitosamente via web URL');
          return true;
        }
      } catch (e) {
        print('Error con web URL de Spotify: $e');
      }
    } catch (e) {
      print('Error general opening Spotify: $e');
    }
    return false;
  }

  // Abrir YouTube Music con busqueda de genero
  static Future<bool> _openYouTubeMusic(String searchTerm) async {
    try {
      print('Intentando abrir YouTube Music con termino: $searchTerm');
      
      // URL de YouTube Music
      final youtubeUrl = Uri.parse('https://music.youtube.com/search?q=${Uri.encodeComponent(searchTerm)}');
      
      try {
        final launched = await launchUrl(
          youtubeUrl,
          mode: LaunchMode.externalApplication,
        );
        if (launched) {
          print('YouTube Music abierto exitosamente');
          return true;
        }
      } catch (e) {
        print('Error con YouTube Music: $e');
      }
    } catch (e) {
      print('Error general opening YouTube Music: $e');
    }
    return false;
  }

  // Abrir Apple Music con busqueda de genero
  static Future<bool> _openAppleMusic(String searchTerm) async {
    try {
      print('Intentando abrir Apple Music con termino: $searchTerm');
      
      // URL scheme de Apple Music
      final appleMusicUrl = Uri.parse('music://music.apple.com/search?term=${Uri.encodeComponent(searchTerm)}');
      
      try {
        final launched = await launchUrl(
          appleMusicUrl,
          mode: LaunchMode.externalApplication,
        );
        if (launched) {
          print('Apple Music abierto exitosamente con URL scheme');
          return true;
        }
      } catch (e) {
        print('Error con URL scheme de Apple Music: $e');
      }
      
      // Fallback a URL web de Apple Music
      print('Intentando abrir Apple Music via web URL');
      final webUrl = Uri.parse('https://music.apple.com/search?term=${Uri.encodeComponent(searchTerm)}');
      
      try {
        final launched = await launchUrl(
          webUrl,
          mode: LaunchMode.externalApplication,
        );
        if (launched) {
          print('Apple Music abierto exitosamente via web URL');
          return true;
        }
      } catch (e) {
        print('Error con web URL de Apple Music: $e');
      }
    } catch (e) {
      print('Error general opening Apple Music: $e');
    }
    return false;
  }

  // Obtener nombre amigable de app de musica
  static String getMusicAppName(MusicApp app) {
    switch (app) {
      case MusicApp.spotify:
        return 'Spotify';
      case MusicApp.youtubeMusic:
        return 'YouTube Music';
      case MusicApp.appleMusic:
        return 'Apple Music';
      case MusicApp.none:
        return 'Ninguna';
    }
  }

  // Obtener lista de apps de musica disponibles (simulado para UI)
  static List<MusicApp> getAvailableMusicApps() {
    if (Platform.isAndroid) {
      return [
        MusicApp.spotify,
        MusicApp.youtubeMusic,
        MusicApp.appleMusic,
      ];
    } else if (Platform.isIOS) {
      return [
        MusicApp.appleMusic,
        MusicApp.spotify,
        MusicApp.youtubeMusic,
      ];
    }
    return [];
  }
}
