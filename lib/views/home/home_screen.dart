import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_apps/controllers/HomeController.dart';
import 'package:my_apps/main.dart';
import 'package:my_apps/views/pages/beranda_page.dart';
import 'package:my_apps/views/pages/pesan_page.dart';
import 'package:my_apps/views/pages/profile_page.dart';
import 'package:get_storage/get_storage.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  final pages = const [
    BerandaPage(),
    PesanPage(),
    ProfilPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final HomeController c = Get.put(HomeController());
    final boxStorage = GetStorage();

    return Obx(() => Scaffold(
      appBar: AppBar(
        title: Text(AppData.instansi),
        centerTitle: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors : [
                  Color(0xFF27353C), // Colors.green.shade700
                  Color(0xFF616A61),
                ]
            ),
          )
        ),
      ),
      body: pages[c.selectedIndex.value],
      bottomNavigationBar: Stack(
        children: [
          // Layer gradient + shadow
          Container(
            height: kBottomNavigationBarHeight,
            decoration: BoxDecoration(
              color: Color(0xFF09390D),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(0),
                bottomRight: Radius.circular(0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26, // warna bayangan
                  offset: Offset(0, -2), // arah bayangan ke atas
                  blurRadius: 25
                  ,         // lembutnya bayangan
                ),
              ],
            ),
          ),

          // Layer BottomNavigationBar
          BottomNavigationBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white70,
            type: BottomNavigationBarType.fixed,
            currentIndex: c.selectedIndex.value,
            onTap: c.changeTab,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Beranda"),
              BottomNavigationBarItem(icon: Icon(Icons.message), label: "Pesan"),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
            ],
          ),
        ],
      ),
      // ✅ Tampilkan drawer hanya jika selectedIndex != 0 (Beranda)
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 120,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // 🎨 background gradient
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFF27353C), // hijau sedang
                          Color(0xFF616A61), // hijau muda
                          Color(0xFFD8F4DC), // hijau muda agak putih (30% opacity
                        ],
                      ),
                    ),
                  ),
                  // overlay gradient transparan biar teks tetap kebaca
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.2),
                          Colors.black.withOpacity(0.5),
                        ],
                      ),
                    ),
                  ),

                  // isi akun user
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.person, size: 40, color: Colors.blue),
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
                              (boxStorage.read("email") ?? "Email Not Set").toString(),
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // menu drawer
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
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text("Profil"),
              onTap: () {
                c.changeTab(2);
                Get.back();
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text("Logout"),
              onTap: () {
                c.logout();
              },
            ),
          ],
        ),
      ) ,
    ));
  }
}
