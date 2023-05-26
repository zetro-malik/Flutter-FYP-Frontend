import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';

import '../../globalVars.dart';

late List<CameraDescription> _cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  _cameras = await availableCameras();
  runApp(MaterialApp(home: Home()));
}


class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: ElevatedButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) {
             return CameraVideoScreen();
          },));
        }, child: Text("goto")),
      )
    ;
  }
}


/// CameraVideoScreen is the Main Application.
class CameraVideoScreen extends StatefulWidget {
  /// Default Constructor
  const CameraVideoScreen({Key? key}) : super(key: key);

  @override
  State<CameraVideoScreen> createState() => _CameraVideoScreenState();
}

class _CameraVideoScreenState extends State<CameraVideoScreen> {
  late CameraController controller;
  Uint8List? _imageData;

  void captureAndSendSnapshot() async {
    if (!controller.value.isInitialized) {
      return;
    }

    try {
      final image = await controller.takePicture();

      setState(() {
        _imageData = File(image.path).readAsBytesSync();
      });

      // Send the image data to the server
      // Replace 'http://your-server-url' with the actual server URL
      final url = Uri.parse("${GlobalVars.IP}:8009/postImage?id=50");
     final request = http.MultipartRequest('POST', url);
      request.files.add(await http.MultipartFile.fromPath('img', image.path));
      final response = await request.send();

      if (response.statusCode == 200) {
        // Image sent successfully
        print('Image sent successfully');
      } else {
        // Handle the response error
        print('Failed to send image. Error: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any errors that occur during the process
      print('Error: $e');
    }
  }

  // ... existing code ...

late Timer _timer;

@override
void initState() {
  
  super.initState();
  SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  controller = CameraController(GlobalVars.cameras[0], ResolutionPreset.veryHigh);
 
  controller.initialize().then((_) {
    if (!mounted) {
      return;
    }
    setState(() {
      // Start the timer after the camera is initialized
      _timer = Timer.periodic(Duration(seconds: 4), (_) {
        captureAndSendSnapshot();
      });
    });
  }).catchError((Object e) {
    // Handle camera initialization errors here
    if (e is CameraException) {
      switch (e.code) {
        case 'CameraAccessDenied':
          // Handle access errors here.
          break;
        default:
          // Handle other errors here.
          break;
      }
    }
  });
}


  @override
  void dispose() {
     SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _timer.cancel();
    controller.dispose();
    super.dispose();
  }


  
@override
Widget build(BuildContext context) {
  if (!controller.value.isInitialized) {
    return Container();
  }
  return Scaffold(
    appBar: AppBar(
      title: Text("Live Recording"),
      backgroundColor: const Color(0xFF674AEF),
    ),
    backgroundColor: const Color(0xFF674AEF),
    body: SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 400,
            width: 600,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white,
                width: 2.0,
              ),
            ),
            child: CameraPreview(controller),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) {
                  return Home();
                }),
              );
            },
            child: Text(
              "End Recording",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.white,
              onPrimary: const Color(0xFF674AEF),
              padding: EdgeInsets.symmetric(
                vertical: 12,
                horizontal: 20,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

}