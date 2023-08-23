import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart' as audioplayers;
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';

import '../../globalVars.dart';

class SelectBoardImages extends StatefulWidget {
  @override
  _SelectBoardImagesState createState() => _SelectBoardImagesState();
}

class _SelectBoardImagesState extends State<SelectBoardImages> {

  List<Map<String, dynamic>> jsonData = [];
  bool isLoading = true;
  List<String> _recordedAudioList = [];
  FlutterSoundPlayer _flutterSoundPlayer = FlutterSoundPlayer();
  FlutterSoundRecorder audioRecorder = FlutterSoundRecorder();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void dispose() {
    _flutterSoundPlayer.closePlayer();
    super.dispose();
  }

  Future<void> fetchData() async {
    final response =
        await http.get(Uri.parse('${GlobalVars.IP}:8009/getBoardJson?id=2126'));
    if (response.statusCode == 200) {
      setState(() {
        jsonData = json.decode(response.body).cast<Map<String, dynamic>>();
        isLoading = false;
        _recordedAudioList = List.generate(jsonData.length, (_) => '');
      });
    }
  }

  Future<void> updateCheckbox(bool value, int index) async {
    setState(() {
      jsonData[index]['isChecked'] = value;
    });
    // Send API request or perform any necessary operations to update the original JSON
  }

  Future<void> updateTitle(String value, int index) async {
    setState(() {
      jsonData[index]['title'] = value;
    });
    // Send API request or perform any necessary operations to update the original JSON
  }

  Future<void> sendUpdatedJsonToServer() async {
    // Convert jsonData back to JSON string
    final jsonString = json.encode(jsonData);

    // Send the jsonString to the server using http.post or any suitable method
    // Example:
    final response = await http.post(
      Uri.parse('${GlobalVars.IP}:8009/postBoardJson?id=2118'),
      headers: {'Content-Type': 'application/json'},
      body: jsonString,
    );
    if (response.statusCode == 200) {
      // Data successfully sent to the server
      print('Data sent to server');
    }
  }

  Future<void> startRecording(int index) async {
    final directory = await getApplicationDocumentsDirectory();
    final audioPath = '${directory.path}/audio.aac';

    // Start recording audio
    await audioRecorder.openRecorder();
    await audioRecorder.startRecorder(toFile: audioPath, codec: Codec.aacADTS);
  }

  Future<void> stopRecording(int index) async {
    await audioRecorder.stopRecorder();

    // Send the audio file to the server
    final directory = await getApplicationDocumentsDirectory();
    final audioPath = '${directory.path}/audio.aac';
    final file = File(audioPath);

    final bytes = await file.readAsBytes();
    final base64Audio = base64Encode(bytes);

    setState(() {
      jsonData[index]['customAudio'] = base64Audio;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("the json is ${jsonData}");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF674AEF),
        title: Text('Lecture Data'),
      ),
      body: isLoading
          ? Center(
              child:
                  CircularProgressIndicator()) // Show a loading indicator if data is being fetched
          : ListView.builder(
              itemCount: jsonData.length,
              itemBuilder: (BuildContext context, int index) {
                final item = jsonData[index];
                final imageBytes = base64Decode(item['image_bytes']);
                final audioBytes = base64Decode(item['audio_bytes']);
                final startAudio = item['start_audio'];
                final endAudio = item['end_audio'];

                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color:
                      Color(0xFF674AEF), // Set the background color of the card
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        12), // Rounded corners for the card
                  ),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(12)),
                        child: Image.memory(
                          imageBytes,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 200, // Adjust the desired height as needed
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors
                              .white, // Use a white background for the text field
                        ),
                        child: TextFormField(
                          initialValue: item['title'],
                          onChanged: (value) => updateTitle(value, index),
                          decoration: InputDecoration(
                            labelText: 'Title',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                          ),
                        ),
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Checkbox(
                            value: item['isChecked'],
                            onChanged: (value) => updateCheckbox(value!, index),
                          ),
                          Text('Include this image',
                              style: TextStyle(
                                  color:
                                      Colors.white)), // Set text color to white
                        ],
                      ),
                      SizedBox(height: 4),
                      AudioPlayerWidget(
                        audioBytes: audioBytes,
                        startAudio: startAudio,
                        endAudio: endAudio,
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Checkbox(
                            value: item['isChecked'],
                            onChanged: (value) => updateCheckbox(value!, index),
                          ),
                          Text('Include this audio',
                              style: TextStyle(
                                  color:
                                      Colors.white)), // Set text color to white
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.mic,
                                color: Colors.white), // Set icon color to white
                            onPressed: () => startRecording(index),
                          ),
                          IconButton(
                            icon: Icon(Icons.stop,
                                color: Colors.white), // Set icon color to white
                            onPressed: () => stopRecording(index),
                          ),
                          Text('Record new Audio',
                              style: TextStyle(
                                  color:
                                      Colors.white)), // Set text color to white
                        ],
                      ),
                      SizedBox(height: 16),
                       // Set the divider color to white for better visual separation
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF674AEF),
        onPressed: sendUpdatedJsonToServer,
        child: Icon(Icons.send,),
      ),
    );
  }
}

class AudioPlayerWidget extends StatefulWidget {
  final Uint8List audioBytes;
  final String startAudio;
  final String endAudio;

  AudioPlayerWidget({
    required this.audioBytes,
    required this.startAudio,
    required this.endAudio,
  });

  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late audioplayers.AudioPlayer _audioPlayer;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = audioplayers.AudioPlayer();
    _audioPlayer.onPlayerStateChanged.listen((audioplayers.PlayerState s) {
      if (s == audioplayers.PlayerState.completed) {
        setState(() => _isPlaying = false);
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playAudio() async {
    await _audioPlayer.play(audioplayers.BytesSource(widget.audioBytes));
    setState(() => _isPlaying = true);
  }

  void _stopAudio() async {
    await _audioPlayer.stop();
    setState(() => _isPlaying = false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 8),
        GestureDetector(
          onTap: _isPlaying ? _stopAudio : _playAudio,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            width: 45, // Adjust the size of the player button as needed
            height: 45,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors
                  .blue, // Replace with your preferred color for the player button
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.5),
                  spreadRadius: 3,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Icon(
                _isPlaying ? Icons.stop : Icons.play_arrow,
                color: Colors.white,
                size: 32, // Adjust the size of the icon as needed
              ),
            ),
          ),
        ),
      ],
    );
  }
}
