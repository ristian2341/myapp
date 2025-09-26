import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:my_apps/controllers/HomeController.dart';
import 'package:my_apps/views/pages/beranda_page.dart';
import 'package:my_apps/views/pages/pesan_page.dart';
import 'package:my_apps/views/profile/profile_screen.dart';
import 'package:my_apps/main.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final pages = [
    BerandaPage(),
    PesanPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final HomeController c = Get.put(HomeController());
    final boxStorage = GetStorage();

    return Obx(() =>
        Scaffold(
          appBar: AppBar(
            title: Text(AppData.instansi),
            centerTitle: false,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF1B5E20),
                    Color(0xFF388E3C),
                  ],
                ),
              ),
            ),
          ),
          body: pages[c.selectedIndex.value],
          bottomNavigationBar: Stack(
            children: [
              Container(
                height: kBottomNavigationBarHeight,
                decoration: const BoxDecoration(
                  color: Color(0xFF1B5E20),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
              ),
              BottomNavigationBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.white70,
                type: BottomNavigationBarType.fixed,
                currentIndex: c.selectedIndex.value,
                onTap: (index) {
                  if (index == 2) {
                    // ambil posisi bottom bar
                    final RenderBox bar = context.findRenderObject() as RenderBox;
                    final Offset barOffset = bar.localToGlobal(Offset.zero);

                    // hitung lebar tiap item (karena 3 item)
                    final itemWidth = bar.size.width / 3;

                    // posisi item akun (index 2 = paling kanan)
                    final akunX = barOffset.dx + (itemWidth * 2);

                    // tampilkan menu di atas icon akun
                    showMenu(
                      context: context,
                      position: RelativeRect.fromLTRB(
                        akunX,
                        barOffset.dy - 120,// jarak vertikal biar muncul di atas bar
                        akunX + itemWidth,
                        0,
                      ),
                      items: [
                        PopupMenuItem(
                          value: 'profil',
                          child: Row(
                            children: const [
                              Icon(Icons.account_circle, color: Colors.black54),
                              SizedBox(width: 8),
                              Text("Profil"),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'password',
                          child: Row(
                            children: const [
                              Icon(Icons.settings, color: Colors.black54),
                              SizedBox(width: 8),
                              Text("Ganti Password"),
                            ],
                          ),
                        ),
                      ],
                    ).then((value) {
                      if (value == 'profil') {
                        Get.to(() => const ProfileScreen());
                      } else if (value == 'password') {
                        // TODO: ganti password
                      }
                    });
                  } else {
                    c.changeTab(index);
                  }
                },
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.home), label: "Beranda"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.message), label: "Pesan"),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.person), label: "Akun"),
                ],
              ),
            ],
          ),
          drawer: Drawer(
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
                              Colors.black54,
                              Colors.white24,
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 16,
                        left: 16,
                        child: Row(
                          children: [
                            const CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.white,
                              child: Icon(Icons.person,
                                  size: 40, color: Colors.blue),
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
                                    fontSize: 14,
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
                const Divider(),
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
          ),
        )
    );
  }
}
