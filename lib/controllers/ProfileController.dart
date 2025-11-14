import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:get_storage/get_storage.dart';
import 'package:my_apps/views/home/home_screen.dart';
import 'package:intl/intl.dart';
import 'package:my_apps/main.dart';


class ProfileController extends GetxController {
  // Text Controllers
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final namaPanggilanController = TextEditingController();
  final namaLengkapController = TextEditingController();
  final phoneController = TextEditingController();
  final alamatController = TextEditingController();
  final kotaController = TextEditingController();
  final propinsiController = TextEditingController();
  final facebookController = TextEditingController();
  final instagramController = TextEditingController();
  final tiktokController = TextEditingController();
  final passwordLamaController = TextEditingController();
  final passwordBaruController = TextEditingController();
  final rePasswordController = TextEditingController();
  var jenKel = "".obs; // ✅ ini yang dipakai dropdown
  final jenKelController = TextEditingController(); // opsional untuk form lain
  final tglLahirController = TextEditingController(); // opsional untuk form lain

  // Rx variables
  var profileImage = Rx<File?>(null);
  var profilePhotoUrl = "".obs;
  var isLoading = false.obs;

  var isPasswordLamaObscure = true.obs;
  var isPasswordBaruObscure = true.obs;
  var isRePasswordObscure = true.obs;

  final genderOptions = {"P": "Perempuan", "L": "Laki-Laki"};
  final ImagePicker _picker = ImagePicker();

  final boxStorage = GetStorage();

  /// Pick image (gallery untuk desktop, gallery/camera untuk Android/iOS)
  Future<void> pickImage({bool fromCamera = false}) async {
    if (fromCamera && (kIsWeb || !(Platform.isAndroid || Platform.isIOS))) {
      Get.snackbar("Error", "Camera tidak tersedia di platform ini");
      return;
    }

    final pickedFile = await _picker.pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 70,
    );

    if (pickedFile != null) {
      profileImage.value = File(pickedFile.path);
    }

  }

  /// Load profile on open page
  Future<void> loadProfile() async {
    try {
      isLoading.value = true;
      final box = GetStorage();
      final username = box.read("username") ?? '';
      if (username.isEmpty) return;

      final url = Uri.parse("${AppData.base_url}/users/get-user/$username");
      final res = await http.get(url);

      if (res.statusCode == 200) {
        final jsonData = jsonDecode(res.body);
        usernameController.text = jsonData['user']['username'] ?? '';
        emailController.text = jsonData['user']['email'] ?? '';
        namaPanggilanController.text = jsonData['user']['nama_panggilan'] ?? '';
        phoneController.text = jsonData['profile']['whatsapp'] ?? '';
        namaLengkapController.text = jsonData['profile']['nama_lengkap'] ?? '';
        alamatController.text = jsonData['profile']['alamat'] ?? '';
        kotaController.text = jsonData['profile']['kota'] ?? '';
        propinsiController.text = jsonData['profile']['propinsi'] ?? '';
        facebookController.text = jsonData['profile']['facebook'] ?? '';
        instagramController.text = jsonData['profile']['instagram'] ?? '';
        tiktokController.text = jsonData['profile']['tiktok'] ?? '';
        profilePhotoUrl.value = jsonData['profile']['foto'] ?? '';
        jenKelController.text = jsonData['profile']['jenis_kel'] ?? '';
        jenKel.value = jsonData['profile']['jenis_kel'] ?? '';

        if (jsonData['profile']["tgl_lahir"] != null && jsonData['profile']["tgl_lahir"].toString().isNotEmpty) {
          DateTime date = DateTime.parse(jsonData['profile']["tgl_lahir"]);
          tglLahirController.text = DateFormat("dd-MM-yyyy").format(date);
        }

      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Convert File to Base64
  Future<String?> imageToBase64(File? image) async {
    if (image == null) return null;
    final bytes = await image.readAsBytes();
    return base64Encode(bytes);
  }

  /// Update profile with Base64 image
  Future<void> updateUserProfile() async {
    try {
      isLoading.value = true;
      final box = GetStorage();
      final username = box.read("username") ?? '';
      final token = box.read("access_token") ?? '';
      if (username.isEmpty) return;

      final base64Image = await imageToBase64(profileImage.value);

      final response = await http.post(
        Uri.parse("${AppData.base_url}/users/update_profile"),
        body: {
          'access_token': token,
          'username': usernameController.text,
          'email': emailController.text,
          'nama_panggilan': namaPanggilanController.text,
          'nama_lengkap': namaLengkapController.text,
          'whatsapp': phoneController.text,
          'alamat': alamatController.text,
          'kota': kotaController.text,
          'propinsi': propinsiController.text,
          'facebook': facebookController.text,
          'instagram': instagramController.text,
          'tiktok': tiktokController.text,
          'profile_photo': base64Image ?? '',
          'jenis_kel': jenKelController.text,
          'tgl_lahir': tglLahirController.text,
        },
      );

      final jsonData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        Get.snackbar("Sukses", "Profile berhasil diperbarui",
            backgroundColor: Colors.green, colorText: Colors.white);
            boxStorage.write("photoProfile",jsonData['data']['foto']);
            boxStorage.write("nama_panggilan",namaPanggilanController.text);
      } else {
        Get.snackbar("Error", jsonData['message'] ?? "Gagal update profile",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  void clearFields() {
    usernameController.clear();
    emailController.clear();
    namaPanggilanController.clear();
    namaLengkapController.clear();
    phoneController.clear();
    alamatController.clear();
    kotaController.clear();
    propinsiController.clear();
    facebookController.clear();
    instagramController.clear();
    tiktokController.clear();
    profileImage.value = null;
    profilePhotoUrl.value = '';
  }

  @override
  void onInit() {
    super.onInit();
    loadProfile(); // load saat halaman dibuka
  }

  @override
  void onClose() {
    usernameController.dispose();
    emailController.dispose();
    namaPanggilanController.dispose();
    namaLengkapController.dispose();
    phoneController.dispose();
    alamatController.dispose();
    kotaController.dispose();
    propinsiController.dispose();
    facebookController.dispose();
    instagramController.dispose();
    tiktokController.dispose();
    super.onClose();
  }

  Future<void> updatePassword() async {
      try {
        final box = GetStorage();
        var code = box.read("code_user") ?? '';

        final response = await http.post(
          Uri.parse("${AppData.base_url}/users/update_password"),
          body: {
            'code': code,
            'password_lama': passwordLamaController.text,
            'password': passwordBaruController.text,
          },
        );

        if (response.statusCode == 200) {
          Get.snackbar("Sukses", "Update password",
              backgroundColor: Colors.green, colorText: Colors.white);
          Get.offAll(() => HomeScreen());
        } else {
          Get.snackbar("Error", "Gagal update password",
              backgroundColor: Colors.red, colorText: Colors.white);
        }

      } catch (e) {
        Get.snackbar("Error", e.toString(),
            backgroundColor: Colors.red, colorText: Colors.white);
      }
  }
}
