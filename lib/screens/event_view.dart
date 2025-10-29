import 'package:flutter/material.dart';
import 'package:convivezen/providers/app_state.dart';
import 'package:provider/provider.dart';

class EventViewScreen extends StatelessWidget {
  final String summary;
  final String location;
  final DateTime start;
  final DateTime end;

  const EventViewScreen({
    super.key,
    required this.summary,
    required this.location,
    required this.start,
    required this.end,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles del Evento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Evento: $summary', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 10),
            Text('Lugar: $location'),
            const SizedBox(height: 10),
            Text('Inicio: ${start.toLocal()}'),
            Text('Fin: ${end.toLocal()}'),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  final evento = Event(
                    summary: summary,
                    location: location,
                    start: start,
                  );

                  Provider.of<AppState>(context, listen: false).agregarEvento(evento);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Evento agregado exitosamente')),
                  );

                  Navigator.pop(context);
                },
                child: const Text('Agregar evento'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
