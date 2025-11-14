import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:my_apps/controllers/HomeController.dart';
import 'package:my_apps/views/pages/akun_page.dart';
import 'package:my_apps/main.dart';
import 'dart:ui';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:my_apps/views/pages/beranda_page.dart';
import 'package:my_apps/views/pages/pesan_page.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final List<Widget> pages = [
    BerandaPage(),
    PesanPage(),
    Center(child: Text("Transaksi", style: TextStyle(color: Colors.white))),
    AkunPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final HomeController c = Get.put(HomeController());
    final boxStorage = GetStorage();
    String? photo = boxStorage.read("photoProfile");

    return Obx(() =>
        Scaffold(
          body: Stack(
            children: [
              // 🌿 GRADIENT BACKGROUND — penuh 1 layar
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF0F3D13), // hijau tua atas
                      Color(0xFF1B5E20), // hijau utama
                      Color(0xFF61B567), // hijau lembut bawah
                    ],
                  ),
                ),
              ),

              // 🌿 APPBAR CUSTOM (tanpa batas dengan body)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.only(top: 20, left: 16, right: 16, bottom: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1B5E20).withOpacity(0.95), // sedikit transparan agar nyatu
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(25),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      if (AppData.logoApp.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            AppData.logoApp,
                            width: 38,
                            height: 38,
                            fit: BoxFit.cover,
                          ),
                        ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          AppData.instansi,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 20,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.notifications, color: Colors.white),
                        onPressed: () {
                          // contoh: buka halaman Notifikasi
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(builder: (context) => NotifikasiPage()),
                          // );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // 🌿 BODY (nyatu ke bawah AppBar)
              Container(
                margin: const EdgeInsets.only(top: 90), // tinggi AppBar
                decoration: BoxDecoration(
                  color: Colors.green[800], // lembut nyatu
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.05),
                    width: 1,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
                  child: pages[c.selectedIndex.value],
                ),
              ),
            ],
          ),
          bottomNavigationBar: Obx(() => CurvedNavigationBar(
              index: c.selectedIndex.value,
              backgroundColor: const Color(0xFF1B5E20),
              color: Colors.green[800]!,
              buttonBackgroundColor: Colors.greenAccent[700],
              height: 50,
              animationDuration: const Duration(milliseconds: 400),
              animationCurve: Curves.bounceInOut,
              items: [
                _buildAnimatedIcon(Icons.home, c.selectedIndex.value == 0),
                _buildAnimatedIcon(Icons.local_activity, c.selectedIndex.value == 2),
                _buildAnimatedIcon(Icons.account_balance_wallet_sharp, c.selectedIndex.value == 1),
                _buildAnimatedIcon(Icons.person, c.selectedIndex.value == 3),
              ],
              onTap: (index) => c.changeTab(index),
            ),
          ),
          /*
          drawer: Drawer(
            backgroundColor: Color(0xFF1B5E20),
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                SizedBox(
                  height: 120,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        width: double.infinity,
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
                      ),
                      Positioned(
                        bottom: 16,
                        left: 16,
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: (photo == null || photo.isEmpty) ? Color(0xFF1B5E20) : null,
                              backgroundImage: (photo != null && photo.isNotEmpty)
                                  ? (photo.startsWith("http")
                                  ? NetworkImage(photo) as ImageProvider
                                  : FileImage(File(photo)))
                                  : null,
                              child:  (photo == null || photo.isEmpty)
                                  ? const Icon(Icons.person, size: 40, color: Colors.blue)
                                  : null,
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  (boxStorage.read("nama_panggilan") ??
                                      boxStorage.read("username"))
                                      .toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  (boxStorage.read("email") ?? "Email Not Set")
                                      .toString(),
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
                      ),
                    ],
                  ),
                ),

                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text("Beranda"),
                  onTap: () {
                    c.changeTab(0);
                    Get.back();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.message),
                  title: const Text("Pesan"),
                  onTap: () {
                    c.changeTab(1);
                    Get.back();
                  },
                ),
                const Divider(
                  color: Colors.black,
                ),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text("Logout"),
                  onTap: () {
                    Get.back();
                    c.logout();
                  },
                ),
              ],
            ),
          ),*/
        )
    );
  }

  Widget _buildAnimatedIcon(IconData icon, bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      padding: EdgeInsets.all(isActive ? 12 : 8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? Colors.green[700] : Colors.green[900],
        boxShadow: isActive
            ? [
          BoxShadow(
            color: Colors.greenAccent.withOpacity(0.6),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 3),
          ),
        ]
            : [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Icon(icon, color: Colors.white70, size: isActive ? 28 : 24),
    );
  }
}
