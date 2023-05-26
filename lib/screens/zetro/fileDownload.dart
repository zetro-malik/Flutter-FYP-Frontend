import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import '../../globalVars.dart';

class filedownloadPage extends StatefulWidget {
  const filedownloadPage({super.key});

  static var httpClient = new HttpClient();

  @override
  State<filedownloadPage> createState() => _filedownloadPageState();
}

class _filedownloadPageState extends State<filedownloadPage> {
  bool _inProgress= false;

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
    _inProgress = true;
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
      _inProgress = false;
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
      _inProgress = false;
    });
    return null;
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 150.0, right: 30, left: 30),
            child: Center(
              child: Column(children: [
                Center(
                  child: Column(children: [
                    Transform.scale(scale: 6, child: Icon(Icons.file_open))
                  ]),
                ),
                SizedBox(
                  height: 70,
                ),
                SizedBox(
                  height: 40,
                ),
                GestureDetector(
                  onTap: () {
                     downloadFile(
                          "${GlobalVars.IP}:8009/getFile?id=50",
                          "50.pptx");
                  },
                  child: Container(
                      width: 150,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          color: Colors.green[700],
                          border: Border.all(
                            color: Colors.green,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                      child: Center(
                          child:_inProgress?CircularProgressIndicator() :Text(
                        "Download",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ))),
                ),
                SizedBox(
                  height: 200,
                ),
                InkWell(
                    onTap: () {
                     
                    },
                    child: NativeButton())
              ]),
            ),
          ),
        ),
      ),
    );
  }

  Container NativeButton() {
    return Container(
        width: 250,
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: Colors.blue,
            border: Border.all(
              color: Colors.blue,
            ),
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Center(
            child: Text(
          "Done",
          style: TextStyle(color: Colors.white, fontSize: 22),
        )));
  }
}
