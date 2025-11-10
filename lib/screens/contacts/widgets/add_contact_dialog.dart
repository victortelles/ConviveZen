import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/user_contact.dart';
import '../../../services/contacts_service.dart';

// Diálogo para agregar un nuevo contacto de emergencia
class AddContactDialog extends StatefulWidget {
  final String userId;
  final VoidCallback onContactAdded;

  const AddContactDialog({
    Key? key,
    required this.userId,
    required this.onContactAdded,
  }) : super(key: key);

  @override
  _AddContactDialogState createState() => _AddContactDialogState();
}

class _AddContactDialogState extends State<AddContactDialog> {
  final _formKey = GlobalKey<FormState>();
  final ContactsService _contactsService = ContactsService();
  
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactInfoController = TextEditingController();
  
  String _selectedRelationship = 'family';
  String _selectedContactType = 'phone';
  bool _isPrimary = false;
  bool _notifyInEmergency = true;
  bool _isLoading = false;

  // Opciones de relación
  final List<Map<String, dynamic>> _relationshipOptions = [
    {'value': 'family', 'label': 'Familiar', 'icon': Icons.family_restroom},
    {'value': 'friend', 'label': 'Amigo/a', 'icon': Icons.people},
    {'value': 'partner', 'label': 'Pareja', 'icon': Icons.favorite},
    {'value': 'therapist', 'label': 'Terapeuta', 'icon': Icons.psychology},
    {'value': 'psychologist', 'label': 'Psicólogo/a', 'icon': Icons.support_agent},
    {'value': 'doctor', 'label': 'Doctor/a', 'icon': Icons.medical_services},
  ];

  // Opciones de tipo de contacto
  final List<Map<String, dynamic>> _contactTypeOptions = [
    {'value': 'phone', 'label': 'Teléfono', 'icon': Icons.phone},
    {'value': 'whatsapp', 'label': 'WhatsApp', 'icon': Icons.chat},
    {'value': 'email', 'label': 'Email', 'icon': Icons.email},
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _contactInfoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título
                Text(
                  'Agregar contacto de emergencia',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.pink.shade700,
                  ),
                ),
                SizedBox(height: 24),

                // Campo de nombre
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Nombre completo',
                    hintText: 'Ej: María González',
                    prefixIcon: Icon(Icons.person, color: Colors.pink.shade400),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.pink.shade400, width: 2),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Por favor ingresa un nombre';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Selector de relación
                Text(
                  'Relación',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade700,
                  ),
                ),
                SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _relationshipOptions.map((option) {
                    final isSelected = _selectedRelationship == option['value'];
                    return ChoiceChip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            option['icon'],
                            size: 18,
                            color: isSelected ? Colors.white : Colors.grey.shade700,
                          ),
                          SizedBox(width: 4),
                          Text(option['label']),
                        ],
                      ),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedRelationship = option['value'];
                        });
                      },
                      selectedColor: Colors.pink.shade400,
                      labelStyle: GoogleFonts.poppins(
                        fontSize: 12,
                        color: isSelected ? Colors.white : Colors.grey.shade700,
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 16),

                // Tipo de contacto
                Text(
                  'Tipo de contacto',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade700,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: _contactTypeOptions.map((option) {
                    final isSelected = _selectedContactType == option['value'];
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                option['icon'],
                                size: 16,
                                color: isSelected ? Colors.white : Colors.grey.shade700,
                              ),
                              SizedBox(width: 4),
                              Text(option['label']),
                            ],
                          ),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedContactType = option['value'];
                            });
                          },
                          selectedColor: Colors.pink.shade400,
                          labelStyle: GoogleFonts.poppins(
                            fontSize: 11,
                            color: isSelected ? Colors.white : Colors.grey.shade700,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 16),

                // Campo de información de contacto
                TextFormField(
                  controller: _contactInfoController,
                  decoration: InputDecoration(
                    labelText: _selectedContactType == 'email' ? 'Email' : 'Número de teléfono',
                    hintText: _selectedContactType == 'email' 
                        ? 'ejemplo@correo.com' 
                        : '+52 123 456 7890',
                    prefixIcon: Icon(
                      _selectedContactType == 'email' ? Icons.email : Icons.phone,
                      color: Colors.pink.shade400,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.pink.shade400, width: 2),
                    ),
                  ),
                  keyboardType: _selectedContactType == 'email' 
                      ? TextInputType.emailAddress 
                      : TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Por favor ingresa información de contacto';
                    }
                    if (_selectedContactType == 'email' && !value.contains('@')) {
                      return 'Email inválido';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Opciones adicionales
                CheckboxListTile(
                  title: Text(
                    'Contacto principal',
                    style: GoogleFonts.poppins(fontSize: 14),
                  ),
                  subtitle: Text(
                    'Se contactará primero en emergencias',
                    style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey.shade600),
                  ),
                  value: _isPrimary,
                  onChanged: (value) {
                    setState(() {
                      _isPrimary = value ?? false;
                    });
                  },
                  activeColor: Colors.pink.shade400,
                  contentPadding: EdgeInsets.zero,
                ),

                SizedBox(height: 24),

                // Botones de acción
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: _isLoading ? null : () => Navigator.pop(context),
                        child: Text(
                          'Cancelar',
                          style: GoogleFonts.poppins(color: Colors.grey.shade600),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _saveContact,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink.shade400,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : Text(
                                'Guardar',
                                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                              ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Guardar contacto
  Future<void> _saveContact() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Obtener el número de contactos existentes para establecer prioridad
      final existingContacts = await _contactsService.getContacts(widget.userId);
      final priority = existingContacts.length + 1;

      // Crear nuevo contacto
      final newContact = UserContact(
        id: '', // Se generará en Firestore
        userId: widget.userId,
        name: _nameController.text.trim(),
        relationship: _selectedRelationship,
        contactInfo: _contactInfoController.text.trim(),
        contactType: _selectedContactType,
        notifyInEmergency: _notifyInEmergency,
        isPrimary: _isPrimary,
        priority: priority,
      );

      // Guardar en Firestore
      await _contactsService.createContact(newContact);

      // Cerrar diálogo
      Navigator.pop(context);
      
      // Callback de éxito
      widget.onContactAdded();
    } catch (e) {
      // Mostrar error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al guardar: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
