import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_screens/globalVars.dart';
import 'package:flutter_project_screens/screens/onboarding_screen.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GlobalVars.cameras = await availableCameras();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Color(0xFF674AEF)
      ),
      home:WelcomeScreen(),
    );
  }
}
