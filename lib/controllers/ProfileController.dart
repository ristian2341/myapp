import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class ProfileController extends GetxController {
  final box = GetStorage();

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final namaPanggilanController = TextEditingController();
  final namaLengkapController = TextEditingController();
  final whatsappController = TextEditingController();
  final alamatController = TextEditingController();
  final kotaController = TextEditingController();
  final propinsiController = TextEditingController();
  final facebookController = TextEditingController();
  final instagramController = TextEditingController();
  final tiktokController = TextEditingController();

  bool isLoading = false;

  @override
  void onInit() {
    super.onInit();
  }

  // 🔹 fungsi clear
  void clearFields() {
    usernameController.clear();
    emailController.clear();
    namaPanggilanController.clear();
    phoneController.clear();
    namaPanggilanController.clear();
    namaLengkapController.clear();
    whatsappController.clear();
    alamatController.clear();
    kotaController.clear();
    propinsiController.clear();
    facebookController.clear();
    instagramController.clear();
    tiktokController.clear();
  }

  /// Ambil data user
  Future<void> getUserProfile(String uname) async {
    try {

      final response = await http.get(
        Uri.parse("http://10.8.12.68:88/myflutterapi/users/get-user/${uname}"),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

      } else {
        Get.snackbar("Error", "Gagal ambil data user");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading = false;
    }
  }


}
