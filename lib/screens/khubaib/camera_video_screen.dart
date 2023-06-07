import 'dart:convert';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_screens/screens/khubaib/showAverageScreen.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';

import '../../globalVars.dart';

late List<CameraDescription> _cameras;
//hellow
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  GlobalVars.cameras = await availableCameras();
  runApp(MaterialApp(home: Home()));
}

class Home extends StatelessWidget {
  const Home({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return CameraVideoScreen();
              },
            ),
          );
        },
        child: Text("goto"),
      ),
    );
  }
}

/// CameraVideoScreen is the Main Application.
class CameraVideoScreen extends StatefulWidget {
  const CameraVideoScreen({Key? key}) : super(key: key);

  @override
  State<CameraVideoScreen> createState() => _CameraVideoScreenState();
}

class _CameraVideoScreenState extends State<CameraVideoScreen> {
  List<Map<String, dynamic>> _jsonDataList = [];
  late CameraController controller;
  Uint8List? _imageData;

  Future<void> captureAndSendSnapshot() async {
    if (!controller.value.isInitialized) {
      return;
    }

    try {
      final image = await controller.takePicture();

      setState(() {
        _imageData = File(image.path).readAsBytesSync();
      });

      final url = Uri.parse(
          "${GlobalVars.IP}:8009/getmodel?ID=${GlobalVars.lectureID}");
      final request = http.MultipartRequest('GET', url);
      request.files.add(await http.MultipartFile.fromPath('img', image.path));
      final response = await request.send();

      if (response.statusCode == 200) {
        print('Image sent successfully');
      } else {
        print('Failed to send image. Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  late Timer _timer;

  @override
  void initState() {
    super.initState();
    controller = CameraController(
      GlobalVars.cameras[0],
      ResolutionPreset.veryHigh,
    );

    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        // _timer = Timer.periodic(Duration(seconds: 4), (_) async {
        //   await captureAndSendSnapshot();
        // });
      });
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            break;
          default:
            break;
        }
      }
    });
  }

  Future<void> _fetchJsonData() async {
    final jsonUrl =
        '${GlobalVars.IP}:8009/getActivitiesPerImage?ID=${GlobalVars.lectureID}'; // Replace with the URL for JSON data
    var jsonResponse = await http.get(Uri.parse(jsonUrl));

    if (jsonResponse.statusCode == 200) {
      final jsonResult = json.decode(jsonResponse.body);
      // Assuming the JSON data is a list of maps
      if (jsonResult is List) {
        setState(() {
          _jsonDataList = jsonResult.cast<Map<String, dynamic>>();
        });
      }
    } else {
      print(
          'Failed to get JSON data with status code ${jsonResponse.statusCode}');
    }
  }

  bool condition = true;
  Future<void> sendFrames() async {
    while (condition) {
      await captureAndSendSnapshot();
      await _fetchJsonData();
    }
  }

  bool isRecording = false;

  @override
  void dispose() {
    condition = false;
    _timer.cancel();
    controller.dispose();
    super.dispose();
  }

  Widget _buildDataList() {
    if (_jsonDataList.isNotEmpty) {
      return ListView.builder(
        itemCount: _jsonDataList.length,
        itemBuilder: (context, index) {
          final data = _jsonDataList[index];
          final name = data['name'];
          final activity = data['activity'];
          return ListTile(
            title: Row(
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 10),
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  data['studentName'],
                  style: TextStyle(fontSize: 10),
                )
              ],
            ),
            subtitle: Text(activity),
            leading: Text(data['startTime']),
            trailing: Text(data['endTime'] ?? "Not Ended"),
          );
        },
      );
    } else {
      return Center(
        child: Text('No data available'),
      );
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 360,
              width: 400,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: 2.0,
                ),
              ),
              child: CameraPreview(controller),
            ),
            Expanded(
              child: _buildDataList(),
            ),
            ElevatedButton(
              onPressed: () {
                if (isRecording) {
                  condition = false;
                  isRecording = false;
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return AverageScreenView();
                    },
                  ));
                } else {
                  setState(() {
                    condition = true;
                    isRecording = true;
                    sendFrames();
                  });
                }
              },
              child: Text(
                isRecording ? "End Recording" : "Start Recording",
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
