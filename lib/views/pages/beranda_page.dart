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
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (mounted) { // cek dulu widget masih hidup
        setState(() {
          index = (index + 1) % gradientColors.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // hentikan timer
    super.dispose();
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
          "aeeeeehhhhheee",
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
