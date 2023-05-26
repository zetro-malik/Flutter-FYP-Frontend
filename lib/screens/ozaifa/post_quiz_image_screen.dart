import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../../globalVars.dart';

class ImageUploadScreen extends StatefulWidget {
  @override
  _ImageUploadScreenState createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  File? _image;
  bool _isQuizEnabled = false;
  bool _isUploading = false;
  bool _isEndingClass = false;
  double _thresholdValue = 0.5; // Default threshold value

 

  Future<void> _uploadImage() async {
    if (_image == null) {
      return;
    }
    final isQuizValue = _isQuizEnabled ? '1' : '0';
    final url = Uri.parse('${GlobalVars.IP}:8009/postInterval?id=50&isQuiz=${isQuizValue}&threshold=$_thresholdValue'); // Replace with your server upload URL
    final request = http.MultipartRequest('POST', url);

    final imagePart = await http.MultipartFile.fromPath('img', _image!.path);
    request.files.add(imagePart);
    setState(() {
      _isUploading = true;
    });
    final response = await request.send();

    if (response.statusCode == 200) {
      // Handle success
      print('Image uploaded successfully');
    } else {
      // Handle error
      print('Image upload failed');
    }
    setState(() {
      _isUploading = false;
      _isQuizEnabled= false;
    });
  }

  Future<void> _endClass() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double newThreshold = _thresholdValue;
        return AlertDialog(
          title: Text('Enter Threshold Value'),
          content: TextFormField(
            keyboardType: TextInputType.number,
            initialValue: _thresholdValue.toString(),
            onChanged: (value) {
              newThreshold = double.tryParse(value) ?? _thresholdValue;
            },
          ),
          actions: [
            ElevatedButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Submit'),
              onPressed: () {
                setState(() {
                  _thresholdValue = newThreshold;
                  _isEndingClass = true;
                });
                Navigator.of(context).pop();
                _performEndClassRequest();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _performEndClassRequest() async {
    final url = Uri.parse('${GlobalVars.IP}:8009/endClass?id=50&threshold=$_thresholdValue');
    final request = http.MultipartRequest('POST', url);

    setState(() {
      _isEndingClass = true;
    });
    await request.send();

    setState(() {
      _isEndingClass = false;
    });
  }
Future<void> _selectImage(ImageSource source) async {
    final pickedFile = await ImagePicker().getImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
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
          title: Text('Image Upload'),
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
                      : Image.file(_image!, fit: BoxFit.cover),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Toggle isQuiz',
                    style: TextStyle(fontSize: 16.0),
                  ),
                  SizedBox(width: 8.0),
                  Switch(
                    value: _isQuizEnabled,
                    onChanged: (bool value) {
                      setState(() {
                        _isQuizEnabled = value;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _isUploading ? null : _uploadImage,
                child: _isUploading
                    ? CircularProgressIndicator()
                    : Text('Send Photo'),
                style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                  onPrimary: Colors.white,
                ),
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _isEndingClass ? null : _endClass,
                child: _isEndingClass
                    ? CircularProgressIndicator()
                    : Text('End Class'),
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
