import 'package:flutter/material.dart';
import 'package:juego_movil/src/pages/PlayerProfileScreen.dart';
import './pages/home.dart';
import './pages/Lobby.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: Center(
        child: PlayerProfileScreen(),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'El Robo de Molly',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const Home(),
    );
  }
}   