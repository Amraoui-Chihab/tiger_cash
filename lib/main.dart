import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tigercashiraq/view/splash_screen.dart';
import 'Api Server/apidata.dart';
import 'error/server_error.dart';
import 'firebase_options.dart';
import 'utl/colors.dart';
import 'view/login_page.dart';
import 'view/home/root_page.dart';
import 'view/chat/chat_room.dart';



Widget defaultHome = const RootPage();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print("jfdskjhdfsj");
  await Firebase.initializeApp(

       options: DefaultFirebaseOptions.currentPlatform,
      );
      
  await GetStorage.init();
  GetStorage box = GetStorage();
  box.read("token");
  
  if (box.read("token") != null) {
    try {
      await ApiData.getToApi1("api/user/viewMy");
      defaultHome = const RootPage();
    } catch (e) {
      if (e is ServerError) {
        if (e.response.statusCode == 401) {
          box.remove("token");
          defaultHome = const LoginPage();
        } else {
          defaultHome = const RootPage();
        }
      }
    }
  } else {
    defaultHome = const LoginPage();
  }

  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(

      initialRoute: '/',
      getPages: [GetPage(name:'/' , page: () =>  SplashScreen()),GetPage(name:'/next' , page: () =>  NextPage())],
      debugShowCheckedModeBanner: false,
        title: 'Babylon',
        theme: ThemeData(
            colorScheme: const ColorScheme.light(primary: Ccolors.primry),
            useMaterial3: true,
            textTheme:
                GoogleFonts.alexandriaTextTheme(Theme.of(context).textTheme)),
        navigatorObservers: [FlutterSmartDialog.observer],
        builder: FlutterSmartDialog.init(),
        locale: const Locale("ar", "AE"),
       );
  }
}



class NextPage extends StatefulWidget {
  @override
  _NextPageState createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {

  @override
  Widget build(BuildContext context) {
    return defaultHome;
  }

  
}
