import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:flutter/material.dart';
import 'package:librarymanagement/screens/homescreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase initialization for different platforms
  if (kIsWeb) {
    // Firebase configuration for Web
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyDDtXeG8Oe9Wlx_6aBM_VDbs14RmqnUjcc",
        appId: "1:254312294037:web:28b4d70222fa6050171d9c",
        messagingSenderId: "254312294037",
        projectId: "collegetestproject",
        databaseURL: "https://collegetestproject-default-rtdb.firebaseio.com/",
      ),
    );
  } else {
    // Firebase configuration for Mobile/Desktop
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyDDtXeG8Oe9Wlx_6aBM_VDbs14RmqnUjcc",
        appId: "1:254312294037:android:28b4d70222fa6050171d9c",
        messagingSenderId: "254312294037",
        projectId: "collegetestproject",
      ),
    );
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Homescreen(),
      theme: ThemeData(iconTheme: const IconThemeData(color: Colors.white)),
    );
  }
}
