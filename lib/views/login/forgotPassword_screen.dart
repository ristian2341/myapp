import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_apps/main.dart';
import 'package:my_apps/views/login/login_screen.dart';
import 'package:my_apps/widgets/form_widget.dart';
import 'package:animate_do/animate_do.dart';
import 'package:get_storage/get_storage.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ForgotPasswordScreen();
}

class _ForgotPasswordScreen extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;

  Future<void> sendVerifikasi(String email) async {
    try {
      final respond = await http.post(
        Uri.parse("${AppData.base_url}/users/forgot_password"),
        body: {
          'email': email,
        },
      );

      final data = jsonDecode(respond.body);
      final storage = GetStorage();
      if (data['status'] == true) {
        Get.snackbar("Success", data['message'],
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white);

        // set email dan access token from tabel user //
        storage.write("email", data['data']['email']);
        storage.write("access_token", data['data']['access_token']);
        storage.write("code", data['data']['verify_code']);

        // langsung pindah ke halaman reset password
        Get.to(() => ResetPasswordScreen(email: email,message: data['message']));
      } else {
        Get.snackbar("Error", data['message'],
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } catch (e) {
      print(e);
      Get.snackbar("Error", "Terjadi kesalahan",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = false;
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
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    "Forgot Password",
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
                        buildTextField(
                          controller: emailController,
                          label: "Email",
                          hint: "Masukan Email yang terdaftar",
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
                                  onPressed: () {
                                    sendVerifikasi(emailController.text.trim());
                                  } , // disable tombol saat loading
                                  child: isLoading
                                      ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                      : const Text(
                                    "Send Verifikasi",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]
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

// ===================== Reset Password Screen =====================
class ResetPasswordScreen extends StatefulWidget {
  final String email;
  final String message;

  const ResetPasswordScreen({super.key, required this.email,required this.message});
  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController kodeController = TextEditingController();
  final TextEditingController passwordBaruController = TextEditingController();
  final TextEditingController rePasswordBaruController = TextEditingController();
  bool isLoading = false;
  final storage = GetStorage();

  Future<void> resetPassword() async {
    if (passwordBaruController.text != rePasswordBaruController.text) {
      Get.snackbar("Error", "Password tidak sama",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    if(kodeController.text == storage.read("code")){
      Get.snackbar("Error", "Kode Verifikasi tidak sama. coba cek email anda",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    try {
      final respond = await http.post(
        Uri.parse("${AppData.base_url}/users/reset_password"),
        body: {
          'email': widget.email,
          'verify_code': kodeController.text,
          'password': passwordBaruController.text,
          're_password': rePasswordBaruController.text,
          'access_token': storage.read("access_token"),
        },
      );

      final data = jsonDecode(respond.body);

      if (data['status'] == true) {
        Get.snackbar("Success", data['message'],
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white);

        Get.to(() => LoginScreen()); // balik ke halaman login
      } else {
        Get.snackbar("Error", data['message'],
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", "Terjadi kesalahan",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
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
                    "Forgot Password",
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
                        buildTextField(
                          controller: kodeController,
                          label: "Kode Verifikasi",
                          hint: "Masukan Kode Verifikasi dari email",
                        ),
                        buildPasswordField(
                          controller: passwordBaruController,
                          label: "Password Baru",
                          hint: "Masukan Password baru",
                          isObscure : true.obs,

                        ),
                        buildPasswordField(
                          controller: rePasswordBaruController,
                          label: "Retype Password",
                          hint: "Ketik Ulang password",
                          isObscure : true.obs,

                        ),
                        const SizedBox(height: 30),
                        FadeInUp(
                          duration: const Duration(milliseconds: 1600),
                          child: Column(
                            children: [
                              // ✅ Tombol Save & Login disamping
                              Row(
                                children: [
                                  // Tombol Save
                                  Expanded(
                                    child: SizedBox(
                                      height: 55,
                                      child: buildSaveButton(
                                        onPressed: () async {
                                          if (kodeController.text.isEmpty) {
                                            Get.snackbar("Error", "Kode verifikasi tidak boleh kosong");
                                            return;
                                          }
                                          if (passwordBaruController.text.isEmpty ||
                                              rePasswordBaruController.text.isEmpty) {
                                            Get.snackbar("Error", "Password tidak boleh kosong");
                                            return;
                                          }
                                          if (passwordBaruController.text !=
                                              rePasswordBaruController.text) {
                                            Get.snackbar("Error", "Password dan retype tidak sama");
                                            return;
                                          }

                                          await resetPassword();
                                          Get.snackbar("Sukses", "Password berhasil direset",
                                              backgroundColor: Colors.green.withOpacity(0.7),
                                              colorText: Colors.white);
                                        },
                                        label: "Save",
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  // Tombol Login
                                  Expanded(
                                    child: SizedBox(
                                      height: 55,
                                      child: buildUpdateButton(
                                        onPressed: () async {
                                          Get.to(() => LoginScreen());
                                        },
                                        label: "Login"
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 30),

                              // ✅ Pesan tambahan
                              SizedBox(
                                width: double.infinity,
                                height: 20,
                                child: Text(
                                  widget.message,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),

                        ),
                      ]
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
