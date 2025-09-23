import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomeController extends GetxController {
  var selectedIndex = 0.obs;
  final boxStorage = GetStorage();

  void changeTab(int index) {
    selectedIndex.value = index;
  }

  void logout() {
    Get.defaultDialog(
      title: "Konfirmasi",
      middleText: "Apakah Anda yakin ingin logout?",
      textCancel: "Batal",
      textConfirm: "Logout",
      onConfirm: () {
        boxStorage.write("isLogin", false); // hapus session
        boxStorage.remove("username");
        boxStorage.remove("code_user");
        boxStorage.remove("access_token");
        boxStorage.remove("developer");
        boxStorage.remove("supervisor");
        boxStorage.remove("nama_panggilan");
        boxStorage.remove("email");
        Get.offAllNamed("/login");
        Get.snackbar("Logout", "Anda berhasil keluar");
      },
    );
  }
}
