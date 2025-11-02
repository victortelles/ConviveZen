import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:convivezen/services/auth.dart';
//Widgets
import 'package:convivezen/widgets/animated_logo.dart';
//Ventanas
import 'login.dart';
import 'register.dart';

class LoginOptions extends StatefulWidget {
  const LoginOptions({super.key});

  @override
  State<LoginOptions> createState() => _LoginOptionsState();
}

class _LoginOptionsState extends State<LoginOptions> {
  //Inicializar servicio de auth
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Verificar si ya hay un usuario autenticado
    _authService.checkCurrentUser(context);
  }

  //Llamada al servicio de Auth (AuthGoogle)
  void _signInWithGoogle() {
    _authService.signInWithGoogle(context, (loading){
      setState(() {
        _isLoading = loading;
      });
    });
  }

  // Metodo para ir a la pantalla de login con email
  void _goToEmailLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Register()),
    );
  }

  // Metodo para ir a la pantalla de login
  void _goToLoginScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 155, 188),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.white))
          : Builder(builder: (context) {
              return Center(
                child: Column(
                  children: [

                    //Logo animado
                    const AnimatedLogo(
                      imagePath: 'assets/images/splash/logo.png',
                      size: 350,
                    ),

                    //Espaciado
                    SizedBox(height: 50),

                    //Contenido
                    Row(
                      children: [
                        //Titulo
                        Padding(
                          padding: const EdgeInsets.fromLTRB(25.0, 0, 0, 0),
                          child: Text("Bienvenid@ a ConviveZen",
                              style: GoogleFonts.archivo(
                                  textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold))),
                        ),
                      ],
                    ),

                    //Descripcion
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(25.8, 0, 0, 0),
                        ),
                        Text(
                            "Respira profundo, aquí comienza tu espacio de calma.",
                            style: GoogleFonts.archivo(
                                textStyle: TextStyle(
                                    color: Colors.black, fontSize: 15)))
                      ],
                    ),

                    SizedBox(height: 50),
                    // Botón para iniciar sesión con email
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 8, 20.0, 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                              child: SizedBox(
                            height: 50,
                            child: ElevatedButton(
                              onPressed:
                                  _goToLoginScreen, // Usar la nueva pantalla de login
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),

                              //Iniciar sesion
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child:
                                        Icon(Icons.email, color: Colors.black),
                                  ),
                                  Text(
                                    "Iniciar Sesion",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ))
                        ],
                      ),
                    ),

                    // Botón para registrarse
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 0, 20.0, 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                              child: SizedBox(
                            height: 50,
                            child: TextButton(
                              onPressed: _goToEmailLogin,
                              child: Text(
                                "¿No tienes cuenta? Regístrate",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ))
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    // Botones de redes sociales
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //Boton para iniciar con Apple
//                          SocialButton(
//                            icon: "apple",
//                            onPressed: () {
//                              ScaffoldMessenger.of(context).showSnackBar(
//                                SnackBar(
//                                  duration: Duration(seconds: 2),
//                                  content: Text("Inicio con Apple ID (por implementar)"),
//                                )
//                              );
//                            },
//                          ),
                        //Boton de google
                        SocialButton(
                          icon: "google",
                          onPressed: _signInWithGoogle,
                        ),
//Boton para iniciar sesion con facbook
//                          SocialButton(
//                            icon: "facebook",
//                            onPressed: () {
//                              ScaffoldMessenger.of(context).showSnackBar(
//                                SnackBar(
//                                  duration: Duration(seconds: 2),
//                                  content: Text("Inicio con Facebook (por implementar)"),
//                                )
//                              );
//                            },
//                          ),
                      ],
                    ),
                    //Terminos y condiciones
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TermsAndConditionsScreen(),
                            ),
                          );
                        },
                        child: Text(
                          "Al registrarte aceptas los Términos y Condiciones",
                          style: TextStyle(
                            color: Colors.black,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            }),
    );
  }
}

// Widget para los botones de redes sociales
class SocialButton extends StatelessWidget {
  final String icon;
  final VoidCallback onPressed;

  const SocialButton({
    Key? key,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IconData iconData;

    switch (icon) {
//      case "apple":
//        iconData = Icons.apple;
//        break;
      case "google":
        iconData = Icons.g_mobiledata;
        break;
      case "facebook":
      //       iconData = Icons.facebook;
      //       break;
      default:
        iconData = Icons.login;
    }

    return SizedBox(
      width: 60,
      height: 60,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: CircleBorder(),
          padding: EdgeInsets.all(12),
        ),
        child: Icon(iconData, color: Colors.black, size: 30),
      ),
    );
  }
}

// Añadir un PDF genérico para términos y condiciones
class TermsAndConditionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Términos y Condiciones'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Términos y Condiciones\n\nPor favor lee nuestros términos y condiciones antes de continuar.\n\n[Contenido de términos aquí]',
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
