import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../globalVars.dart';
import 'package:flutter_project_screens/screens/zetro/ID_base_pptx_view_screen.dart';

class directorView extends StatefulWidget {
  @override
  _directorViewState createState() => _directorViewState();
}

class _directorViewState extends State<directorView> {
  List<Map<String, dynamic>> _jsonDataList = [];

  Future<void> _fetchJsonData() async {
    final jsonUrl = '${GlobalVars.IP}:8009/getAllLecturesInfo'; // Replace with the URL for JSON data
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
      print('Failed to get JSON data with status code ${jsonResponse.statusCode}');
    }
  }

  Widget _buildDataList() {
    if (_jsonDataList.isNotEmpty) {
      return ListView.builder(
        itemCount: _jsonDataList.length,
        itemBuilder: (context, index) {
          final data = _jsonDataList[index];
          final lectureId = data['lectureID'];
          final classs = data['class'];
          final section = data['section'];
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return IDbasedPPTXviewer(lectureID: lectureId);
                  },
                ),
              );
            },
            child: Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$classs $section',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF674AEF),
                      ),
                      textAlign: TextAlign.start,
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          'Course: ',
                          style: TextStyle(fontSize: 15, color: Colors.blue),
                          textAlign: TextAlign.start,
                        ),
                        Text(
                          '${data['course']}',
                          style: TextStyle(fontSize: 15, color: Colors.grey),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          'Teacher: ',
                          style: TextStyle(fontSize: 15, color: Colors.red),
                          textAlign: TextAlign.start,
                        ),
                        Text(
                          '${data['teacher']}',
                          style: TextStyle(fontSize: 15, color: Colors.grey),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          'Date: ',
                          style: TextStyle(fontSize: 15, color: Colors.green),
                          textAlign: TextAlign.start,
                        ),
                        Text(
                          '${data['date']}',
                          style: TextStyle(fontSize: 15, color: Colors.grey),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } else {
      return Center(
        child: Text(
          'No data available',
          style: TextStyle(fontSize: 16),
        ),
      );
    }
  }

  void initState() {
    super.initState();
    _fetchJsonData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Director View',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFF674AEF),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 30),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width - 20,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: _buildDataList(),
              ),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
