import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import '../../globalVars.dart';

class filedownloadPage extends StatelessWidget {
  const filedownloadPage({super.key});

  static var httpClient = new HttpClient();

  Future<void> downloadFile(String url, String filename) async {
   final file= await _downloadFile(url, filename);
   if (file ==null) return;
   OpenFile.open(file.path); 
  }

  Future<File?> _downloadFile(String url, String filename) async {
    final dir = (await getApplicationDocumentsDirectory()).path;
    File file = File('$dir/$filename');
    try {
      final response = await Dio().get(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          receiveTimeout: 0,
        ),
      );

      final raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      raf.close();
      return file;
    } catch (e) {
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
                Container(
                    width: 150,
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: Colors.green[700],
                        border: Border.all(
                          color: Colors.green,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Center(
                        child: Text(
                      "Download",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ))),
                SizedBox(
                  height: 200,
                ),
                InkWell(
                    onTap: () {
                      downloadFile(
                          "http://192.168.91.52:8009/GetIntervalFile?id=${GlobalVars.lectureID}",
                          "${GlobalVars.lectureID}.pdf");
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
