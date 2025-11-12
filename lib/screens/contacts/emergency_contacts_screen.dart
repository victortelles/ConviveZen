import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/user_contact.dart';
import '../../services/contacts_service.dart';
import 'widgets/contact_card.dart';
import 'widgets/add_contact_dialog.dart';
import 'widgets/edit_contact_dialog.dart';

// Pantalla principal para gestionar contactos de emergencia
class EmergencyContactsScreen extends StatefulWidget {
  final bool isEmergencyMode;

  const EmergencyContactsScreen({
    Key? key,
    this.isEmergencyMode = false,
  }) : super(key: key);

  @override
  _EmergencyContactsScreenState createState() => _EmergencyContactsScreenState();
}

class _EmergencyContactsScreenState extends State<EmergencyContactsScreen> {
  final ContactsService _contactsService = ContactsService();
  final String userId = FirebaseAuth.instance.currentUser!.uid;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isEmergencyMode ? Colors.red.shade50 : Colors.pink.shade50,
      appBar: AppBar(
        title: Text(
          widget.isEmergencyMode ? 'Llamar a alguien de confianza' : 'Contactos de Emergencia',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: widget.isEmergencyMode ? Colors.red.shade400 : Colors.pink.shade400,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
      ),
      body: StreamBuilder<List<UserContact>>(
        stream: _contactsService.getContactsStream(userId),
        builder: (context, snapshot) {
          // Estado de carga
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.pink.shade400),
              ),
            );
          }

          // Error
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 60, color: Colors.red.shade300),
                  SizedBox(height: 16),
                  Text(
                    'Error al cargar contactos',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.red.shade700,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    snapshot.error.toString(),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            );
          }

          final contacts = snapshot.data ?? [];

          // Sin contactos registrados
          if (contacts.isEmpty) {
            return _buildEmptyState();
          }

          // Lista de contactos
          return _buildContactsList(contacts);
        },
      ),
      floatingActionButton: widget.isEmergencyMode
          ? null
          : FloatingActionButton.extended(
              onPressed: _showAddContactDialog,
              backgroundColor: Colors.pink.shade400,
              icon: Icon(Icons.person_add, color: Colors.white),
              label: Text(
                'Agregar',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
    );
  }

  // Widget para mostrar cuando no hay contactos
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.contact_phone_outlined,
              size: 100,
              color: Colors.pink.shade200,
            ),
            SizedBox(height: 24),
            Text(
              'No tienes contactos de emergencia',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.pink.shade700,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12),
            Text(
              'Agrega personas de confianza que puedan ayudarte en momentos de crisis',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _showAddContactDialog,
              icon: Icon(Icons.person_add),
              label: Text('Agregar primer contacto'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink.shade400,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget para mostrar la lista de contactos
  Widget _buildContactsList(List<UserContact> contacts) {
    return Column(
      children: [
        // Mensaje informativo en modo emergencia
        if (widget.isEmergencyMode)
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.red.shade300),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.red.shade700),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Selecciona un contacto para llamar o enviar mensaje',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.red.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        
        // Lista de contactos
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              final contact = contacts[index];
              return ContactCard(
                contact: contact,
                isEmergencyMode: widget.isEmergencyMode,
                onCall: () => _callContact(contact),
                onMessage: () => _messageContact(contact),
                onEdit: () => _showEditContactDialog(contact),
                onDelete: () => _deleteContact(contact),
              );
            },
          ),
        ),
      ],
    );
  }

  // Mostrar diálogo para agregar contacto
  void _showAddContactDialog() {
    showDialog(
      context: context,
      builder: (context) => AddContactDialog(
        userId: userId,
        onContactAdded: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Contacto agregado correctamente'),
              backgroundColor: Colors.green,
            ),
          );
        },
      ),
    );
  }

  // Mostrar diálogo para editar contacto
  void _showEditContactDialog(UserContact contact) {
    showDialog(
      context: context,
      builder: (context) => EditContactDialog(
        contact: contact,
        onContactUpdated: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Contacto actualizado correctamente'),
              backgroundColor: Colors.green,
            ),
          );
        },
      ),
    );
  }

  // Eliminar contacto con confirmación
  void _deleteContact(UserContact contact) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Eliminar contacto',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: Text(
          '¿Estás seguro de que deseas eliminar a ${contact.name} de tus contactos de emergencia?',
          style: GoogleFonts.poppins(),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar', style: GoogleFonts.poppins(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await _contactsService.deleteContact(userId, contact.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Contacto eliminado'),
                    backgroundColor: Colors.green,
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error al eliminar: ${e.toString()}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade400,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text('Eliminar', style: GoogleFonts.poppins(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // Llamar a un contacto
  Future<void> _callContact(UserContact contact) async {
    try {
      // Marcar como contactado
      await _contactsService.markAsContacted(userId, contact.id);

      // Intentar realizar llamada
      String phoneNumber = contact.contactInfo.replaceAll(RegExp(r'[^0-9+]'), '');
      final Uri telUri = Uri(scheme: 'tel', path: phoneNumber);

      if (await canLaunchUrl(telUri)) {
        await launchUrl(telUri);
      } else {
        _showErrorDialog('No se puede realizar la llamada');
      }
    } catch (e) {
      _showErrorDialog('Error al llamar: ${e.toString()}');
    }
  }

  // Enviar mensaje a un contacto
  Future<void> _messageContact(UserContact contact) async {
    try {
      // Marcar como contactado
      await _contactsService.markAsContacted(userId, contact.id);

      String phoneNumber = contact.contactInfo.replaceAll(RegExp(r'[^0-9+]'), '');
      
      // Intentar abrir WhatsApp primero
      final Uri whatsappUri = Uri.parse('https://wa.me/$phoneNumber?text=Necesito ayuda, estoy teniendo un ataque de ansiedad');
      
      if (await canLaunchUrl(whatsappUri)) {
        await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
      } else {
        // Si WhatsApp no está disponible, usar SMS
        final Uri smsUri = Uri(scheme: 'sms', path: phoneNumber, queryParameters: {
          'body': 'Necesito ayuda, estoy teniendo un ataque de ansiedad'
        });
        
        if (await canLaunchUrl(smsUri)) {
          await launchUrl(smsUri);
        } else {
          _showErrorDialog('No se puede enviar mensaje');
        }
      }
    } catch (e) {
      _showErrorDialog('Error al enviar mensaje: ${e.toString()}');
    }
  }

  // Mostrar diálogo de error
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        content: Text(message, style: GoogleFonts.poppins()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK', style: GoogleFonts.poppins(color: Colors.pink.shade400)),
          ),
        ],
      ),
    );
  }
}
