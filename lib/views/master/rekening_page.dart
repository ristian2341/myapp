import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_apps/controllers/master/RekeningController.dart';
import 'package:my_apps/widgets/form_widget.dart';

class RekeningPage extends StatelessWidget {
  RekeningPage({super.key});
  final RekeningController c = Get.put(RekeningController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Obx(() => c.isFormVisible.value
          ? const SizedBox.shrink()
          : FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () => c.showForm(),
        child: const Icon(Icons.add, color: Colors.white),
      )),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.green.shade900,
              Colors.green.shade700,
              Colors.green.shade400
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Obx(() => AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: c.isFormVisible.value
              ? _buildFormView(context)
              : _buildListView(context),
        )),
      ),
    );
  }

  // 🔹 LIST DATA REKENING
  Widget _buildListView(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        // 🔙 Tombol Back + Judul
        // Back button + title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context)),
              const SizedBox(width: 8),
              const Text("Data Rekening",
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            ),
            child: Obx(() => ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: c.listRekening.length,
              itemBuilder: (context, index) {
                final item = c.listRekening[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(item['bank']),
                    subtitle: Text(item['nomor']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon:
                          const Icon(Icons.edit, color: Colors.orange),
                          onPressed: () => c.showForm(rekening: item),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => c.deleteData(item['code']),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )),
          ),
        ),
      ],
    );
  }

  // 🔹 FORM TAMBAH / EDIT REKENING
  Widget _buildFormView(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => c.isFormVisible.value = false,
            ),
            Text(
              c.isEditMode.value ? "Edit Rekening" : "Tambah Rekening",
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  buildTextField(
                      controller: c.nomorRekeningController,
                      label: "Nomor Rekening",
                      hint: "Masukkan Nomor Rekening"),
                  buildTextField(
                      controller: c.namaBankController,
                      label: "Nama Bank",
                      hint: "Masukkan Nama Bank"),
                  buildTextField(
                      controller: c.atasNamaController,
                      label: "Atas Nama",
                      hint: "Masukkan Nama Pemilik"),
                  buildTextField(
                      controller: c.cabangController,
                      label: "Cabang",
                      hint: "Masukkan Cabang"),
                  const SizedBox(height: 20),
                  buildSaveButton(
                    label: "Simpan",
                    onPressed: () async {
                      c.saveData();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
