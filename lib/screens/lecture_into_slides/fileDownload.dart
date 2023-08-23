import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_screens/globalVars.dart';
import 'package:flutter_project_screens/screens/lecture_into_slides/view+pptx_screen.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class FileDownloadPage extends StatefulWidget {
  const FileDownloadPage({Key? key}) : super(key: key);

  @override
  _FileDownloadPageState createState() => _FileDownloadPageState();
}

class _FileDownloadPageState extends State<FileDownloadPage> {
  bool _inProgress = false;
  String jsonData = '';
  bool _inProgressdonwload = false;

  Future<void> downloadFile(String url, String filename) async {
    print("in this");
    final file = await _downloadFile(url, filename);
    if (file == null) return;
    OpenFile.open(file.path);
  }


Future<File?> _downloadFile(String url, String filename) async {
  final dir = await getApplicationDocumentsDirectory();
  final filePath = '${dir.path}/$filename';

  setState(() {
    _inProgressdonwload = true;
  });

  try {
    final response = await Dio().get(
      url,
      options: Options(
        responseType: ResponseType.bytes,
        followRedirects: false,
        receiveTimeout: 0,
      ),
    );

    final file = File(filePath);
    await file.writeAsBytes(response.data);

    setState(() {
      _inProgressdonwload = false;
    });

    // Copy the file to the external storage directory
    final externalDir = await getExternalStorageDirectory();
    final destPath = '${externalDir!.path}/$filename';
    await file.copy(destPath);

    // Open the copied file
    OpenFile.open(destPath);

    return file;
  } catch (e) {
    setState(() {
      _inProgressdonwload = false;
    });
    return null;
  }
}

  Future<void> makeFile() async {
    setState(() {
      _inProgress=true;
    });
    final response = await http.get(Uri.parse('${GlobalVars.IP}:8009/makeFile?id=${GlobalVars.lectureID}'));
    if (response.statusCode == 200) {
      final parsedJson = json.decode(response.body);
      setState(() {
        jsonData = json.encode(parsedJson);
      });
    }
    setState(() {
      _inProgress=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Download Screen'),backgroundColor:  GlobalVars.themecolor,),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 150.0, right: 30, left: 30),
            child: Center(
              child: Column(
               
                children: [
                  Center(
                    child: Column(
                      children: [
                        Transform.scale(
                          scale: 6,
                          child: Icon(Icons.file_open),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height:40 ,),
                  
                  // GestureDetector(
                  //   onTap: () async {
                  //    await makeFile();
                     
                  //   },
                  //   child: Container(
                  //     width: 150,
                  //     padding: EdgeInsets.all(12),
                  //     decoration: BoxDecoration(
                  //       color: GlobalVars.themecolor,
                  //       border: Border.all(color: Colors.green),
                  //       borderRadius: BorderRadius.all(Radius.circular(5)),
                  //     ),
                  //     child: Center(
                  //       child: _inProgress
                  //           ? CircularProgressIndicator()
                  //           : Text(
                  //               'Make Slide',
                  //               style: TextStyle(
                  //                 color: Colors.white,
                  //                 fontSize: 20,
                  //               ),
                  //             ),
                  //     ),
                  //   ),
                  // ),
                  // SizedBox(height: 20),
                  // jsonData.isNotEmpty
                  //     ? Container(
                  //         width: 300,
                  //         padding: EdgeInsets.all(12),
                  //         decoration: BoxDecoration(
                  //           color: Colors.white,
                  //           border: Border.all(color: Colors.grey),
                  //           borderRadius: BorderRadius.all(Radius.circular(5)),
                  //         ),
                  //         child: Text(
                  //           jsonData,
                  //           style: TextStyle(
                  //             color: Colors.black,
                  //             fontSize: 16,
                  //           ),
                  //         ),
                  //       )
                  //     : Container(
                  //         width: 300,
                          
                  //         padding: EdgeInsets.all(12),
                  //         decoration: BoxDecoration(
                  //           color: Colors.white,
                  //           border: Border.all(color: Colors.grey),
                  //           borderRadius: BorderRadius.all(Radius.circular(5)),
                  //         ),
                  //         child: Text("MetaData not recieved")
                  //       ),
                        SizedBox(height: 100),
                        GestureDetector(
                    onTap: ()  {
                     Navigator.push(context, MaterialPageRoute(builder: (context) {
                       return PPTXviewer();
                     },));
                    },
                    child: Container(
                        width: 200,
                        height: 65,
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.yellow[900],
                          border: Border.all(color: Color.fromARGB(255, 250, 249, 246)),
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                      
                      child:Center(
                        child: Text(
                                'View Lecture',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  GestureDetector(
                    onTap: () async {
                     await  downloadFile('${GlobalVars.IP}:8009/getFile?id=${GlobalVars.lectureID}', '50.pptx');
                    },
                    child: Container(
                        width: 200,
                        height: 65,
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green[700],
                          border: Border.all(color: Colors.green),
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                      
                      child:Center(
                        child: _inProgressdonwload
                            ? CircularProgressIndicator()
                            : Text(
                                'Download',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                      ),
                    ),
                  ),
                  SizedBox(height: 200),
                 
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

