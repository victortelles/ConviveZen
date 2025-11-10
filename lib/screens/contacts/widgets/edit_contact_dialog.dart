import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/user_contact.dart';
import '../../../services/contacts_service.dart';

// Diálogo para editar un contacto de emergencia existente
class EditContactDialog extends StatefulWidget {
  final UserContact contact;
  final VoidCallback onContactUpdated;

  const EditContactDialog({
    Key? key,
    required this.contact,
    required this.onContactUpdated,
  }) : super(key: key);

  @override
  _EditContactDialogState createState() => _EditContactDialogState();
}

class _EditContactDialogState extends State<EditContactDialog> {
  final _formKey = GlobalKey<FormState>();
  final ContactsService _contactsService = ContactsService();

  late TextEditingController _nameController;
  late TextEditingController _contactInfoController;

  late String _selectedRelationship;
  late String _selectedContactType;
  late bool _isPrimary;
  late bool _notifyInEmergency;
  bool _isLoading = false;

  // Opciones de relación
  final List<Map<String, dynamic>> _relationshipOptions = [
    {'value': 'family', 'label': 'Familiar', 'icon': Icons.family_restroom},
    {'value': 'friend', 'label': 'Amigo/a', 'icon': Icons.people},
    {'value': 'partner', 'label': 'Pareja', 'icon': Icons.favorite},
    {'value': 'therapist', 'label': 'Terapeuta', 'icon': Icons.psychology},
    {
      'value': 'psychologist',
      'label': 'Psicólogo/a',
      'icon': Icons.support_agent
    },
    {'value': 'doctor', 'label': 'Doctor/a', 'icon': Icons.medical_services},
  ];

  // Opciones de tipo de contacto
  final List<Map<String, dynamic>> _contactTypeOptions = [
    {'value': 'phone', 'label': 'Teléfono', 'icon': Icons.phone},
    {'value': 'whatsapp', 'label': 'WhatsApp', 'icon': Icons.chat},
    {'value': 'email', 'label': 'Email', 'icon': Icons.email},
  ];

  @override
  void initState() {
    super.initState();
    // Inicializar controladores con los datos del contacto
    _nameController = TextEditingController(text: widget.contact.name);
    _contactInfoController =
        TextEditingController(text: widget.contact.contactInfo);
    _selectedRelationship = widget.contact.relationship;
    _selectedContactType = widget.contact.contactType;
    _isPrimary = widget.contact.isPrimary;
    _notifyInEmergency = widget.contact.notifyInEmergency;
  }

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
                  'Editar contacto',
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
                      borderSide:
                          BorderSide(color: Colors.pink.shade400, width: 2),
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
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.pink.shade100),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedRelationship,
                      icon: Icon(Icons.arrow_drop_down,
                          color: Colors.pink.shade400),
                      isExpanded: true,
                      style: GoogleFonts.poppins(
                          fontSize: 14, color: Colors.grey.shade800),
                      items: _relationshipOptions.map((option) {
                        return DropdownMenuItem<String>(
                          value: option['value'],
                          child: Row(
                            children: [
                              Icon(option['icon'],
                                  color: Colors.pink.shade400, size: 20),
                              SizedBox(width: 8),
                              Text(option['label'],
                                  style: GoogleFonts.poppins(fontSize: 14)),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedRelationship = value!;
                        });
                      },
                    ),
                  ),
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
                    return AnimatedContainer(
                      duration: Duration(milliseconds: 220),
                      curve: Curves.easeInOut,
                      width: isSelected ? 160 : 48,
                      child: Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          avatar: null,
                          label: isSelected
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      option['icon'],
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 8),
                                    Flexible(
                                      child: Text(
                                        option['label'],
                                        style: GoogleFonts.poppins(
                                          fontSize: 13,
                                          color: Colors.white,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                )
                              : Icon(
                                  option['icon'],
                                  size: 18,
                                  color: Colors.grey.shade700,
                                ),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedContactType = option['value'];
                            });
                          },
                          selectedColor: Colors.pink.shade400,
                          labelStyle: GoogleFonts.poppins(
                            fontSize: 13,
                            color: isSelected
                                ? Colors.white
                                : Colors.grey.shade700,
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
                    labelText: _selectedContactType == 'email'
                        ? 'Email'
                        : 'Número de teléfono',
                    hintText: _selectedContactType == 'email'
                        ? 'ejemplo@correo.com'
                        : '+52 123 456 7890',
                    prefixIcon: Icon(
                      _selectedContactType == 'email'
                          ? Icons.email
                          : Icons.phone,
                      color: Colors.pink.shade400,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: Colors.pink.shade400, width: 2),
                    ),
                  ),
                  keyboardType: _selectedContactType == 'email'
                      ? TextInputType.emailAddress
                      : TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Por favor ingresa información de contacto';
                    }
                    if (_selectedContactType == 'email' &&
                        !value.contains('@')) {
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
                    style: GoogleFonts.poppins(
                        fontSize: 11, color: Colors.grey.shade600),
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
                        onPressed:
                            _isLoading ? null : () => Navigator.pop(context),
                        child: Text(
                          'Cancelar',
                          style:
                              GoogleFonts.poppins(color: Colors.grey.shade600),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _updateContact,
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
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : Text(
                                'Actualizar',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600),
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

  // Actualizar contacto
  Future<void> _updateContact() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Actualizar contacto con los nuevos datos
      final updatedContact = widget.contact.copyWith(
        name: _nameController.text.trim(),
        relationship: _selectedRelationship,
        contactInfo: _contactInfoController.text.trim(),
        contactType: _selectedContactType,
        isPrimary: _isPrimary,
        notifyInEmergency: _notifyInEmergency,
      );

      // Guardar en Firestore
      await _contactsService.updateContact(updatedContact);

      // Cerrar diálogo
      Navigator.pop(context);

      // Callback de éxito
      widget.onContactUpdated();
    } catch (e) {
      // Mostrar error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al actualizar: ${e.toString()}'),
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
