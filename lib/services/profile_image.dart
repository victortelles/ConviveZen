import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';

class ProfileImageService {
  final picker = ImagePicker();

  // Método para seleccionar una imagen
  Future<File?> pickImage() async {
    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      print("Error picking image: $e");
      return null;
    }
  }

  // Método para subir la imagen a Firebase Storage
  Future<String?> uploadImage(File image, String uid) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('user_images')
          .child('${uid}_$timestamp.jpg'); //Nombre del archivo
      await ref.putFile(image);
      // Agregar un retraso antes de obtener la URL de la imagen.
      await Future.delayed(const Duration(seconds: 2));
      return await ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }
}
