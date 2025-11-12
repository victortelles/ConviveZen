import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../models/crisis_log.dart';
import '../../../services/crisis_log_service.dart';

// Pantalla de Historial de Crisis (Premium)
class CrisisHistoryScreen extends StatefulWidget {
  const CrisisHistoryScreen({Key? key}) : super(key: key);

  @override
  _CrisisHistoryScreenState createState() => _CrisisHistoryScreenState();
}

class _CrisisHistoryScreenState extends State<CrisisHistoryScreen> {
  final CrisisLogService _crisisLogService = CrisisLogService();
  List<CrisisLog> _crisisLogs = [];
  bool _isLoading = true;
  Map<String, dynamic>? _stats;

  @override
  void initState() {
    super.initState();
    _loadCrisisHistory();
  }

  Future<void> _loadCrisisHistory() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final logs = await _crisisLogService.getCrisisLogs(user.uid);
        final stats = await _crisisLogService.getCrisisStats(user.uid);
        
        setState(() {
          _crisisLogs = logs;
          _stats = stats;
          _isLoading = false;
        });
      } catch (e) {
        print('Error loading crisis history: $e');
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade50,
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'Historial de Crisis',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 8),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.orange.shade500,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'PREMIUM',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.purple.shade400,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
              child: RefreshIndicator(
                onRefresh: _loadCrisisHistory,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Estadísticas
                        if (_stats != null) _buildStatsSection(),
                        
                        SizedBox(height: 24),
                        
                        // Título de historial
                        Text(
                          'Registro de Crisis',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.purple.shade700,
                          ),
                        ),
                        SizedBox(height: 12),
                        
                        // Lista de crisis
                        if (_crisisLogs.isEmpty)
                          _buildEmptyState()
                        else
                          ..._crisisLogs.map((log) => _buildCrisisCard(log)).toList(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  // Sección de estadísticas
  Widget _buildStatsSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Estadísticas',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.purple.shade700,
              ),
            ),
            SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Total de Crisis',
                    _stats!['totalCrises'].toString(),
                    Icons.event_note,
                    Colors.blue,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Mejora Promedio',
                    '${_stats!['averageImprovement'].toStringAsFixed(1)} pts',
                    Icons.trending_up,
                    Colors.green,
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Tasa de Efectividad',
                    '${(_stats!['effectiveRate'] * 100).toStringAsFixed(0)}%',
                    Icons.check_circle,
                    Colors.orange,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Herramienta Favorita',
                    _getToolLabel(_stats!['mostUsedTool'] ?? 'N/A'),
                    Icons.favorite,
                    Colors.pink,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Tarjeta de estadística individual
  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  // Tarjeta de crisis individual
  Widget _buildCrisisCard(CrisisLog log) {
    final improvement = log.anxietyImprovement ?? 0;
    final duration = log.sessionDuration;
    
    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showCrisisDetails(log),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Fecha y hora
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 16, color: Colors.purple.shade600),
                      SizedBox(width: 8),
                      Text(
                        _formatDateTime(log.startTime),
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.purple.shade700,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(log.status).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _getStatusLabel(log.status),
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: _getStatusColor(log.status),
                      ),
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 12),
              
              // Nivel de ansiedad
              Row(
                children: [
                  _buildMetricChip(
                    'Antes: ${log.anxietyLevelBefore}',
                    Colors.red,
                    Icons.arrow_upward,
                  ),
                  SizedBox(width: 8),
                  if (log.anxietyLevelAfter != null)
                    _buildMetricChip(
                      'Después: ${log.anxietyLevelAfter}',
                      improvement > 0 ? Colors.green : Colors.orange,
                      improvement > 0 ? Icons.arrow_downward : Icons.remove,
                    ),
                  if (improvement > 0) ...[
                    SizedBox(width: 8),
                    _buildMetricChip(
                      'Mejoró ${improvement}pts',
                      Colors.green,
                      Icons.trending_up,
                    ),
                  ],
                ],
              ),
              
              SizedBox(height: 12),
              
              // Herramientas usadas
              if (log.toolsUsed.isNotEmpty) ...[
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: log.toolsUsed.map((tool) {
                    final isPrimary = tool == log.primaryToolUsed;
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isPrimary ? Colors.purple.shade100 : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                        border: isPrimary ? Border.all(color: Colors.purple.shade400) : null,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getToolIcon(tool),
                            size: 12,
                            color: isPrimary ? Colors.purple.shade700 : Colors.grey.shade700,
                          ),
                          SizedBox(width: 4),
                          Text(
                            _getToolLabel(tool),
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: isPrimary ? FontWeight.w600 : FontWeight.normal,
                              color: isPrimary ? Colors.purple.shade700 : Colors.grey.shade700,
                            ),
                          ),
                          if (isPrimary) ...[
                            SizedBox(width: 4),
                            Icon(Icons.star, size: 12, color: Colors.amber),
                          ],
                        ],
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 8),
              ],
              
              // Duración
              if (duration > 0)
                Row(
                  children: [
                    Icon(Icons.timer, size: 14, color: Colors.grey.shade600),
                    SizedBox(width: 4),
                    Text(
                      'Duración: ${duration} min',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Chip de métrica
  Widget _buildMetricChip(String label, Color color, IconData icon) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  // Estado vacío
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 60),
        child: Column(
          children: [
            Icon(
              Icons.history,
              size: 80,
              color: Colors.grey.shade400,
            ),
            SizedBox(height: 16),
            Text(
              'Sin historial de crisis',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Tus registros aparecerán aquí',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Mostrar detalles de una crisis
  void _showCrisisDetails(CrisisLog log) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: EdgeInsets.all(20),
          child: ListView(
            controller: scrollController,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              SizedBox(height: 20),
              
              // Título
              Text(
                'Detalles de la Crisis',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple.shade700,
                ),
              ),
              SizedBox(height: 8),
              Text(
                _formatDateTime(log.startTime),
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              
              Divider(height: 32),
              
              // Información detallada
              _buildDetailRow('Inicio', _formatTime(log.startTime)),
              if (log.endTime != null)
                _buildDetailRow('Fin', _formatTime(log.endTime!)),
              _buildDetailRow('Duración', '${log.sessionDuration} minutos'),
              
              Divider(height: 32),
              
              _buildDetailRow('Ansiedad Inicial', '${log.anxietyLevelBefore}/10'),
              if (log.anxietyLevelAfter != null)
                _buildDetailRow('Ansiedad Final', '${log.anxietyLevelAfter}/10'),
              if (log.anxietyImprovement != null)
                _buildDetailRow(
                  'Mejora',
                  log.anxietyImprovement! > 0 
                      ? '${log.anxietyImprovement} puntos ↓'
                      : 'Sin mejora',
                ),
              
              Divider(height: 32),
              
              if (log.toolsUsed.isNotEmpty) ...[
                Text(
                  'Herramientas Utilizadas',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.purple.shade700,
                  ),
                ),
                SizedBox(height: 12),
                ...log.toolsUsed.map((tool) => Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Icon(_getToolIcon(tool), size: 18, color: Colors.purple.shade600),
                      SizedBox(width: 12),
                      Text(
                        _getToolLabel(tool),
                        style: GoogleFonts.poppins(fontSize: 14),
                      ),
                      if (tool == log.primaryToolUsed) ...[
                        SizedBox(width: 8),
                        Icon(Icons.star, size: 16, color: Colors.amber),
                      ],
                    ],
                  ),
                )),
                SizedBox(height: 16),
              ],
              
              if (log.userNotes != null && log.userNotes!.isNotEmpty) ...[
                Text(
                  'Notas',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.purple.shade700,
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    log.userNotes!,
                    style: GoogleFonts.poppins(fontSize: 14),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
        ],
      ),
    );
  }

  // Helpers
  String _formatDateTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'Hoy, ${_formatTime(date)}';
    } else if (difference.inDays == 1) {
      return 'Ayer, ${_formatTime(date)}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} días atrás';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  String _getToolLabel(String tool) {
    switch (tool) {
      case 'breathing':
        return 'Respiración';
      case 'meditation':
        return 'Meditación';
      case 'music':
        return 'Música';
      case 'games':
        return 'Juegos';
      case 'ai_chat':
        return 'Chat IA';
      case 'emergency_contacts':
        return 'Contactos';
      default:
        return tool;
    }
  }

  IconData _getToolIcon(String tool) {
    switch (tool) {
      case 'breathing':
        return Icons.air;
      case 'meditation':
        return Icons.self_improvement;
      case 'music':
        return Icons.music_note;
      case 'games':
        return Icons.games;
      case 'ai_chat':
        return Icons.chat_bubble_outline;
      case 'emergency_contacts':
        return Icons.phone;
      default:
        return Icons.help_outline;
    }
  }

  String _getStatusLabel(String status) {
    switch (status) {
      case 'active':
        return 'Activa';
      case 'effective':
        return 'Efectiva';
      case 'helpful':
        return 'Útil';
      case 'completed':
        return 'Completada';
      default:
        return status;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'active':
        return Colors.blue;
      case 'effective':
        return Colors.green;
      case 'helpful':
        return Colors.orange;
      case 'completed':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
}
