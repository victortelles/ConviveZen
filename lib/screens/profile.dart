import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:convivezen/screens/home.dart';
import 'package:convivezen/screens/sport_detail.dart';
import 'package:convivezen/widgets/profile_personalization.dart';

//Providers
import '../providers/app_state.dart';
import 'package:provider/provider.dart';

//Widgets
import '../widgets/nav_bar.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/all_habits_list.dart';

//Services
import '../services/profile_image.dart';

//Ventanas
import 'package:convivezen/screens/login_options.dart';
import 'package:convivezen/screens/exercises_detail.dart';
import 'package:convivezen/screens/days_detail.dart';
import 'package:convivezen/screens/events.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _selectedIndex = 2;
  //Incialiar image
  File? _image;
  final ProfileImageService _imageService = ProfileImageService();

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ExploreScreen(),
        ),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _showAlert(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Funcionalidad pendiente'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _changeProfileImage(AppState appState, User? user) async {
    final pickedImage = await _imageService.pickImage();
    if (pickedImage != null) {
      setState(() {
        _image = pickedImage;
      });
      // Mostrar diálogo de confirmación
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Confirmar cambio"),
            content: Text("¿Deseas actualizar tu foto de perfil?"),
            actions: <Widget>[
              TextButton(
                child: Text("Cancelar"),
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _image = null; // Limpiar imagen si se cancela
                  });
                },
              ),
              TextButton(
                child: Text("Aceptar"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  final imageUrl =
                      await _imageService.uploadImage(pickedImage, user!.uid);
                  if (imageUrl != null) {
                    await appState.updateProfileImage(imageUrl);
                    // Mostrar notificación de éxito
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Foto de perfil actualizada")),
                    );
                  } else {
                    // Mostrar notificación de error
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content:
                              Text("Error al actualizar la foto de perfil")),
                    );
                  }
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    var appState = Provider.of<AppState>(context);

    //Titulo Superior
    return Scaffold(
      backgroundColor: appState.isDarkMode ? Colors.black : Colors.grey[200],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Mi Perfil"),
        titleTextStyle: TextStyle(
          color: appState.isDarkMode ? Colors.white : Colors.black,
          fontSize: 20,
        ),
        backgroundColor: appState.isDarkMode ? Colors.grey[900] : Colors.white,
      ),

      //Body
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Sección 1: Perfil
            //Circulo para avatar
            Center(
              child: ProfileAvatar(
                imageFile: _image,
                imageUrl: user?.photoURL,
                onImageTap: () => _changeProfileImage(appState, user),
              ),
              //CircleAvatar(
              //  radius: 50,
              //  backgroundImage: user?.photoURL != null
              //      ? NetworkImage(user!.photoURL!)
              //      : null,
              //  child: user?.photoURL == null
              //      ? Icon(Icons.person, size: 50)
              //      : null,
              //),
            ),

            // Apartado del nombre
            SizedBox(height: 16),
            Center(
                child: Text(
              user?.displayName ?? 'Nombre no disponible',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: appState.isDarkMode ? Colors.white : Colors.black,
              ),
            )),

            //Apartado del correo
            SizedBox(height: 8),
            Center(
                child: Text(
              user?.email ?? 'Correo no disponible',
              style: TextStyle(
                fontSize: 16,
                color: appState.isDarkMode ? Colors.white70 : Colors.black54,
              ),
            )),

            SizedBox(height: 16),

            //Sección 2: Personalización
            Text("Personalización",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: appState.isDarkMode ? Colors.white : Colors.black,
                )),

            const SizedBox(height: 10),

            SizedBox(
              height: 300,
              child: GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1,
                physics: const BouncingScrollPhysics(),
                children: [
                  // Card de Habitos
                  MiniCard(
                    title: "Tus Hábitos",
                    icon: Icons.self_improvement,
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => AllHabitsList()));
                    },
                  ),

                  // Card de Ejercicios
                  MiniCard(
                    title: "Tus Ejercicios",
                    icon: Icons.fitness_center,
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => ExercisesDetail()));
                    },
                  ),

                  // Card de Dias
                  MiniCard(
                    title: "Tus Días",
                    icon: Icons.calendar_today,
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => DaysDetail()));
                    },
                  ),

                  // Card de Sports
                  MiniCard(
                    title: "Tus Deportes",
                    icon: Icons.sports_soccer,
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => SportDetail()));
                    },
                  ),
                ],
              ),
            ),

            Spacer(),

            // Modo oscuro
            ListTile(
              leading: Icon(
                appState.isDarkMode ? Icons.brightness_3 : Icons.brightness_7,
                color: appState.isDarkMode ? Colors.white : Colors.black,
              ),
              title: Text(
                "Modo Oscuro",
                style: TextStyle(
                  color: appState.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              trailing: Switch(
                value: appState.isDarkMode,
                onChanged: (value) {
                  appState.toggleDarkMode();
                },
              ),
            ),
            Divider(
                color: appState.isDarkMode ? Colors.white24 : Colors.black12),

            //Sección 3: Opciones
            // Botón cerrar sesión
            ListTile(
              leading: Icon(Icons.exit_to_app, color: Colors.red),
              title: Text("Cerrar sesión", style: TextStyle(color: Colors.red)),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text('Confirmar cierre de sesión'),
                    content: Text('¿Estás seguro de que deseas cerrar sesión?'),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Cancelar')),
                      TextButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          await FirebaseAuth.instance.signOut();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => LoginOptions()),
                            (_) => false,
                          );
                        },
                        child: Text('Cerrar sesión',
                            style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
              },
            ),

            // Botón eliminar cuenta
            ListTile(
              leading: Icon(Icons.delete_forever, color: Colors.red),
              title:
                  Text("Eliminar cuenta", style: TextStyle(color: Colors.red)),
              onTap: () {
                TextEditingController confirmationController =
                    TextEditingController();

                //Mostrar mensaje de confirmacion
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text('Eliminar cuenta'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Escribe 'estoy de acuerdo' para confirmar."),
                        TextField(controller: confirmationController),
                      ],
                    ),
                    //Acciones
                    actions: [
                      //Cancelar
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text("Cancelar")),

                      //Aceptar
                      TextButton(
                        onPressed: () async {
                          //Texto de confirmacion
                          if (confirmationController.text
                                  .trim()
                                  .toLowerCase() ==
                              "estoy de acuerdo") {
                            try {
                              //Funcionalidad de eliminar usuario
                              await Provider.of<AppState>(context,
                                      listen: false)
                                  .deleteUserAccount();
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        LoginOptions()), //redirecciona a login
                                (_) => false,
                              );
                            } catch (error) {
                              Navigator.pop(context); //Cerrar dialogo
                              _showAlert(
                                  "Error al eliminar cuenta: ${error.toString()}");
                            }
                          } else {
                            _showAlert(
                                "Debes escribir exactamente: estoy de acuerdo");
                          }
                        },
                        child: Text("Eliminar",
                            style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
