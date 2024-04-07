import 'package:code_edit/ui/pages/config.dart';
import 'package:code_edit/ui/pages/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const PhantomApp());
}

class PhantomApp extends StatelessWidget {
  const PhantomApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Phantom DEV Tool',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amberAccent),
        useMaterial3: true,
      ),
      routes: {
        '/form': (context) => ConfigPage(),
        '/home': (context) => const HomePage(),
      },
      home: ConfigPage(),
    );
  }
}
