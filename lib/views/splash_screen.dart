import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:my_apps/controllers/LoginController.dart';
import 'package:my_apps/views/login/login_screen.dart';
import 'package:my_apps/views/home/home_screen.dart';
import 'package:my_apps/main.dart'; // AppData

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _checkConnectionAndNavigate();
  }

  Future<void> _checkConnectionAndNavigate() async {
    bool serverOk = await _pingServer();

    if (!serverOk) {
      _showErrorAndExit("Tidak dapat terhubung ke server.");
      return;
    }

    // jika server OK, delay sebentar baru navigasi
    Future.delayed(const Duration(seconds: 2), () {
      final isLoggedIn = false; // bisa ambil dari storage/GetStorage
      if (isLoggedIn) {
        Get.offAll(() => const HomePage(),
            transition: Transition.fadeIn,
            duration: const Duration(milliseconds: 800));
      } else {
        Get.offAll(() => LoginScreen(),
            transition: Transition.rightToLeftWithFade,
            duration: const Duration(milliseconds: 800));
      }
    });
  }

  Future<bool> _pingServer() async {
    try {
      // cek internet
      final result = await InternetAddress.lookup('google.com');
      if (result.isEmpty || result[0].rawAddress.isEmpty) return false;

      // ping server
      final res = await http
          .get(Uri.parse("http://10.8.12.68:88/myflutterapi/ping"))
          .timeout(const Duration(seconds: 5));
      print(res);
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return data["status"] == "ok";
      }

      return false;
    } on SocketException {
      return false;
    } on TimeoutException {
      return false;
    } catch (e) {
      return false;
    }
  }

  void _showErrorAndExit(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("Koneksi Gagal"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => exit(0), // keluar aplikasi
            child: const Text("Tutup"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [
              Colors.green.shade900,
              Colors.green.shade700,
              Colors.green.shade400,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (AppData.logoApp.isNotEmpty)
                ClipOval(
                  child: Image.network(
                    AppData.logoApp,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const CircularProgressIndicator(color: Colors.white);
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.error, color: Colors.red, size: 50);
                    },
                  ),
                )
              else
                const FlutterLogo(size: 100),
              const SizedBox(height: 20),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
              const SizedBox(height: 10),
              Text(
                AppData.namaAplikasi.isNotEmpty ? AppData.namaAplikasi : "My Apps",
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
