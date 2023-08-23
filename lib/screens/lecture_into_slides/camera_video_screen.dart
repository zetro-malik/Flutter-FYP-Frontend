import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_screens/screens/lecture_into_slides/board_images.dart';
import 'package:flutter_project_screens/screens/lecture_into_slides/fileDownload.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import '../../globalVars.dart';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_sound/flutter_sound.dart';

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
      );
  }
}

class CameraVideoScreen extends StatefulWidget {
  const CameraVideoScreen({Key? key}) : super(key: key);

  @override
  _CameraVideoScreenState createState() => _CameraVideoScreenState();
}

class _CameraVideoScreenState extends State<CameraVideoScreen> {
  late CameraController controller;
  FlutterSoundPlayer audioPlayer = FlutterSoundPlayer();
  FlutterSoundRecorder audioRecorder = FlutterSoundRecorder();
  Uint8List? _imageData;
  bool _isRecording = false;
  DateTime? audioStartTime;

  Future<void> startRecording() async {
    try {
      // Start recording audio
      final directory = await getApplicationDocumentsDirectory();
      final audioPath = '${directory.path}/audio.aac';

      // Start recording audio
      await audioRecorder.openRecorder();
      await audioRecorder.startRecorder(toFile: audioPath, codec: Codec.aacADTS);
      setState(() {
        _isRecording = true;
         audioStartTime = DateTime.now();
      });
    } catch (e) {
      print('Failed to start audio recording: $e');
    }
  }

  Future<void> stopRecording() async {
    try {
      _timer.cancel();
      // Stop recording audio
      await audioRecorder.stopRecorder();

      // Send the audio file to the server
      final directory = await getApplicationDocumentsDirectory();
      final audioPath = '${directory.path}/audio.aac';
      final url = Uri.parse("${GlobalVars.IP}:8009/postAudio?id=${GlobalVars.lectureID}");
      final request = http.MultipartRequest('POST', url);
      request.files.add(await http.MultipartFile.fromPath('audio', '${audioPath}'));
      final response = await request.send();

      if (response.statusCode == 200) {
        // Audio sent successfully
        print('Audio sent successfully');
      } else {
        // Handle the response error
        print('Failed to send audio. Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to stop audio recording: $e');
    } finally {
      setState(() {
        _isRecording = false;
      });
    }
  }

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
    audioPlayer.closePlayer();
    audioPlayer = FlutterSoundPlayer();
    audioRecorder.closeRecorder();
    audioRecorder = FlutterSoundRecorder();
    super.dispose();
  }
Future<void> captureAndSendSnapshot() async {
  if (!controller.value.isInitialized) {
    return;
  }

  try {
    final image = await controller.takePicture();

    setState(() {
      _imageData = File(image.path).readAsBytesSync();
    });

    // Calculate the time difference since the audio started recording
    final timeDifference = DateTime.now().difference(audioStartTime!);
    final secondsPassed = timeDifference.inSeconds;

    // Send the image data and timestamp to the server
    final url = Uri.parse("${GlobalVars.IP}:8009/postImage?id=${GlobalVars.lectureID}");
    final request = http.MultipartRequest('POST', url);
    request.files.add(await http.MultipartFile.fromPath('img', image.path));
    request.fields['timestamp'] = secondsPassed.toString();
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
              onPressed: _isRecording ?  () async {
                await stopRecording();
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return  FileDownloadPage();
                },));
              } : startRecording,
              child: Text(
                _isRecording ? 'Stop Recording' : 'Start Recording',
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