import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_project_screens/globalVars.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class PhotoUploadScreen extends StatefulWidget {
  @override
  _PhotoUploadScreenState createState() => _PhotoUploadScreenState();
}

class _PhotoUploadScreenState extends State<PhotoUploadScreen> {
  List<File> _imageFiles = [];
  List<Map<String, dynamic>> _jsonDataList = [];
  bool isLoading = false;

  Future<void> _selectImages() async {
    List<File> selectedFiles = [];
    final List<XFile>? pickedFiles = await ImagePicker().pickMultiImage();
    if (pickedFiles != null) {
      for (XFile file in pickedFiles) {
        selectedFiles.add(File(file.path));
      }
      setState(() {
        _imageFiles = selectedFiles;
      });
    }
  }

  Future<void> _uploadImages() async {
    for (File imageFile in _imageFiles) {
      await _uploadImage(imageFile);
    }
  }

  Future<void> _uploadImage(File imageFile) async {
    setState(() {
      isLoading = true;
    });

    final url = '${GlobalVars.IP}:8009/getmodel?ID=50'; // Replace with your server URL

    var request = http.MultipartRequest('GET', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath('img', imageFile.path));

    var response = await request.send();

    if (response.statusCode == 200) {
      final jsonData = await response.stream.bytesToString();
      final decodedData = jsonDecode(jsonData);
      if (decodedData is List) {
        setState(() {
          _jsonDataList = decodedData.cast<Map<String, dynamic>>();
        });
      }
    } else {
      print('Image upload failed with status code ${response.statusCode}');
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photo Upload'),
        backgroundColor: Color(0xFF674AEF),
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildImagePreview(),
          ),
          ElevatedButton(
            onPressed: () => _uploadImages(),
            child: isLoading ? CircularProgressIndicator() : Text('Upload Images'),
            style: ElevatedButton.styleFrom(
              primary: Color(0xFF674AEF),
              onPrimary: Colors.white,
            ),
          ),
          Expanded(
            child: _buildDataList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _selectImages(),
        child: Icon(Icons.add_a_photo),
        backgroundColor: Color(0xFF674AEF),
      ),
    );
  }

  Widget _buildImagePreview() {
    if (_imageFiles.isNotEmpty) {
      return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _imageFiles.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.all(8.0),
            child: Image.file(
              _imageFiles[index],
              width: 150,
              height: 150,
            ),
          );
        },
      );
    } else {
      return Center(
        child: Text('No images selected'),
      );
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
}
