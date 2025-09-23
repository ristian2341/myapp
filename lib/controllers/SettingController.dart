import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'package:my_apps/main.dart';

class SettingController extends GetxController {
  var instansi = "".obs;
  var namaAplikasi = "".obs;
  var logoApp = "".obs;
  var iconApp = "".obs;

  @override
  void onInit() {
    super.onInit();
    loadSetting();
  }

  Future<void> loadSetting() async {
    try {
      final res = await http.get(
        Uri.parse("http://10.8.12.68:88/myflutterapi/setting"),
      );

      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);
        data = data['data'];

        AppData.instansi= data['instansi'] ?? "";
        AppData.namaAplikasi = data['nama_aplikasi'] ?? "";
        AppData.logoApp = data['logo'] ?? "";
        AppData.iconApp= data['icon'] ?? "";

      } else {
        Get.snackbar("Error", "Gagal ambil setting: ${res.statusCode}");
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
