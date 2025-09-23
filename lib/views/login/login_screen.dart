import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_apps/main.dart';
import 'package:my_apps/views/login/register_screen.dart';
import 'package:my_apps/controllers/LoginController.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final LoginController c = Get.put(LoginController());
  final FocusNode passFocus = FocusNode();
  final FocusNode btnFocus = FocusNode();

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
              Color(0xFF20282C), // Colors.green.shade700
              Color(0xFF595C59),
            ],
          ),
        ),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 50),

            // logo
            if (AppData.logoApp.isNotEmpty)
              ClipOval(
                child: Image.network(
                  AppData.logoApp,
                  width: 200,
                  height: 200,
                ),
              ),

            const SizedBox(height: 10),

            // nama aplikasi dengan fade
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: Text(
                AppData.namaAplikasi.isNotEmpty
                    ? AppData.namaAplikasi
                    : "My App",
                key: ValueKey(AppData.namaAplikasi),
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),

            const SizedBox(height: 10),

            // card login
            Center(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                width: formWidth,
                height: MediaQuery.of(context).size.height * 0.5,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 30),

                      // email + password box
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(225, 95, 27, .3),
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            )
                          ],
                        ),
                        child: Column(
                          children: <Widget>[
                            // email
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey.shade200,
                                  ),
                                ),
                              ),
                              child: TextField(
                                focusNode: c.usernameFocus,
                                controller: c.emailController,
                                style: const TextStyle(
                                    fontSize: 22.0, color: Colors.black87),
                                decoration: InputDecoration(
                                  hintText: "Email or Username...",
                                  hintStyle:
                                  TextStyle(color: Colors.grey.shade500),
                                ),
                                onSubmitted: (_) {
                                  FocusScope.of(context)
                                      .requestFocus(passFocus);
                                },
                              ),
                            ),

                            // password
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                      color: Colors.grey.shade200),
                                ),
                              ),
                              child: Obx(
                                    () => TextField(
                                  focusNode: passFocus,
                                  controller: c.passController,
                                  obscureText: c.isPasswordHidden.value,
                                  style: const TextStyle(
                                      fontSize: 22.0, color: Colors.black87),
                                  decoration: InputDecoration(
                                    hintText: "Password",
                                    hintStyle: TextStyle(
                                        color: Colors.grey.shade500),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        c.isPasswordHidden.value
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                      ),
                                      onPressed: () {
                                        c.isPasswordHidden.value =
                                        !c.isPasswordHidden.value;
                                      },
                                    ),
                                  ),
                                  onSubmitted: (_) {
                                    c.passController.text.isEmpty
                                        ? FocusScope.of(context)
                                        .requestFocus(passFocus)
                                        : FocusScope.of(context)
                                        .requestFocus(btnFocus);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // tombol login
                      MaterialButton(
                        onPressed: () => c.login(),
                        height: 70,
                        color: Colors.orange[900],
                        focusNode: btnFocus,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Center(
                          child: Obx(
                                () => AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: c.isLoading.value
                                  ? const SizedBox(
                                key: ValueKey("loading"),
                                width: 28,
                                height: 28,
                                child: CircularProgressIndicator(
                                    strokeWidth: 3, color: Colors.white),
                                )
                                  : const Text(
                                key: ValueKey("loginText"),
                                "Login",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // register + forgot password
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: MaterialButton(
                              onPressed: () {
                                Get.to(() => const RegisterScreen());
                              },
                              height: 50,
                              color: Colors.green.shade700,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: const Center(
                                child: Text(
                                  "Register",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 30),
                          Expanded(
                            child: MaterialButton(
                              onPressed: () {},
                              height: 50,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              color: Colors.green.shade700,
                              child: const Center(
                                child: Text(
                                  "Forgot Password",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
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
