import 'package:flutter/material.dart';
import 'dart:io';
import 'package:get/get.dart';
import 'package:my_apps/controllers/HomeController.dart';
import 'package:my_apps/views/profile/profile_screen.dart';
import 'package:my_apps/views/profile/password_screen.dart';
import 'package:my_apps/views/master/rekening_page.dart';

class AkunPage extends StatefulWidget {
  const AkunPage({super.key});

  @override
  State<AkunPage> createState() => _AkunPageState();
}

class _AkunPageState extends State<AkunPage> {
  // ✅ Ambil controller yang sudah diinisialisasi di HomeScreen
  final HomeController c = Get.find<HomeController>();

  final List<List<Color>> gradientColors = [
    [Color(0xFF1B5E20), Color(0xFF388E3C), Color(0xFF66BB6A)],
    [Color(0xFF388E3C), Color(0xFF66BB6A), Color(0xFF1B5E20)],
    [Color(0xFF66BB6A), Color(0xFF1B5E20), Color(0xFF388E3C)],
  ];

  int index = 0;

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
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 10),
            _buildMenuSection('Pengaturan Profile', [
              _buildMenuItem(context, 'Update Profile', Icons.person,ProfileScreen()),
              _buildMenuItem(context, 'Update Password', Icons.password_rounded,PasswordScreen()),
            ]),
            const SizedBox(height: 10),
            _buildMenuSection("Data Bank", [
              _buildMenuItem(context, "Rekening Bank", Icons.account_balance, RekeningPage()),
            ]),
            const SizedBox(height: 10),
            _buildLogoutButton(context),
          ],
        ),
      ),
    );
  }

  // ✅ Reactive header dengan Obx agar otomatis update
  Widget _buildProfileHeader() {
    return Obx(() => Container(
      width: double.infinity, // tambahkan ini biar tidak infinite
      height: 100,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF3A853D),
            Color(0xFF61B567),
          ],
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor:
            c.photo.value.isEmpty ? const Color(0xFF1B5E20) : null,
            backgroundImage: c.photo.value.isNotEmpty
                ? (c.photo.value.startsWith("http")
                ? NetworkImage(c.photo.value)
                : FileImage(File(c.photo.value)))
                : null,
            child: c.photo.value.isEmpty
                ? const Icon(Icons.person, size: 40, color: Colors.blue)
                : null,
          ),
          const SizedBox(width: 12),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                c.nama_panggilan.value.isNotEmpty
                    ? c.nama_panggilan.value
                    : c.username.value,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                c.email.value.isNotEmpty
                    ? c.email.value
                    : "Email belum diatur",
                style: const TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    ));
  }


  Widget _buildMenuSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...items,
      ],
    );
  }

  Widget _buildMenuItem(BuildContext context, String title, IconData icon,Widget? page) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white54, // ✅ ganti sesuai selera (misal Colors.green[50])
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          if (page != null) {
            // ✅ kalau ada halaman, buka
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => page),
            );
          } else {
            // ✅ kalau kosong, hanya tampilkan snackbar
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Anda memilih: $title')),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            children: [
              Icon(icon, color: Colors.green[700]),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Icon(Icons.arrow_forward_ios,
                  size: 16, color: Colors.orange),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton.icon(
        onPressed: () {
          c.logout();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange[900],
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          minimumSize: const Size(double.infinity, 50),
        ),
        icon: const Icon(Icons.logout, color: Colors.white),
        label: const Text(
          'Log Out',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }
}
