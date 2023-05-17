import 'package:flutter/material.dart';

import 'auth_gate.dart';
import 'theme/angelcare_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      title: 'Angel Care',
      home: const AuthGate(),
    );
  }
}
