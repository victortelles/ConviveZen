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

  // Mapeo de tipos de ansiedad a generos musicales con scoring (1-5)
  // Basado en investigacion de musicoterapia y efectividad terapeutica
  static const Map<String, Map<String, int>> _anxietyToMusicScoring = {
    'generalized': {
      'Ambient': 5,
      'Meditación': 5,
      'Clásica': 4,
      'Lo-Fi Hip Hop': 4,
      'Instrumental': 4,
      'Sonidos de la naturaleza': 4,
      'Jazz suave': 3,
      'Bossa Nova': 3,
      'New Age': 4,
      'Chill-out': 3,
      'Downtempo': 3,
    },
    'social': {
      'Lo-Fi Hip Hop': 5,
      'Instrumental': 4,
      'Ambient': 4,
      'Clásica': 3,
      'Jazz suave': 3,
      'Electronic': 3,
      'Bossa Nova': 3,
      'Chill-out': 4,
    },
    'panic': {
      'Meditación': 5,
      'Sonidos de la naturaleza': 5,
      'Frecuencias binaurales': 5,
      'Ambient': 4,
      'Clásica': 4,
      'Música para dormir': 4,
      'Instrumental': 3,
      'New Age': 4,
      'Cantos gregorianos': 3,
    },
    'specific': {
      'Meditación': 4,
      'Clásica': 4,
      'Ambient': 4,
      'Instrumental': 3,
      'Sonidos de la naturaleza': 3,
      'New Age': 3,
    },
    'performance': {
      'Clásica': 5,
      'Música para concentrarse': 5,
      'Lo-Fi Hip Hop': 4,
      'Jazz suave': 4,
      'Instrumental': 4,
      'Ambient': 3,
      'Electronic': 3,
      'Bossa Nova': 3,
    },
    'mixed': {
      'Ambient': 4,
      'Meditación': 4,
      'Clásica': 4,
      'Lo-Fi Hip Hop': 3,
      'Instrumental': 3,
      'Sonidos de la naturaleza': 3,
    },
  };

  // Algoritmo para seleccionar el mejor genero musical segun tipos de ansiedad
  static String selectBestMusicGenre(
    List<String> userMusicGenres,
    List<String> userAnxietyTypes,
  ) {
    print('=== MusicService.selectBestMusicGenre ===');
    print('Generos del usuario: $userMusicGenres');
    print('Tipos de ansiedad: $userAnxietyTypes');

    // Si no hay generos seleccionados, retornar el primero por defecto
    if (userMusicGenres.isEmpty) {
      print('No hay generos seleccionados, usando Ambient por defecto');
      return 'Ambient';
    }

    // Si no hay tipos de ansiedad, retornar el primer genero
    if (userAnxietyTypes.isEmpty) {
      print('No hay tipos de ansiedad, usando primer genero: ${userMusicGenres.first}');
      return userMusicGenres.first;
    }

    // Calcular score para cada genero del usuario
    Map<String, int> genreScores = {};
    
    for (String genre in userMusicGenres) {
      int score = 0;
      
      // Sumar pesos segun cada tipo de ansiedad del usuario
      for (String anxietyType in userAnxietyTypes) {
        if (_anxietyToMusicScoring.containsKey(anxietyType)) {
          final anxietyMapping = _anxietyToMusicScoring[anxietyType]!;
          if (anxietyMapping.containsKey(genre)) {
            score += anxietyMapping[genre]!;
          }
        }
      }
      
      genreScores[genre] = score;
      print('Genero: $genre, Score: $score');
    }

    // Retornar el genero con mayor score
    if (genreScores.isEmpty || genreScores.values.every((score) => score == 0)) {
      print('Ningun genero tiene score, usando primer genero: ${userMusicGenres.first}');
      return userMusicGenres.first;
    }

    // Encontrar el genero con mayor puntuacion
    String bestGenre = genreScores.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
    
    print('Mejor genero seleccionado: $bestGenre (Score: ${genreScores[bestGenre]})');
    return bestGenre;
  }

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
