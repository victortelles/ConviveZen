import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:convivezen/screens/event_view.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScanner extends StatefulWidget {
  const QrScanner({super.key});

  @override
  State<QrScanner> createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanea el QR'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.popAndPushNamed(context, "/generate");
            },
            icon: const Icon(
              Icons.qr_code,
            )
          )
        ]
      ),
      body: MobileScanner(
        controller: MobileScannerController(
          detectionSpeed: DetectionSpeed.noDuplicates,
          returnImage: false,
        ),
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;

          for (final barcode in barcodes) {
            final String? rawValue = barcode.rawValue;

            if (rawValue != null) {
              if (rawValue.startsWith('BEGIN:VEVENT')) {
                final lines = rawValue.split('\n');

                String? summary, location;
                DateTime? start, end;

                for (var line in lines) {
                  if (line.startsWith('SUMMARY:')) {
                    summary = line.substring(8).trim();
                  } else if (line.startsWith('LOCATION:')) {
                    location = line.substring(9).trim();
                  } else if (line.startsWith('DTSTART:')) {
                    start = DateTime.tryParse(line.substring(8).trim());
                  } else if (line.startsWith('DTEND:')) {
                    end = DateTime.tryParse(line.substring(6).trim());
                  }
                }

                if (summary != null && location != null && start != null && end != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EventViewScreen(
                        summary: summary!,
                        location: location!,
                        start: start!,
                        end: end!,
                      ),
                    ),
                  );
                } else {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Error al leer evento'),
                      content: const Text('Faltan datos en el QR.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cerrar'),
                        )
                      ],
                    ),
                  );
                }
              } else {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Código QR inválido detectado'),
                    content: Text(rawValue),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cerrar'),
                      ),
                    ],
                  ),
                );
              }
              break;
            }
          }
        },
      ),
    );
  }
}