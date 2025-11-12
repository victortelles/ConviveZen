import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/crisis_log.dart';

// Servicio para gestionar logs de crisis en Firestore
class CrisisLogService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Referencia a la subcoleccion de crisis logs de un usuario
  CollectionReference _getCrisisLogsCollection(String userId) {
    return _firestore.collection('users').doc(userId).collection('crisis_logs');
  }

  // CREATE | Crear un nuevo log de crisis
  Future<String> createCrisisLog(CrisisLog log) async {
    try {
      final docRef = await _getCrisisLogsCollection(log.userId).add(log.toMap());
      
      // Actualizar el ID del log con el ID generado por Firestore
      await docRef.update({'id': docRef.id});
      
      return docRef.id;
    } catch (e) {
      print('Error creating crisis log: $e');
      throw e;
    }
  }

  // READ | Obtener todos los logs de crisis de un usuario
  Future<List<CrisisLog>> getCrisisLogs(String userId) async {
    try {
      final snapshot = await _getCrisisLogsCollection(userId)
          .orderBy('startTime', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => CrisisLog.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting crisis logs: $e');
      throw e;
    }
  }

  // READ | Obtener log de crisis activo (sin endTime)
  Future<CrisisLog?> getActiveCrisisLog(String userId) async {
    try {
      final snapshot = await _getCrisisLogsCollection(userId)
          .where('endTime', isNull: true)
          .orderBy('startTime', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return null;
      
      return CrisisLog.fromMap(snapshot.docs.first.data() as Map<String, dynamic>);
    } catch (e) {
      print('Error getting active crisis log: $e');
      return null;
    }
  }

  // UPDATE | Actualizar un log de crisis
  Future<void> updateCrisisLog(CrisisLog log) async {
    try {
      await _getCrisisLogsCollection(log.userId)
          .doc(log.id)
          .update(log.toMap());
    } catch (e) {
      print('Error updating crisis log: $e');
      throw e;
    }
  }

  // DELETE | Eliminar un log de crisis
  Future<void> deleteCrisisLog(String userId, String logId) async {
    try {
      await _getCrisisLogsCollection(userId).doc(logId).delete();
    } catch (e) {
      print('Error deleting crisis log: $e');
      throw e;
    }
  }

  // UTILITY | Agregar herramienta usada al log activo
  Future<void> addToolToActiveLog(String userId, String toolType) async {
    try {
      final activeLog = await getActiveCrisisLog(userId);
      if (activeLog != null) {
        final updatedLog = activeLog.addToolUsed(toolType);
        await updateCrisisLog(updatedLog);
      }
    } catch (e) {
      print('Error adding tool to active log: $e');
    }
  }

  // UTILITY | Completar sesión de crisis activa
  Future<void> completeActiveCrisisLog({
    required String userId,
    required int anxietyLevelAfter,
    String? primaryToolUsed,
    String? userNotes,
    bool wasHelpful = false,
  }) async {
    try {
      final activeLog = await getActiveCrisisLog(userId);
      if (activeLog != null) {
        final completedLog = activeLog.completeSession(
          anxietyLevelAfter: anxietyLevelAfter,
          primaryToolUsed: primaryToolUsed,
          userNotes: userNotes,
          wasHelpful: wasHelpful,
        );
        await updateCrisisLog(completedLog);
      }
    } catch (e) {
      print('Error completing crisis log: $e');
      throw e;
    }
  }

  // UTILITY | Obtener estadísticas de crisis logs
  Future<Map<String, dynamic>> getCrisisStats(String userId) async {
    try {
      final logs = await getCrisisLogs(userId);
      
      if (logs.isEmpty) {
        return {
          'totalCrises': 0,
          'averageImprovement': 0.0,
          'mostUsedTool': null,
          'effectiveRate': 0.0,
        };
      }

      // Calcular estadísticas
      int totalCrises = logs.length;
      int effectiveCount = logs.where((log) => log.wasEffective).length;
      
      double avgImprovement = 0.0;
      int improvementCount = 0;
      
      Map<String, int> toolCounts = {};
      
      for (var log in logs) {
        if (log.anxietyImprovement != null) {
          avgImprovement += log.anxietyImprovement!;
          improvementCount++;
        }
        
        for (var tool in log.toolsUsed) {
          toolCounts[tool] = (toolCounts[tool] ?? 0) + 1;
        }
      }
      
      if (improvementCount > 0) {
        avgImprovement /= improvementCount;
      }
      
      String? mostUsedTool;
      int maxCount = 0;
      toolCounts.forEach((tool, count) {
        if (count > maxCount) {
          maxCount = count;
          mostUsedTool = tool;
        }
      });

      return {
        'totalCrises': totalCrises,
        'averageImprovement': avgImprovement,
        'mostUsedTool': mostUsedTool,
        'effectiveRate': effectiveCount / totalCrises,
      };
    } catch (e) {
      print('Error getting crisis stats: $e');
      return {
        'totalCrises': 0,
        'averageImprovement': 0.0,
        'mostUsedTool': null,
        'effectiveRate': 0.0,
      };
    }
  }
}
