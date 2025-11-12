import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Diálogo de feedback después de usar herramientas de crisis
class CrisisFeedbackDialog extends StatefulWidget {
  final List<String> toolsUsed;
  final Function(int anxietyLevel, String? primaryTool, bool wasHelpful) onFeelBetter;
  final VoidCallback onNeedMoreHelp;

  const CrisisFeedbackDialog({
    Key? key,
    required this.toolsUsed,
    required this.onFeelBetter,
    required this.onNeedMoreHelp,
  }) : super(key: key);

  @override
  _CrisisFeedbackDialogState createState() => _CrisisFeedbackDialogState();
}

class _CrisisFeedbackDialogState extends State<CrisisFeedbackDialog> {
  int _anxietyLevel = 5;
  String? _selectedPrimaryTool;
  bool _wasHelpful = false;

  @override
  void initState() {
    super.initState();
    // Si solo usó una herramienta, seleccionarla automáticamente
    if (widget.toolsUsed.length == 1) {
      _selectedPrimaryTool = widget.toolsUsed.first;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Título
            Text(
              '¿Cómo te sientes ahora?',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.pink.shade700,
              ),
              textAlign: TextAlign.center,
            ),
            
            SizedBox(height: 24),
            
            // Nivel de ansiedad actual
            Text(
              'Nivel de ansiedad actual',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(height: 8),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '😌',
                  style: TextStyle(fontSize: 24),
                ),
                Expanded(
                  child: Slider(
                    value: _anxietyLevel.toDouble(),
                    min: 1,
                    max: 10,
                    divisions: 9,
                    activeColor: _getAnxietyColor(),
                    label: _anxietyLevel.toString(),
                    onChanged: (value) {
                      setState(() {
                        _anxietyLevel = value.toInt();
                      });
                    },
                  ),
                ),
                Text(
                  '😰',
                  style: TextStyle(fontSize: 24),
                ),
              ],
            ),
            
            Text(
              _getAnxietyLevelText(),
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: _getAnxietyColor(),
              ),
            ),
            
            SizedBox(height: 24),
            
            // Pregunta sobre si ayudó
            if (widget.toolsUsed.isNotEmpty) ...[
              Text(
                '¿Te ayudó la herramienta?',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade700,
                ),
              ),
              SizedBox(height: 12),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildHelpfulButton(true, 'Sí', Colors.green),
                  SizedBox(width: 16),
                  _buildHelpfulButton(false, 'No', Colors.grey),
                ],
              ),
              
              SizedBox(height: 24),
            ],
            
            // Herramienta principal (si usó más de una)
            if (widget.toolsUsed.length > 1) ...[
              Text(
                '¿Cuál te ayudó más?',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade700,
                ),
              ),
              SizedBox(height: 12),
              
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: widget.toolsUsed.map((tool) {
                  final isSelected = _selectedPrimaryTool == tool;
                  return ChoiceChip(
                    label: Text(_getToolLabel(tool)),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedPrimaryTool = selected ? tool : null;
                      });
                    },
                    selectedColor: Colors.pink.shade300,
                    labelStyle: GoogleFonts.poppins(
                      fontSize: 12,
                      color: isSelected ? Colors.white : Colors.grey.shade700,
                    ),
                  );
                }).toList(),
              ),
              
              SizedBox(height: 24),
            ],
            
            // Botones de acción
            if (_anxietyLevel <= 4) ...[
              // Usuario se siente mejor
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    widget.onFeelBetter(_anxietyLevel, _selectedPrimaryTool, _wasHelpful);
                  },
                  icon: Icon(Icons.check_circle),
                  label: Text('Me siento mejor'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade500,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12),
              TextButton(
                onPressed: widget.onNeedMoreHelp,
                child: Text(
                  'Necesito más ayuda',
                  style: GoogleFonts.poppins(color: Colors.pink.shade600),
                ),
              ),
            ] else ...[
              // Usuario todavía necesita ayuda
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: widget.onNeedMoreHelp,
                  icon: Icon(Icons.health_and_safety),
                  label: Text('Probar otra herramienta'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink.shade500,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  widget.onFeelBetter(_anxietyLevel, _selectedPrimaryTool, _wasHelpful);
                },
                child: Text(
                  'Terminar sesión',
                  style: GoogleFonts.poppins(color: Colors.grey.shade600),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Widget para botón de "¿Te ayudó?"
  Widget _buildHelpfulButton(bool value, String label, Color color) {
    final isSelected = _wasHelpful == value;
    return InkWell(
      onTap: () {
        setState(() {
          _wasHelpful = value;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.2) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected ? color : Colors.grey.shade700,
          ),
        ),
      ),
    );
  }

  // Obtener color según nivel de ansiedad
  Color _getAnxietyColor() {
    if (_anxietyLevel <= 3) return Colors.green.shade600;
    if (_anxietyLevel <= 6) return Colors.orange.shade600;
    return Colors.red.shade600;
  }

  // Obtener texto según nivel de ansiedad
  String _getAnxietyLevelText() {
    if (_anxietyLevel <= 3) return 'Tranquilo/a';
    if (_anxietyLevel <= 6) return 'Moderado';
    if (_anxietyLevel <= 8) return 'Ansioso/a';
    return 'Muy ansioso/a';
  }

  // Obtener etiqueta de herramienta
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
}
