import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

// Widget para mostrar un archivo PDF desde los activos
class PDFViewerWidget extends StatelessWidget {
  final String assetPath;

  PDFViewerWidget({required this.assetPath});

  // Carga el archivo PDF desde los activos y lo guarda temporalmente
  Future<String> _loadPdfFromAssets() async {
    try {
      final byteData = await rootBundle.load(assetPath);
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/temp_pdf.pdf');
      await tempFile.writeAsBytes(byteData.buffer.asUint8List());
      return tempFile.path;
    } catch (e) {
      throw Exception('Error al cargar el PDF: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _loadPdfFromAssets(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error al cargar el PDF'));
        } else {
          // Muestra el PDF usando PDFView
          return PDFView(
            //controles de pdfview
            filePath: snapshot.data,
            enableSwipe: true,
            swipeHorizontal: false,     //Movimiento scroll vertical
            autoSpacing: false,
            pageFling: true,
            fitEachPage: true,
            fitPolicy: FitPolicy.BOTH //Ajustar al ancho y alto de la pantalla
          );
        }
      },
    );
  }
}