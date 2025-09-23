import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:my_apps/views/home/home_screen.dart';

class LoginController extends GetxController {
  var isLoading = false.obs;
  final emailController = TextEditingController();
  final passController = TextEditingController();

  var isPasswordHidden = true.obs; // untuk toggle eye icon
  final boxStorage = GetStorage();
  final usernameFocus = FocusNode();

  Future<void> login() async {
    if (emailController.text.isEmpty || passController.text.isEmpty) {
        Get.snackbar("Error", "Harap isi email dan password");
        return;
    }

    isLoading.value = true;
    try {
      final res = await http.post(
        Uri.parse("http://10.8.12.68:88/myflutterapi/users/login"),
        body: {
          "user_name": emailController.text,
          "password": passController.text,
        },
      );

      var data = jsonDecode(res.body);
      if (data['statusCode'] == 200) {
        if (data['data']['username'] == emailController.text) {
              emailController.clear();
              passController.clear();
              boxStorage.write("username", data['data']['username']);
              boxStorage.write("code_user", data['data']['code']);
              boxStorage.write("access_token", data['data']['access_token']);
              boxStorage.write("developer", data['data']['developer']);
              boxStorage.write("supervisor", data['data']['supervisor']);
              boxStorage.write("nama_panggilan", data['data']['nama_panggilan']);
              boxStorage.write("email", data['data']['email']);
              boxStorage.write("isLogin", true);
              Get.offAll(() => const HomePage());// langsung ke main.dart
        } else {
          FocusScope.of(Get.context!).requestFocus(usernameFocus);
          Get.snackbar("Login Gagal", data["message"] ?? "Coba lagi");
          return;
        }
      } else {
        Get.snackbar("Login Gagal", data["message"] ?? "Coba lagi");
      }
    } catch (e) {
      debugPrint("❌ Error umum: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
