import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_apps/controllers/ProfileController.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenStated();
}

class _ProfileScreenStated extends State<ProfileScreen> {
  final ProfileController c = Get.put(ProfileController());
  bool _isLoading = false;

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    bool isPassword = false,
    bool readOnly = false,   // 👈 default false
    bool enabled = true,     // 👈 default true
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        readOnly: readOnly,
        enabled: enabled,
        style: const TextStyle(
          fontSize: 16.0,
          color: Colors.black87,
          fontStyle: FontStyle.italic,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle( // 👈 label warna hitam
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
          hintText: hint,
          hintStyle: const TextStyle( // 👈 hint abu-abu
            color: Colors.grey,
            fontSize: 14,
          ),
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.green.shade600, width: 2),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter, colors: [
            Colors.green.shade900,
            Colors.green.shade700,
            Colors.green.shade400
          ]),
        ),
        child: Column(
          children: [
            const SizedBox(height: 50),
            // 🔹 Foto profil + label
            FadeInDown(
              duration: const Duration(milliseconds: 800),
              child: Column(
                children: const [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Profile",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        _buildTextField(
                          controller: c.usernameController,
                          label: "Username",
                          hint: "Masukkan Username",
                          readOnly: true,
                        ),
                        _buildTextField(
                          controller: c.emailController,
                          label: "Email",
                          hint: "Masukkan Email",
                        ),
                        _buildTextField(
                          controller: c.namaPanggilanController,
                          label: "Nama Panggilan",
                          hint: "Masukkan Nama Panggilan",
                        ),
                        _buildTextField(
                          controller: c.namaLengkapController,
                          label: "Nama Lengkap",
                          hint: "Nama Lengkap",
                        ),
                        _buildTextField(
                          controller: c.phoneController,
                          label: "Nomor HP",
                          hint: "Masukkan Nomor HP",
                        ),
                        _buildTextField(
                          controller: c.alamatController,
                          label: "Alamat",
                          hint: "Alamat",
                        ),
                        _buildTextField(
                          controller: c.kotaController,
                          label: "Kota",
                          hint: "Kota",
                        ),
                        _buildTextField(
                          controller: c.propinsiController,
                          label: "Propinsi",
                          hint: "Propinsi",
                        ),
                        _buildTextField(
                          controller: c.facebookController,
                          label: "Facebook",
                          hint: "Facebook",
                        ),
                        _buildTextField(
                          controller: c.instagramController,
                          label: "Instagram",
                          hint: "Instagram",
                        ),
                        _buildTextField(
                          controller: c.tiktokController,
                          label: "Titok",
                          hint: "Titok",
                        ),
                        const SizedBox(height: 30),
                        FadeInUp(
                          duration: const Duration(milliseconds: 1600),
                          child: Column(
                            children: [
                              // tombol save
                              SizedBox(
                                width: double.infinity,
                                height: 55,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green[600],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: _isLoading
                                      ? null
                                      : () async {
                                    setState(() => _isLoading = true);
                                    try {
                                        c.clearFields();
                                      Get.snackbar("Sukses",
                                          "Registrasi berhasil",
                                          snackPosition:
                                          SnackPosition.BOTTOM,
                                          backgroundColor: Colors.green
                                              .withOpacity(0.7),
                                          colorText: Colors.white);
                                    } catch (e) {
                                      Get.snackbar(
                                          "Error", "Gagal register: $e",
                                          snackPosition:
                                          SnackPosition.BOTTOM,
                                          backgroundColor: Colors.red
                                              .withOpacity(0.7),
                                          colorText: Colors.white);
                                    } finally {
                                      setState(() => _isLoading = false);
                                    }
                                  },
                                  child: _isLoading
                                      ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                      : const Text(
                                    "Save",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              // tombol clear
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    side: BorderSide(color: Colors.green[600]!),
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: const Text("Konfirmasi"),
                                        content: const Text(
                                            "Apakah Anda yakin ingin menghapus semua input?"),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(ctx).pop(),
                                            child: const Text("Batal"),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(ctx).pop();
                                              c.clearFields();
                                              Get.snackbar(
                                                "Cleared",
                                                "Semua field sudah dikosongkan",
                                                snackPosition:
                                                SnackPosition.BOTTOM,
                                                backgroundColor: Colors.orange
                                                    .withOpacity(0.7),
                                                colorText: Colors.white,
                                              );
                                            },
                                            child: const Text(
                                              "Ya",
                                              style:
                                              TextStyle(color: Colors.red),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    "Clear Fields",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.green),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
