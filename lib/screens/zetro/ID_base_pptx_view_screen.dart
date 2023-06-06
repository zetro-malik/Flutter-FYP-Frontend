
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_project_screens/globalVars.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';


class IDbasedPPTXviewer extends StatefulWidget {

   final int lectureID;

  IDbasedPPTXviewer({required this.lectureID});
  @override
  _viewPptxState createState() => _viewPptxState();
}

class _viewPptxState extends State<IDbasedPPTXviewer> {
  List<Map<String, Uint8List>> dataList = [];
  int expandedIndex = -1;
  bool isLandscapeMode = false;
  double imageSwipePosition = 0.0;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('${GlobalVars.IP}:8009/convert?id=${widget.lectureID}'));

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);

      setState(() {
        dataList = responseData.map<Map<String, Uint8List>>((item) {
          return {
            'image': base64.decode(item['image']),
            'audio': base64.decode(item['audio']),
          };
        }).toList();
      });
    } else {
      print('Failed to fetch data');
    }
  }

  void toggleImageSize(int index, BuildContext context) {
    setState(() {
      if (expandedIndex == index) {
        expandedIndex = -1;
        
      } else {
        expandedIndex = index;
        
      }
    });
  }

  void toggleLandscapeMode() {
    setState(() {
      isLandscapeMode = !isLandscapeMode;

      if (isLandscapeMode) {
        SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
      } else {
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
      }
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lecture View'),
         backgroundColor: Color(0xFF674AEF),
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.screen_rotation),
        //     onPressed: toggleLandscapeMode,
        //   ),
        // ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.deepPurple[900]!.withOpacity(0.7),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: dataList.length > 0
              ? SingleChildScrollView(
                  child: Column(
                    children: dataList.asMap().entries.map((entry) {
                      final index = entry.key;
                      final data = entry.value;
                      AudioPlayer audioPlayer = AudioPlayer();
                      return Container(
                        margin: EdgeInsets.only(bottom: 16.0),
                        padding: EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: Color.fromARGB(255, 200, 188, 254),
                        ),
                        child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Board ${index+1}',style: TextStyle(fontSize: 24,fontWeight: FontWeight.w500),),
                            SizedBox(height:20,),
                            ListTile(
                          title: GestureDetector(
                            onTap: () => toggleImageSize(index, context),
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                              height: expandedIndex == index ? 350 : 150.0,
                              child: InteractiveViewer(
                                
                                child: Image.memory(
                                  data['image']!,
                                  fit: BoxFit.contain,
                                  alignment: Alignment(imageSwipePosition / 100, 0.0),
                                ),
                              ),
                            ),
                          ),
                          subtitle: AudioPlayerWidget(
                            audioBytes: data['audio']!,
                            audioPlayer: audioPlayer,
                          ),
                        ),
                          ],
                        )
                      );
                    }).toList(),
                  ),
                )
              : Center(
                  child: CircularProgressIndicator(),
                ),
        ),
      ),
    );
  }
}

class AudioPlayerWidget extends StatefulWidget {
  final Uint8List audioBytes;
  final AudioPlayer audioPlayer;

  AudioPlayerWidget({required this.audioBytes, required this.audioPlayer});

  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late AudioPlayer audioPlayer;
  double audioDuration = 0.0;
  double audioPosition = 0.0;
  bool isAudioPlaying = false;

  @override
  void initState() {
    super.initState();
    audioPlayer = widget.audioPlayer;
    setupAudioPlayer();
  }

  void setupAudioPlayer() {
    audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        audioDuration = duration.inMilliseconds.toDouble();
      });
    });

    audioPlayer.onPositionChanged.listen((position) {
      setState(() {
        audioPosition = position.inMilliseconds.toDouble();
      });
    });
  }

  void playAudio() async {
    await audioPlayer.stop();
    await audioPlayer.play(BytesSource(widget.audioBytes));
    setState(() {
      isAudioPlaying = true;
    });
    print('Audio playing');
  }

  void pauseAudio() async {
    await audioPlayer.pause();
    setState(() {
      isAudioPlaying = false;
    });
    print('Audio paused');
  }

  void seekAudio(double position) {
    audioPlayer.seek(Duration(milliseconds: position.toInt()));
    setState(() {
      audioPosition = position;
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
       
          Slider(
            value: audioPosition,
            min: 0.0,
            max: audioDuration,
            onChanged: (value) {
              seekAudio(value);
            },
            activeColor: Color(0xFF674AEF),
            inactiveColor: Colors.white.withOpacity(0.5),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              iconSize: 35,
              icon: Icon(isAudioPlaying ? Icons.pause : Icons.play_arrow),
              onPressed: isAudioPlaying ? pauseAudio : playAudio,
              color: Color(0xFF674AEF),
            ),
          ],
        ),
      ],
    );
  }
}
