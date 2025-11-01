import 'package:flutter/material.dart';
import 'package:convivezen/services/auth.dart';

class LostPassword extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Restablecer contraseña'),
      content: TextField(
        controller: emailController,
        decoration: InputDecoration(
          labelText: 'Correo electrónico',
          hintText: 'Introduce tu correo',
        ),
      ),
      actions: [
        //Botón Cancelar
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancelar'),
        ),

        //Botón Enviar
        TextButton(
          onPressed: () {
            final email = emailController.text.trim();
            if (email.isNotEmpty) {
              AuthService().resetPassword(email: email, context: context);

              //Mostrar mensaje de confirmación
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Por favor revise su correo, para restablecer la contraseña'),
                  duration: Duration(seconds: 5),
                ),
              );

              Navigator.of(context).pop(); //cerrar dialogo
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Por favor, introduce un correo válido.'),
                ),
              );
            }
          },
          child: Text('Enviar'),
        ),
      ],
    );
  }
}
