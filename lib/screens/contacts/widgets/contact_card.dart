import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/user_contact.dart';

// Widget de tarjeta para mostrar un contacto de emergencia
class ContactCard extends StatelessWidget {
  final UserContact contact;
  final bool isEmergencyMode;
  final VoidCallback onCall;
  final VoidCallback onMessage;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ContactCard({
    Key? key,
    required this.contact,
    this.isEmergencyMode = false,
    required this.onCall,
    required this.onMessage,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: contact.isPrimary
            ? BorderSide(color: Colors.pink.shade300, width: 2)
            : BorderSide.none,
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Encabezado del contacto
            Row(
              children: [
                // Icono del tipo de relación
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _getRelationshipColor().withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getRelationshipIcon(),
                    color: _getRelationshipColor(),
                    size: 28,
                  ),
                ),
                SizedBox(width: 12),
                
                // Nombre y relación
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              contact.name,
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.pink.shade800,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (contact.isPrimary) ...[
                            SizedBox(width: 8),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.pink.shade400,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Principal',
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        _getRelationshipLabel(),
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Botón de opciones (solo en modo normal)
                if (!isEmergencyMode)
                  PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert, color: Colors.grey.shade600),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onSelected: (value) {
                      if (value == 'edit') {
                        onEdit();
                      } else if (value == 'delete') {
                        onDelete();
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 20, color: Colors.blue.shade600),
                            SizedBox(width: 12),
                            Text('Editar', style: GoogleFonts.poppins()),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 20, color: Colors.red.shade600),
                            SizedBox(width: 12),
                            Text('Eliminar', style: GoogleFonts.poppins()),
                          ],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            
            SizedBox(height: 12),
            
            // Información de contacto
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(
                    _getContactTypeIcon(),
                    size: 18,
                    color: Colors.grey.shade700,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      contact.contactInfo,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Botones de acción en modo emergencia
            if (isEmergencyMode) ...[
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: onCall,
                      icon: Icon(Icons.phone, size: 20),
                      label: Text('Llamar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade500,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: onMessage,
                      icon: Icon(Icons.message, size: 20),
                      label: Text('Mensaje'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade500,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
            
            // Última vez contactado
            if (contact.lastContacted != null) ...[
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.access_time, size: 14, color: Colors.grey.shade500),
                  SizedBox(width: 4),
                  Text(
                    'Último contacto: ${_formatLastContacted()}',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Obtener icono según el tipo de relación
  IconData _getRelationshipIcon() {
    switch (contact.relationship.toLowerCase()) {
      case 'family':
      case 'familiar':
        return Icons.family_restroom;
      case 'friend':
      case 'amigo':
        return Icons.people;
      case 'partner':
      case 'pareja':
        return Icons.favorite;
      case 'therapist':
      case 'terapeuta':
        return Icons.psychology;
      case 'doctor':
        return Icons.medical_services;
      case 'psychologist':
      case 'psicologo':
        return Icons.support_agent;
      default:
        return Icons.person;
    }
  }

  // Obtener color según el tipo de relación
  Color _getRelationshipColor() {
    switch (contact.relationship.toLowerCase()) {
      case 'family':
      case 'familiar':
        return Colors.blue.shade600;
      case 'friend':
      case 'amigo':
        return Colors.green.shade600;
      case 'partner':
      case 'pareja':
        return Colors.pink.shade600;
      case 'therapist':
      case 'terapeuta':
        return Colors.purple.shade600;
      case 'doctor':
        return Colors.red.shade600;
      case 'psychologist':
      case 'psicologo':
        return Colors.orange.shade600;
      default:
        return Colors.grey.shade600;
    }
  }

  // Obtener etiqueta según el tipo de relación
  String _getRelationshipLabel() {
    switch (contact.relationship.toLowerCase()) {
      case 'family':
        return 'Familiar';
      case 'friend':
        return 'Amigo/a';
      case 'partner':
        return 'Pareja';
      case 'therapist':
        return 'Terapeuta';
      case 'doctor':
        return 'Doctor/a';
      case 'psychologist':
        return 'Psicólogo/a';
      default:
        return contact.relationship;
    }
  }

  // Obtener icono según el tipo de contacto
  IconData _getContactTypeIcon() {
    switch (contact.contactType.toLowerCase()) {
      case 'phone':
        return Icons.phone;
      case 'email':
        return Icons.email;
      case 'whatsapp':
        return Icons.chat;
      default:
        return Icons.contact_phone;
    }
  }

  // Formatear última vez contactado
  String _formatLastContacted() {
    if (contact.lastContacted == null) return 'Nunca';

    final now = DateTime.now();
    final difference = now.difference(contact.lastContacted!);

    if (difference.inMinutes < 60) {
      return 'Hace ${difference.inMinutes} min';
    } else if (difference.inHours < 24) {
      return 'Hace ${difference.inHours} h';
    } else if (difference.inDays < 7) {
      return 'Hace ${difference.inDays} días';
    } else {
      return '${contact.lastContacted!.day}/${contact.lastContacted!.month}/${contact.lastContacted!.year}';
    }
  }
}
