import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_project_screens/screens/khubaib/showDataScreen.dart';
import 'package:http/http.dart' as http;
import '../../globalVars.dart';
import 'directorViewPerLecture.dart';

class directorView extends StatefulWidget {
  const directorView({super.key});

  @override
  State<directorView> createState() => _directorViewState();
}

class _directorViewState extends State<directorView> {
  List<Map<String, dynamic>> _jsonDataList = [];

  Future<void> _fetchJsonData() async {
    final jsonUrl =
        '${GlobalVars.IP}:8009/getAllLecturesInfo'; // Replace with the URL for JSON data
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
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return directorViewPerLecture(
                      lectureID: lectureId,
                    );
                  },
                ));
              },
              child: Card(
                elevation: 2,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(
                    '$classs $section',
                    style: TextStyle(fontSize: 14),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 4),
                      Text(
                        'Course: ${data['course']}',
                        style: TextStyle(fontSize: 12),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Teacher: ${data['teacher']}',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  trailing: Text(
                    'Date : ${data['date']}',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
            );
          });
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
        title: Text('Director View'),
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),

            // ElevatedButton(
            //   onPressed: () => _fetchJsonData(),
            //   child: Text(
            //     'Fetch Data',
            //     style: TextStyle(fontSize: 16),
            //   ),
            //   style: ElevatedButton.styleFrom(
            //     primary: Colors.blue,
            //     onPrimary: Colors.white,
            //   ),
            // ),
            // SizedBox(
            //   height: 10,
            // ),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width - 10,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: _buildDataList(),
              ),
            ),
            SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}
