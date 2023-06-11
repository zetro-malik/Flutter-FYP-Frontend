import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../../globalVars.dart';

class nextscreen extends StatefulWidget {
  @override
  _ImageUploadScreenState createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<nextscreen> {
  bool _isUploading = false;
  double _thresholdValue = 0.5; // Default threshold value
  File? _image;
  Uint8List? imageData;
  String? imageUrl;
  List<dynamic> data = [];

  Future<void> _selectImage(ImageSource source) async {
    setState(() {
      imageData = null;
    });
    final pickedFile = await ImagePicker().getImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> getDepth() async {
    if (_image == null) {
      return;
    }
    final url = Uri.parse('${GlobalVars.IP}:8009/getDepthwithJson');
    final request = http.MultipartRequest('GET', url);

    final imagePart = await http.MultipartFile.fromPath('img', _image!.path);
    request.files.add(imagePart);

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final jsonData = json.decode(responseBody);
      setState(() {
        data = jsonData['data'];
        imageUrl = jsonData['image_url'];
      });
      imageData = await response.stream.toBytes();
      setState(() {});
    }
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select Image Source'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    _selectImage(ImageSource.gallery);
                  },
                  child: Text('Gallery'),
                ),
                SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    _selectImage(ImageSource.camera);
                  },
                  child: Text('Camera'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: Color(0xFF674AEF),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text('Show Rows'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: _image == null
                      ? Center(
                          child: Text(
                            'No image selected',
                            style: TextStyle(fontSize: 16.0),
                          ),
                        )
                      : imageUrl == null
                          ? Image.file(_image!)
                          : Image(
                              image: NetworkImage('${GlobalVars.IP}\\${imageUrl}'),
                            ),
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _showImageSourceDialog,
                child: Text('Pick Image'),
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                  onPrimary: Colors.white,
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _isUploading ? null : getDepth,
                child: _isUploading
                    ? CircularProgressIndicator()
                    : Text('Send Photo'),
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                  onPrimary: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
