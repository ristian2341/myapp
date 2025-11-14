import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RekeningController extends GetxController {
  var isFormVisible = false.obs; // 🔁 toggle antara list dan form
  var isEditMode = false.obs; // ⛳ true kalau sedang edit

  // Dummy data rekening
  var listRekening = <Map<String, dynamic>>[].obs;

  // Form controllers
  final codeRekeningController = TextEditingController();
  final nomorRekeningController = TextEditingController();
  final namaBankController = TextEditingController();
  final atasNamaController = TextEditingController();
  final cabangController = TextEditingController();

  void showForm({Map<String, dynamic>? rekening}) {
    if (rekening != null) {
      // edit mode
      isEditMode.value = true;
      codeRekeningController.text = rekening['code'];
      nomorRekeningController.text = rekening['nomor'];
      namaBankController.text = rekening['bank'];
      atasNamaController.text = rekening['atasNama'];
      cabangController.text = rekening['cabang'];
    } else {
      // tambah mode
      isEditMode.value = false;
      clearForm();
    }
    isFormVisible.value = true;
  }

  void saveData() {
    if (isEditMode.value) {
      // update
      final index = listRekening.indexWhere(
            (r) => r['code'] == codeRekeningController.text,
      );
      if (index != -1) {
        listRekening[index] = {
          'code': codeRekeningController.text,
          'nomor': nomorRekeningController.text,
          'bank': namaBankController.text,
          'atasNama': atasNamaController.text,
          'cabang': cabangController.text,
        };
      }
    } else {
      // tambah baru
      listRekening.add({
        'code': DateTime.now().millisecondsSinceEpoch.toString(),
        'nomor': nomorRekeningController.text,
        'bank': namaBankController.text,
        'atasNama': atasNamaController.text,
        'cabang': cabangController.text,
      });
    }
    clearForm();
    isFormVisible.value = false;
  }

  void deleteData(String code) {
    listRekening.removeWhere((r) => r['code'] == code);
  }

  void clearForm() {
    codeRekeningController.clear();
    nomorRekeningController.clear();
    namaBankController.clear();
    atasNamaController.clear();
    cabangController.clear();
  }
}
