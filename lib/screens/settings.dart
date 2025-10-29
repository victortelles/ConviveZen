// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../providers/app_state.dart';

// class Settings extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final appState = Provider.of<AppState>(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Modo Oscuro'),
//       ),
//       body: Center(
//         child: Switch(
//           value: appState.isDarkMode,
//           onChanged: (value) {
//             appState.toggleDarkMode();
//           },
//         ),
//       ),
//     );
//   }
// }
