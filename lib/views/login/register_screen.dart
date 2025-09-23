import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenStated();
}

class _RegisterScreenStated extends State<RegisterScreen> {
  Future<void> registerUser(String username, String email, String phone,
      String namaPanggilan, String password) async {
    final respond = await http.post(
      Uri.parse("http://10.8.12.68:88/myflutterapi/users/registers"),
      body: {
        'username': username,
        'email': email,
        'phone': phone,
        'nama_panggilan': namaPanggilan,
        'password': password
      },
    );

    if (respond.statusCode == 201) {
      print('Berhasil register');
    } else {
      throw Exception('Gagal menambah anggota');
    }
  }

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController namaPanggilanController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;

  // helper textfield dengan label
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    bool isPassword = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: TextField(
              controller: controller,
              obscureText: isPassword,
              style: const TextStyle(
                  fontSize: 18.0,
                  color: Colors.black87,
                  fontStyle: FontStyle.italic),
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _clearFields() {
    usernameController.clear();
    emailController.clear();
    phoneController.clear();
    namaPanggilanController.clear();
    passwordController.clear();
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
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Register User",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                  BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        _buildTextField(
                          controller: usernameController,
                          label: "Username",
                          hint: "Masukkan Username",
                        ),
                        _buildTextField(
                          controller: emailController,
                          label: "Email",
                          hint: "Masukkan Email",
                        ),
                        _buildTextField(
                          controller: passwordController,
                          label: "Password",
                          hint: "Masukkan Password",
                          isPassword: true,
                        ),
                        _buildTextField(
                          controller: namaPanggilanController,
                          label: "Nama Panggilan",
                          hint: "Masukkan Nama Panggilan",
                        ),
                        _buildTextField(
                          controller: phoneController,
                          label: "Nomor HP",
                          hint: "Masukkan Nomor HP",
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
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                  ),
                                  onPressed: _isLoading
                                      ? null
                                      : () async {
                                    setState(() => _isLoading = true);
                                    try {
                                      await registerUser(
                                        usernameController.text,
                                        emailController.text,
                                        phoneController.text,
                                        namaPanggilanController.text,
                                        passwordController.text,
                                      );
                                      _clearFields();
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
                                      color: Colors.white)
                                      : const Text(
                                    "Save",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 15),
                              // tombol clear dengan konfirmasi
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
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
                                              _clearFields();
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
                                        fontSize: 18,
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
