import 'package:flutter/material.dart';
import 'dart:async';

class BerandaPage extends StatefulWidget {
  const BerandaPage({super.key});

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  // Daftar gradient
  final List<List<Color>> gradientColors = [
    [Color(0xFF1B5E20), Color(0xFF388E3C), Color(0xFF66BB6A)],
    [Color(0xFF388E3C), Color(0xFF66BB6A), Color(0xFF1B5E20)],
    [Color(0xFF66BB6A), Color(0xFF1B5E20), Color(0xFF388E3C)],
  ];

  int index = 0;

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 4), (timer) {
      setState(() {
        index = (index + 1) % gradientColors.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(seconds: 3),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors[index],
        ),
      ),
      child: const Center(
        child: Text(
          "Beranda",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
