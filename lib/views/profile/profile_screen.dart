import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import 'package:my_apps/controllers/ProfileController.dart';
import 'package:flutter/foundation.dart';
import 'package:my_apps/widgets/form_widget.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});
  final ProfileController c = Get.put(ProfileController());

  void _showImagePicker() {
    final bool canUseCamera = !kIsWeb &&
        (Platform.isAndroid || Platform.isIOS);

    Get.bottomSheet(
      Center(
        child: Container(
          width: 300,
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(10),
          child: Wrap(
            children: [
              if (canUseCamera)
                ListTile(
                  leading: const Icon(Icons.camera_alt, color: Colors.white),
                  title: const Text('Camera', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    c.pickImage(fromCamera: true);
                    Get.back();
                  },
                ),
              ListTile(
                leading: const Icon(Icons.photo, color: Colors.white),
                title: const Text('Gallery', style: TextStyle(color: Colors.white)),
                onTap: () {
                  c.pickImage(fromCamera: false);
                  Get.back();
                },
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      isDismissible: true,
    );
  }


  void openProfileImagePicker() {
    Get.dialog(
      Center(
        child: Container(
          width: 300, // lebar kotak
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Pilih Sumber Foto",
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              if (!kIsWeb && (Platform.isAndroid || Platform.isIOS))
                Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.camera_alt, color: Colors.white),
                      title: const Text("Camera", style: TextStyle(color: Colors.white)),
                      onTap: () {
                        c.pickImage(fromCamera: true);
                        Get.back();
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.photo, color: Colors.white),
                      title: const Text("Gallery", style: TextStyle(color: Colors.white)),
                      onTap: () {
                        c.pickImage(fromCamera: false);
                        Get.back();
                      },
                    ),
                  ],
                ),
              if (kIsWeb || Platform.isWindows || Platform.isLinux || Platform.isMacOS)
                ListTile(
                  leading: const Icon(Icons.photo, color: Colors.white),
                  title: const Text("Gallery", style: TextStyle(color: Colors.white)),
                  onTap: () {
                    c.pickImage(fromCamera: false);
                    Get.back();
                  },
                ),
              const SizedBox(height: 5),
              TextButton(
                onPressed: () => Get.back(),
                child: const Text("Batal", style: TextStyle(color: Colors.redAccent)),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade900, Colors.green.shade700, Colors.green.shade400],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),

            // Back button + title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context)),
                  const SizedBox(width: 8),
                  const Text("Profile",
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Avatar
            FadeInDown(
              child: Stack(
                children: [
                  Obx(() {
                    if (c.profileImage.value != null) {
                      return CircleAvatar(
                        radius: 50,
                        backgroundImage: FileImage(c.profileImage.value!),
                      );
                    } else if (c.profilePhotoUrl.value.isNotEmpty) {
                      return CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(c.profilePhotoUrl.value),
                      );
                    } else {
                      return const CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, size: 60, color: Colors.green),
                      );
                    }
                  }),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: () {
                        Get.bottomSheet(
                          Center(
                            child: Container(
                              width: 300,
                              decoration: BoxDecoration(
                                color: Colors.grey[900],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.all(10),
                              child: Wrap(
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.camera_alt, color: Colors.white),
                                    title: const Text('Camera', style: TextStyle(color: Colors.white)),
                                    onTap: () {
                                      c.pickImage(fromCamera: true);
                                      Get.back();
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.photo, color: Colors.white),
                                    title: const Text('Gallery', style: TextStyle(color: Colors.white)),
                                    onTap: () {
                                      c.pickImage(fromCamera: false);
                                      Get.back();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          backgroundColor: Colors.transparent,
                          isDismissible: true,
                        );
                      },
                      child: const CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.camera_alt, size: 20, color: Colors.green),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Form
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25), topRight: Radius.circular(25)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        buildTextField(
                            controller: c.usernameController,
                            label: "Username",
                            hint: "Masukkan Username",
                            readOnly: true),
                        buildTextField(
                            controller: c.emailController,
                            label: "Email",
                            hint: "Masukkan Email",
                        ),
                        buildTextField(
                            controller: c.namaPanggilanController,
                            label: "Nama Panggilan",
                            hint: "Masukkan Nama Panggilan"),
                        buildTextField(
                            controller: c.namaLengkapController,
                            label: "Nama Lengkap",
                            hint: "Nama Lengkap"),
                        buildDateField(
                            controller: c.tglLahirController,
                            label: "Tanggal Lahir",
                            hint: "Tanggal Lahir",
                            context: context,
                        ),
                        Obx(() => buildOptionBox(
                          label: "Jenis Kelamin",
                          options: c.genderOptions,
                          groupValue: c.jenKel.value,   // <- wajib pakai .value, karena RxString
                          onChanged: (val) {
                            if (val != null) {
                              c.jenKel.value = val;
                              c.jenKelController.text = val;
                            }
                          },
                        )),
                        buildTextField(
                            controller: c.phoneController,
                            label: "Nomor HP",
                            hint: "Masukkan Nomor HP"),
                        buildTextField(
                            controller: c.alamatController, label: "Alamat", hint: "Alamat"),
                        buildTextField(controller: c.kotaController, label: "Kota", hint: "Kota"),
                        buildTextField(
                            controller: c.propinsiController, label: "Propinsi", hint: "Propinsi"),
                        buildTextField(
                            controller: c.facebookController, label: "Facebook", hint: "Facebook"),
                        buildTextField(
                            controller: c.instagramController, label: "Instagram", hint: "Instagram"),
                        buildTextField(
                            controller: c.tiktokController, label: "TikTok", hint: "TikTok"),
                        const SizedBox(height: 20),
                        Obx(() {
                          return SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange[900], // 🔹 ubah warna jadi orange
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: c.isLoading.value ? null : c.updateUserProfile,
                              child: c.isLoading.value
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : const Text("Save",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54)),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
