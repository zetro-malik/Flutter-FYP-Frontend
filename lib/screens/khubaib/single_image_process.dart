import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_project_screens/globalVars.dart';
import 'package:flutter_project_screens/screens/khubaib/showAverageScreen.dart';
import 'package:flutter_project_screens/screens/khubaib/showDataScreen.dart';
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
    _imageFiles = [];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select Image Source"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  _getImageFromCamera(); // Call the method to get image from camera
                },
                child: Text("Camera"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  _getImageFromgallery(); // Call the method to get image from gallery
                },
                child: Text("Gallery"),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _getImageFromCamera() async {
    final imageFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (imageFile != null) {
      setState(() {
        _imageFiles.add(File(imageFile.path));
      });
    }
  }

  Future<void> _getImageFromgallery() async {
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
      await _fetchJsonData();
    }
  }

  Future<void> _uploadImage(File imageFile) async {
    setState(() {
      isLoading = true;
    });

    final url =
        '${GlobalVars.IP}:8009/getmodel?ID=${GlobalVars.lectureID}'; // Replace with your server URL

    var request = http.MultipartRequest('GET', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath('img', imageFile.path));

    var response = await request.send();

    if (response.statusCode != 200) {
      print('Image upload failed with status code ${response.statusCode}');
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _fetchJsonData() async {
    final jsonUrl =
        '${GlobalVars.IP}:8009/getActivitiesPerImage?ID=${GlobalVars.lectureID}'; // Replace with the URL for JSON data
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () => _uploadImages(),
                child: isLoading
                    ? CircularProgressIndicator()
                    : Text('Upload Images'),
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 61, 25, 219),
                  onPrimary: Colors.white,
                ),
              ),
              SizedBox(
                width: 5,
              ),
              ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AverageScreenView()));
                      },
                child: Text('End lecture'),
                style: ElevatedButton.styleFrom(
                  primary: isLoading
                      ? Color.fromARGB(255, 191, 188, 202).withOpacity(0.5)
                      : Color.fromARGB(255, 61, 25, 219),
                  onPrimary: Colors.white,
                ),
              ),
            ],
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
              width: 330,
              height: 330,
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
                SizedBox(
                  width: 5,
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
