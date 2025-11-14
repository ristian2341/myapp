import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

/// 🔹 Text Field

/// 🔹 TextField umum
Widget buildTextField({
  required TextEditingController controller,
  required String label,
  required String hint,
  bool readOnly = false,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: TextField(
      controller: controller,
      readOnly: readOnly,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.black54,
      ),
      decoration: InputDecoration(
        labelText: label, // ✅ label masuk ke border
        labelStyle: const TextStyle(
          color: Colors.black45, // ✅ label gelap
          fontWeight: FontWeight.bold,
        ),
        hintText: hint,
        hintStyle: const TextStyle(
          color: Colors.black12, // hint lebih pudar
        ),
        filled: true,
        fillColor: Colors.grey.shade300,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey, width: 1.5), // ✅ border gelap saat idle
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.black45, width: 2), // ✅ border lebih tebal saat fokus
        ),
      ),
    ),
  );
}

/// 🔹 TextField dengan Password (pakai RxBool agar bisa toggle)
Widget buildPasswordField({
  required TextEditingController controller,
  required String label,
  required String hint,
  required RxBool isObscure, // ✅ ubah jadi RxBool
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() => TextField(
          controller: controller,
          obscureText: isObscure.value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),// ✅ pakai .value
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(
              color: Colors.black45,
              fontWeight: FontWeight.bold,
            ),
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.black26),
            filled: true,
            fillColor: Colors.grey.shade300,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
              const BorderSide(color: Colors.grey, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:
              const BorderSide(color: Colors.black45, width: 2),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                isObscure.value
                    ? Icons.visibility_off
                    : Icons.visibility,
              ),
              onPressed: () => isObscure.value = !isObscure.value,
            ),
          ),
        )),
      ],
    ),
  );
}


/// 🔹 Dropdown (pakai Map key=>value)
Widget buildDropdownRx({
  required String label,
  required String hint,
  required Map<String, String> items,
  required RxString value,
  Function(String?)? onChanged,
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
        Obx(() {
          // ✅ cek apakah value ada di items
          String? currentValue =
          items.keys.contains(value.value) && value.value.isNotEmpty
              ? value.value
              : null;

          return DropdownButtonFormField<String>(
            isExpanded: true,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
            ),
            hint: Text(hint),
            value: currentValue, // ✅ kalau tidak valid → null
            items: items.entries
                .map((e) => DropdownMenuItem<String>(
              value: e.key,
              child: Text(e.value),
            ))
                .toList(),
            onChanged: (val) {
              value.value = val ?? '';
              if (onChanged != null) onChanged(val);
            },
          );
        }),
      ],
    ),
  );
}

/// 🔹 Checkbox
Widget buildCheckbox({
  required String label,
  required bool value,
  required Function(bool?) onChanged,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Row(
      children: [
        Checkbox(value: value, onChanged: onChanged),
        Text(label, style: const TextStyle(fontSize: 16)),
      ],
    ),
  );
}

/// 🔹 OptionBox (Radio Button Group)
Widget buildOptionBox({
  required String label,
  required Map<String, String> options,
  required String groupValue,
  required Function(String?) onChanged,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            )),
        const SizedBox(height: 8),
        Row(
          children: options.entries.map((entry) {
            return GestureDetector(
              onTap: () => onChanged(entry.key), // ✅ klik label juga bisa pilih
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Radio<String>(
                    value: entry.key,
                    groupValue: groupValue,
                    onChanged: onChanged,
                    activeColor: Colors.black, // warna bulat hitam
                  ),
                  Text(entry.value,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black54)),
                  const SizedBox(width: 20),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    ),
  );
}

Widget buildDateField({
  required TextEditingController controller,
  required String label,
  required String hint,
  bool readOnly = true,
  required BuildContext context,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          readOnly: readOnly, // ✅ supaya hanya bisa lewat picker
          onTap: () async {
            DateTime initialDate = DateTime.now();
            print(controller.text);
            if (controller.text.isNotEmpty) {
              try {
                initialDate = DateFormat("dd-MM-yyyy").parse(controller.text);
              } catch (_) {}
            }
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
            );
            if (pickedDate != null) {
              // ✅ Format dd-MM-yyyy
              String formattedDate =
              DateFormat("dd-MM-yyyy").format(pickedDate);
              controller.text = formattedDate;
            }
          },
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.grey.shade200,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.black54, width: 1.5),
            ),
            suffixIcon: const Icon(Icons.calendar_today, color: Colors.black54),
          ),
        ),
      ],
    ),
  );
}
/// ✅ Tombol Save (Hijau)
Widget buildSaveButton({
  Future<void> Function()? onPressed, // ⬅️ nullable
  required String label,
}) {
  final isLoading = false.obs;

  return Obx(() => ElevatedButton.icon(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.orange[900],
      padding: const EdgeInsets.symmetric(vertical: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50),
      ),
      minimumSize: const Size(double.infinity, 50),
    ),
    onPressed: (onPressed == null || isLoading.value)
        ? null // ⛔️ disabled jika kosong atau sedang loading
        : () async {
      try {
        isLoading.value = true;
        await onPressed(); // ⬅️ aman karena sudah dicek null
      } finally {
        isLoading.value = false;
      }
    },
    icon: isLoading.value
        ? const SizedBox(
      width: 18,
      height: 18,
      child: CircularProgressIndicator(
        color: Colors.white,
        strokeWidth: 2,
      ),
    )
        : const Icon(Icons.save, color: Colors.white),
    label: const Text(
      'Save',
      style: TextStyle(fontSize: 20, color: Colors.white),
    ),
  ));
}


/// ✅ Tombol Update (Oranye)
Widget buildUpdateButton({
  required Future<void> Function() onPressed,
  required String label,

}) {
  final isLoading = false.obs;

  return Obx(() => ElevatedButton.icon(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.orange,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape:
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
    onPressed: isLoading.value
        ? null
        : () async {
      try {
        isLoading.value = true;
        await onPressed();
      } finally {
        isLoading.value = false;
      }
    },
    icon: isLoading.value
        ? const SizedBox(
      width: 18,
      height: 18,
      child: CircularProgressIndicator(
          color: Colors.white, strokeWidth: 2),
    )
        : const Icon(Icons.update, color: Colors.white),
    label: Text(
      isLoading.value ? "Updating..." : label,
      style: const TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold),
    ),
  ));
}

/// ✅ Tombol Delete (Merah)
Widget buildDeleteButton({
  required Future<void> Function() onPressed,
  required String label,
}) {
  final isLoading = false.obs;

  return Obx(() => ElevatedButton.icon(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.red,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape:
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    onPressed: isLoading.value
        ? null
        : () async {
      bool? confirm = await Get.dialog<bool>(
        AlertDialog(
          title: const Text("Konfirmasi"),
          content:
          const Text("Apakah Anda yakin ingin menghapus data ini?"),
          actions: [
            TextButton(
                onPressed: () => Get.back(result: false),
                child: const Text("Batal")),
            TextButton(
                onPressed: () => Get.back(result: true),
                child: const Text("Hapus")),
          ],
        ),
      );

      if (confirm == true) {
        try {
          isLoading.value = true;
          await onPressed();
        } finally {
          isLoading.value = false;
        }
      }
    },
    icon: isLoading.value
        ? const SizedBox(
      width: 18,
      height: 18,
      child: CircularProgressIndicator(
          color: Colors.white, strokeWidth: 2),
    )
        : const Icon(Icons.delete, color: Colors.white),
    label: Text(
      isLoading.value ? "Deleting..." : label,
      style: const TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold),
    ),
  ));
}

Widget listTileItem({
  required IconData icon,
  required String title,
  String subtitle = '',
  required VoidCallback onTap,
}) {
  return ListTile(
    leading: Icon(icon, color: Colors.orangeAccent),
    title: Text(title),
    subtitle: subtitle.isNotEmpty ? Text(subtitle) : null,
    trailing: Icon(Icons.arrow_forward_ios, size: 16),
    onTap: onTap,
  );
}

Widget sectionCard(
    {
      required String title,
      required List<Widget> children}
    )
{
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.orangeAccent)),
              ),
            ),
            Divider(),
            ...children,
          ],
        ),
      ),
    ),
  );
}

Widget buildTextAreaField({
  required TextEditingController controller,
  required String label,
  bool readOnly = false,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: TextFormField(
      controller: controller,
      readOnly: readOnly,
      maxLines: 6,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
      decoration: InputDecoration(
        labelText: label,
        alignLabelWithHint: true, // 🔹 agar label sejajar atas dengan area teks
        labelStyle: const TextStyle(
          color: Colors.black54,
          fontWeight: FontWeight.bold,
        ),
        filled: true,
        fillColor: Colors.grey.shade300,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.black45, width: 2),
        ),
      ),
    ),
  );
}


