import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../globalVars.dart';

late List<CameraDescription> _cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  _cameras = await availableCameras();
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
        child: Text("Go to Camera"),
      ),
    );
  }
}

class CameraVideoScreen extends StatefulWidget {
  const CameraVideoScreen({Key? key}) : super(key: key);

  @override
  _CameraVideoScreenState createState() => _CameraVideoScreenState();
}

class _CameraVideoScreenState extends State<CameraVideoScreen> {
  late CameraController _controller;
  Uint8List? _imageData;
  List<Map<String, dynamic>> _jsonDataList = [];
  bool _isPaused = false;
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      GlobalVars.cameras[0],
      ResolutionPreset.veryHigh,
    );

    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> captureAndSendSnapshot() async {
    if (!_controller.value.isInitialized) {
      return;
    }

    try {
      final image = await _controller.takePicture();

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

  Future<void> fetchJsonData() async {
    final jsonUrl =
        '${GlobalVars.IP}:8009/getActivitiesPerImage?ID=${GlobalVars.lectureID}';
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

  Future<void> sendFrames() async {
    if (_isPaused) return;

    await captureAndSendSnapshot();
    
    

    await fetchJsonData();

    if (_isRecording) {
      // Continue sending frames if recording is still ongoing
      Future.delayed(Duration(seconds: 1), sendFrames);
    }
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
                SizedBox(width: 5),
                Text(
                  data['studentName'],
                  style: TextStyle(fontSize: 10),
                ),
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
    if (!_controller.value.isInitialized) {
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
              child: CameraPreview(_controller),
            ),
            Expanded(
              child: _buildDataList(),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isPaused = !_isPaused;
                  if (_isPaused==false){
                      sendFrames();
                  }
                });
              },
              child: Text(
                _isPaused ? "Resume" : "Pause",
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
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _isRecording = !_isRecording;
                });
                if (_isRecording) {
                  sendFrames();
                }
              },
              child: Text(
                _isRecording ? "End Recording" : "Start Recording",
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













