import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:convivezen/screens/auth/register.dart';
import 'package:convivezen/screens/onboarding/onboarding_flow.dart';
import '../../services/firebase.dart';
import 'widgets/lost_password.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLogin = true;
  bool _isLoading = false;

  Future<void> _loginOrRegister() async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (_isLogin) {
        // Login
        await _auth.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Verificar si el usuario existe en la base de datos
        final user = await _firestoreService.getCurrentUser();

        if (user != null) {
          // Navegar a la pantalla principal
          Navigator.of(context).pushReplacementNamed('/home');
        } else {
          // Si por alguna razón el usuario está autenticado pero no tiene datos en Firestore
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text("Error: Datos de usuario no encontrados")),
          );
        }
      } else {
        // Registro - solo autenticación
        await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Continuar con el flujo de personalización
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => OnboardingFlow(),
          ),
        );
      }
    } catch (e) {
      String errorMessage = "Error en la autenticación";
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'user-not-found':
            errorMessage = "Usuario no encontrado";
            break;
          case 'wrong-password':
            errorMessage = "Contraseña incorrecta";
            break;
          case 'email-already-in-use':
            errorMessage = "El correo ya está en uso";
            break;
          case 'invalid-email':
            errorMessage = "El formato de correo electrónico no es válido";
            break;
          case 'weak-password':
            errorMessage = "La contraseña es muy débil";
            break;
          default:
            errorMessage = "Error: ${e.code}";
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 155, 188),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text(
                _isLogin ? "Iniciar Sesión" : "Crear Cuenta",
                style: GoogleFonts.archivo(
                  textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                _isLogin
                    ? "Accede a tu cuenta para continuar"
                    : "Crea una cuenta para comenzar tu viaje fitness",
                style: GoogleFonts.archivo(
                  textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(height: 40),
              _buildTextField(
                "Correo electrónico",
                _emailController,
                Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16),
              _buildTextField(
                "Contraseña",
                _passwordController,
                Icons.lock,
                obscureText: true,
              ),
              if (_isLogin)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // Implementar recuperación de contraseña del widget lost_password
                      showDialog(context: context,
                        builder: (context) => LostPassword(),
                      );
                    },
                    child: Text(
                      "¿Olvidaste tu contraseña?",
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
                ),
              SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _isLoading ? null : _loginOrRegister,
                  child: _isLoading
                      ? CircularProgressIndicator()
                      : Text(
                          _isLogin ? "Iniciar Sesión" : "Registrarse",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 255, 155, 188),
                          ),
                        ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _isLogin
                        ? "¿No tienes una cuenta? "
                        : "¿Ya tienes una cuenta? ",
                    style: TextStyle(color: Colors.black),
                  ),
                  //Redireccion a Registrarse
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              const Register(), // Redirige a la pantalla de registro
                        ),
                      );
                    },
                    //Texto
                    child: Text(
                      "Regístrate",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
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

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    IconData icon, {
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.black38),
          prefixIcon: Icon(icon, color: Colors.black38),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }
}
