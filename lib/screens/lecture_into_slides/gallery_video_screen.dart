import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:flutter_project_screens/screens/lecture_into_slides/fileDownload.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:path/path.dart' as path;

import '../../globalVars.dart';

class GalleryVideoScreen extends StatefulWidget {
  const GalleryVideoScreen({Key? key}) : super(key: key);

  @override
  _GalleryVideoScreenState createState() => _GalleryVideoScreenState();
}

class _GalleryVideoScreenState extends State<GalleryVideoScreen> {
  VideoPlayerController? _controller;
  late FlutterFFmpeg _flutterFFmpegFrames;
  late FlutterFFmpeg _flutterFFmpegAudio;
  late Timer _timer;
  int _frameCount = 0;
  bool _framesExtracted = false; // Track whether frames are extracted
  bool _framesSent = false; // Track whether frames are sent
  int _frameTimestamp = 0; // Current video time in seconds when frame is taken
  String? _recordedVideoPath;
  String videoPath = "";
  bool _isRecordingStopped = false;

  @override
  void initState() {
    super.initState();
    _flutterFFmpegFrames = FlutterFFmpeg();
    _flutterFFmpegAudio = FlutterFFmpeg();
    _initializeVideo();
  }

  @override
  void dispose() {
    _controller?.dispose();
    _timer.cancel();
    super.dispose();
  }

  Future<void> _initializeVideo() async {
    final videoFile = await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (videoFile == null) return;

    setState(() {
      videoPath = videoFile.path;
    });

    _controller = VideoPlayerController.file(File(videoFile.path));

    await _controller!.initialize();

    setState(()  {
      // Reset frames-related variables
      _framesExtracted = false;
      _framesSent = false;
      _frameCount = 0;
      _frameTimestamp = 0;

      // Start extracting frames and audio
     
    });
    
        await  _checkFramesExtracted();
       // await _resetCache();
        _controller!.play();
         _extractAudio();
  }

  Future<void> _checkFramesExtracted() async {
    var tempDir = await getTemporaryDirectory();
    var frameImagePath = '${tempDir.path}/frame-1.jpg';
    var frameDir = Directory(tempDir.path);
    var frameImageFile = File(frameImagePath);

    if (frameImageFile.existsSync()) {
      setState(() {
        _framesExtracted = true;
      });
      _startSendingFrames();
    } else {
      await _extractFrames();
    }
  }

  Future<void> _resetCache() async {
    var tempDir = await getTemporaryDirectory();
    var tempFiles = tempDir.listSync();

    for (var file in tempFiles) {
      if (file is File) {
        await file.delete();
      }
    }
  }

  Future<void> _extractFrames() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    var videoDuration = _controller!.value.duration.inSeconds;
    var frameRate = 1 / 4;
    var startTime = 0; // Adjust the start time if needed
    var tempDir = await getTemporaryDirectory();
    var tempImagePath = '${tempDir.path}/frame-%d.jpg';
    var command = '-i ${_controller!.dataSource} -vf "fps=$frameRate" $tempImagePath';
    var commands = ['-i', _controller!.dataSource, '-vf', 'fps=$frameRate', tempImagePath];

    await _flutterFFmpegFrames.executeWithArguments(commands).then((rc) {
      print('Frame extraction return code: $rc');
      if (rc == 0)  {
        setState(() {
         
          _framesExtracted = true;
        });
        
        _startSendingFrames();
      }
    });
  }

  String audio_Path = "";
  Future<void> _extractAudio() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    final videoPath = _controller!.dataSource;
    final audioDir = await getTemporaryDirectory();
    final audioPath = path.join(audioDir.path, 'extracted_audio.aac');

    if (await File(audioPath).exists()) {
      print("DELEEETEEEEEEEEEEEEEEEDDD");
      await File(audioPath).delete();
    }

    final command = '-y -i $videoPath -vn -acodec copy $audioPath';

    _flutterFFmpegAudio.execute(command).then((rc) {
      if (rc == 0) {
        setState(() {
          audio_Path = audioPath;
        });
      }
    });
  }

  Future<void> _stopRecording() async {
    if (_isRecordingStopped) return;

    _controller!.pause();
    _timer.cancel(); // Stop the frame sending timer
    _isRecordingStopped = true;

    final videoFile = File(videoPath);

    if (videoFile.existsSync()) {
      final audioFile = File(audio_Path);

      if (audioFile.existsSync()) {
        // Send the audio file to the server
        await _sendAudio(audioFile);
      }
    }
  }

  Future<http.Response> _sendFrame(File frameFile, int frameTimestamp) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${GlobalVars.IP}:8009/postImage?id=${GlobalVars.lectureID}'), // Replace with your server endpoint
    );
    request.fields['timestamp'] = frameTimestamp.toString();
    request.files.add(await http.MultipartFile.fromPath('img', frameFile.path));
    return await request.send().then((response) => http.Response.fromStream(response));
  }

  void _startSendingFrames() async {
    if (!_framesExtracted || _framesSent) return;

    var videoDuration = _controller!.value.duration.inSeconds;
    var frameCount = videoDuration ~/ 4;
    var frameDuration = videoDuration / frameCount; // Duration of each frame in seconds
    var tempDir = await getTemporaryDirectory();

    _timer = Timer.periodic(Duration(seconds: 4), (timer) async {
      var currentFrameTimestamp = (_frameCount + 1) * frameDuration;
      var imagePath = '${tempDir.path}/frame-${_frameCount + 1}.jpg';

      if (_controller!.value.position.inSeconds >= currentFrameTimestamp) {
        var response = await _sendFrame(File(imagePath), currentFrameTimestamp.toInt());
        print('Frame sent with status code: ${response.statusCode}');
        _frameCount++;

        if (_frameCount >= frameCount) {
          _timer.cancel();
          _framesSent = true;
          print('Total frames sent: $_frameCount');
        }
      }
    });
  }

  bool _processingResponse = false;
  Future<void> _sendAudio(File audioFile) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${GlobalVars.IP}:8009/postAudio?id=${GlobalVars.lectureID}'), // Replace with your server endpoint
      );

      request.files.add(
        http.MultipartFile(
          'audio',
          audioFile.readAsBytes().asStream(),
          audioFile.lengthSync(),
          filename: path.basename(audioFile.path),
        ),
      );

      setState(() {
        _processingResponse = true;
      });

      var response = await request.send();

      if (response.statusCode == 200) {
        print('Audio sent successfully');
      } else {
        print('Failed to send audio. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending audio: $e');
    }
    setState(() {
      _processingResponse = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null) {
      return Material(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Material(
        child: Scaffold(
          backgroundColor: Color(0xFF674AEF),
          body: Column(
            children: [
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AspectRatio(
                      aspectRatio: _controller!.value.aspectRatio,
                      child: VideoPlayer(_controller!),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            await _stopRecording();
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return FileDownloadPage();
                              }),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 16,
                            ),
                            child: _processingResponse
                                ? CircularProgressIndicator()
                                : Text(
                                    'Stop Recording',
                                    style: TextStyle(
                                      color: Color(0xFF674AEF),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
