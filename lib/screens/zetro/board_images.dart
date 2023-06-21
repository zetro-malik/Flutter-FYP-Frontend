import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart' as audioplayers;
import 'package:flutter_sound/flutter_sound.dart';
import 'package:dartx/dartx.dart';

import '../../globalVars.dart';
import 'package:flutter_project_screens/screens/zetro/fileDownload.dart';

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
  List<bool> bul = [];

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
    print('asdasdasdasdasdasddsa');
    final response = await http.get(Uri.parse('${GlobalVars.IP}:8009/getBoardJson?id=${GlobalVars.lectureID}'));
    if (response.statusCode == 200) {
      setState(() {
        jsonData = json.decode(response.body).cast<Map<String, dynamic>>();
        isLoading = false;
        _recordedAudioList = List.generate(jsonData.length, (_) => '');
        bul = List.generate(jsonData.length, (_) => false);
      });
    }
  }

  Future<void> updateCheckbox(bool value, int index) async {
    setState(() {
      jsonData[index]['isChecked'] = value;
    });
  }

  Future<void> updateTitle(String value, int index) async {
    setState(() {
      jsonData[index]['title'] = value;
    });
  }

  Future<void> sendUpdatedJsonToServer() async {
    final jsonString = json.encode(jsonData);

    final response = await http.post(
      Uri.parse('${GlobalVars.IP}:8009/postBoardJson?id=${GlobalVars.lectureID}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonString,
    );

    if (response.statusCode == 200) {
      print('Data sent to server');
    }
  }

  Future<void> startRecording(int index) async {
    setState(() {
      bul[index] = true;
    });

    final directory = await getApplicationDocumentsDirectory();
    final audioPath = '${directory.path}/audio.aac';

    await audioRecorder.openRecorder();
    await audioRecorder.startRecorder(toFile: audioPath, codec: Codec.aacADTS);
  }

  Future<void> stopRecording(int index) async {
    setState(() {
      bul[index] = false;
    });

    await audioRecorder.stopRecorder();

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
    print("the json is $bul");
    return Scaffold(
      appBar: AppBar(
        title: Text('My Screen'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
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
                  child: Column(
                    children: [
                      Image.memory(
                        imageBytes,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 200,
                      ),
                        SizedBox(height: 16),
                       TextFormField(
          initialValue: item['title'],
          onChanged: (value) => updateTitle(value, index),
          decoration: InputDecoration(
            labelText: 'Title',
            border: OutlineInputBorder(),
          ),
        ),
        Divider(),
                      SizedBox(height: 16),
                      AudioPlayerWidget(
                        audioBytes: audioBytes,
                        startAudio: startAudio,
                        endAudio: endAudio,
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          bul[index] == false
                              ? IconButton(
                                  icon: Icon(Icons.mic, color: Colors.blue, size: 30),
                                  onPressed: () => startRecording(index),
                                )
                              : IconButton(
                                  icon: Icon(Icons.stop, color: Colors.red),
                                  onPressed: () => stopRecording(index),
                                ),
                          Text('Record Audio'),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Checkbox(
                            value: item['isChecked'],
                            onChanged: (value) => updateCheckbox(value!, index),
                          ),
                          Text('Include Audio'),
                        ],
                      ),
                      Divider(),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await sendUpdatedJsonToServer();
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return FileDownloadPage();
          }));
        },
        child: Icon(Icons.send),
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
        Text('Orginal Audio'),
        _isPlaying
            ? IconButton(
                icon: Icon(Icons.stop),
                onPressed: _stopAudio,
              )
            : IconButton(
                icon: Icon(Icons.play_arrow),
                onPressed: _playAudio,
              ),
      ],
    );
  }
}
