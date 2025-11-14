import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:my_apps/views/login/login_screen.dart';
import 'package:my_apps/views/home/home_screen.dart';
import 'package:my_apps/views/splash_screen.dart';
import 'package:my_apps/controllers/SettingController.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppData {
  await dotenv.load(fileName: ".env");

  static String instansi = "";
  static String namaAplikasi = "";
  static String logoApp = "";
  static String iconApp = "";
  static String base_url = dotenv.env['API_URL'];
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 🔹 Register controller global
  Get.put(SettingController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final boxStorage = GetStorage();

    checkLogin();
    bool isLogIn = boxStorage.read("isLogin") ?? false;
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Percobaan Flutter',
      initialRoute: "/splash",
      initialBinding: BindingsBuilder(() {
        Get.put(SettingController()); // 🔹 inject controller global
      }),
      getPages: [
        GetPage(name: "/splash", page: () => SplashScreen()),
        GetPage(name: "/login", page: () => LoginScreen()),
        GetPage(name: "/home", page: () => HomeScreen()),
      ],
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.lightGreen,
      ),
      themeMode: ThemeMode.dark,
      // home: isLogIn ? HomeScreen() : LoginScreen(),
      home : MainLayout(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

Future<void> checkLogin() async {
  final boxStorage = GetStorage();

  final res = await http.post(
    Uri.parse("${AppData.base_url}/users/login"),
    body: {
      "user_name": boxStorage.read("username"),
      "password": boxStorage.read("password"),
    },
  );
  var data = jsonDecode(res.body);

  if (data['statusCode'] == 200) {
      if(data['data']['username'] != boxStorage.read("username")){
          Logout();
      }else{
        boxStorage.write("username", data['data']['username']);
        boxStorage.write("code_user", data['data']['code']);
        boxStorage.write("access_token", data['data']['access_token']);
        boxStorage.write("developer", data['data']['developer']);
        boxStorage.write("supervisor", data['data']['supervisor']);
        boxStorage.write("nama_panggilan", data['data']['nama_panggilan']);
        boxStorage.write("email", data['data']['email']);
        boxStorage.write("password", boxStorage.read("password"));
        boxStorage.write("photoProfile", data['data']['photo_profile']);
      }
  } else {
    Logout();
  }
}

Future<void> Logout() async {
  final boxStorage = GetStorage();
  Get.snackbar("Logout", "Ada perubahan akun harap login terlebih dahulu");
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
}



/// Struktur menu
class MenuItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final Widget page;

  MenuItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.page,
  });
}

class MainLayout extends StatefulWidget {
  @override
  _MainLayoutState createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  /// Daftar menu (bisa ambil dari API juga)
  final List<MenuItem> menuItems = [
    MenuItem(
      icon: Icons.dashboard_outlined,
      selectedIcon: Icons.dashboard,
      label: "Dashboard",
      page: DashboardPage(),
    ),
    MenuItem(
      icon: Icons.people_outline,
      selectedIcon: Icons.people,
      label: "Siswa",
      page: SiswaPage(),
    ),
    MenuItem(
      icon: Icons.settings_outlined,
      selectedIcon: Icons.settings,
      label: "Setting",
      page: SettingPage(),
    ),
  ];

  void _navigateTo(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          /// Sidebar kiri dengan NavigationRail
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: _navigateTo,
            labelType: NavigationRailLabelType.all,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FlutterLogo(size: 40),
            ),
            destinations: menuItems
                .map((item) => NavigationRailDestination(
              icon: Icon(item.icon),
              selectedIcon: Icon(item.selectedIcon),
              label: Text(item.label),
            ))
                .toList(),
          ),

          /// Area konten kanan
          Expanded(
            child: menuItems[_selectedIndex].page,
          ),
        ],
      ),
    );
  }
}

/// ====== HALAMAN KONTEN ======
class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("📊 Dashboard")),
      body: Center(child: Text("Ini halaman Dashboard")),
    );
  }
}

class SiswaPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("👨‍🎓 Data Siswa")),
      body: Center(child: Text("Ini halaman Siswa")),
    );
  }
}

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("⚙️ Setting Aplikasi")),
      body: Center(child: Text("Ini halaman Setting")),
    );
  }
}

