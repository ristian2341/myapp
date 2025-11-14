import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import 'package:my_apps/controllers/ProfileController.dart';
import 'package:flutter/foundation.dart';

class PasswordScreen extends StatelessWidget {
    PasswordScreen({super.key});
    final ProfileController c = Get.put(ProfileController());
    bool _isLoading = false;

    // helper textfield dengan label
    Widget _buildTextField({
      required TextEditingController controller,
      required String label,
      required String hint,
      bool isPassword = false,
      RxBool? isObscure, // 👈 tambahkan state GetX untuk kontrol
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
              child: Obx(() {
                return TextField(
                  controller: controller,
                  obscureText: isPassword ? isObscure?.value ?? true : false,
                  style: const TextStyle(
                    fontSize: 18.0,
                    color: Colors.black87,
                    fontStyle: FontStyle.italic,
                  ),
                  decoration: InputDecoration(
                    hintText: hint,
                    border: InputBorder.none,
                    suffixIcon: isPassword
                        ? IconButton(
                      icon: Icon(
                        isObscure!.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        isObscure.value = !isObscure.value;
                      },
                    )
                        : null,
                  ),
                );
              }),
            ),
          ],
        ),
      );
    }

    @override
    Widget build(BuildContext context) {
      final screenWidth = MediaQuery.of(context).size.width;

      final double formWidth = screenWidth < 600
          ? screenWidth * 0.9
          : screenWidth < 1000
          ? 700
          : 500;

      return Scaffold(
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              colors: [
                Colors.green.shade900,
                Colors.green.shade700,
                Colors.green.shade400
              ],
            ),
          ),
          child: Column(
            children: <Widget>[

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
                      "Ganti Password",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              // card login
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
                            controller: c.passwordLamaController,
                            label: "Password Laama",
                            hint: "Masukkan Username",
                            isPassword : true,
                            isObscure: c.isPasswordLamaObscure,
                          ),
                          _buildTextField(
                            controller: c.passwordBaruController,
                            label: "Password",
                            hint: "Masukkan Password",
                            isPassword : true,
                            isObscure: c.isPasswordBaruObscure,
                          ),
                          _buildTextField(
                            controller: c.rePasswordController,
                            label: "Confirm Password",
                            hint: "Masukkan Confirm Password",
                            isPassword: true,
                            isObscure: c.isRePasswordObscure,
                          ),
                          const SizedBox(height: 30),
                          Obx(() {
                            return SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange[900],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                // 👇 pastikan onPressed diberikan
                                onPressed:  c.isLoading.value
                                    ? null
                                    : () {
                                  if (c.passwordBaruController.text !=
                                      c.rePasswordController.text) {
                                    Get.snackbar(
                                      "Error",
                                      "Password baru dan konfirmasi tidak sama",
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                    );
                                    return;
                                  }

                                  if (c.passwordBaruController.text.isEmpty ||
                                      c.passwordLamaController.text.isEmpty) {
                                    Get.snackbar(
                                      "Error",
                                      "Password lama dan baru harus diisi",
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                    );
                                    return;
                                  }

                                  c.updatePassword(); // ✅ kalau sudah sesuai baru update
                                },
                                child: c.isLoading.value
                                    ? const CircularProgressIndicator(color: Colors.white)
                                    : const Text(
                                  "Save",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ),
                            );
                          }),
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