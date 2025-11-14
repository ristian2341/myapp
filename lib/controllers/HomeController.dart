import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomeController extends GetxController {
  var selectedIndex = 1.obs;
  final boxStorage = GetStorage();

  var photo = "".obs;
  var nama_panggilan = "".obs;
  var username = "".obs;
  var email = "".obs;

  void onInit(){
    super.onInit();

    final boxStorage = GetStorage();

    photo.value = boxStorage.read("photoProfile") ?? "";
    nama_panggilan.value = boxStorage.read("nama_panggilan") ??
        boxStorage.read("username") ?? "";
    email.value = boxStorage.read("email") ??  "";
  }

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
        boxStorage.remove("photoProfile");
        Get.offAllNamed("/login");
        Get.snackbar("Logout", "Anda berhasil keluar");
      },
    );
  }
}
