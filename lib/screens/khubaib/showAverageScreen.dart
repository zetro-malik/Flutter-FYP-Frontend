import 'dart:convert';
import 'package:flutter_project_screens/screens/khubaib/showDataScreen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../globalVars.dart';

class AverageScreenView extends StatefulWidget {
  const AverageScreenView({super.key});

  @override
  State<AverageScreenView> createState() => _AverageScreenViewState();
}

class _AverageScreenViewState extends State<AverageScreenView> {
  List<Map<String, dynamic>> _jsonDataList = [];

  Future<void> _fetchJsonData() async {
    final jsonUrl =
        '${GlobalVars.IP}:8009/getjsondata?ID=${GlobalVars.lectureID}'; // Replace with the URL for JSON data
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
          final name = data['name'];
          final activity = data['activity'];
          return Card(
            elevation: 2,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(
                name,
                style: TextStyle(fontSize: 14),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 4),
                  Text(
                    'Student Name: ${data['studentName']}',
                    style: TextStyle(fontSize: 12),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Activity: $activity',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(height: 4),
                  Text(
                    'Start Time: ${data['startTime']}',
                    style: TextStyle(fontSize: 12),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'End Time: ${data['endTime'] ?? "Not Ended"}',
                    style: TextStyle(fontSize: 12),
                  ),
                  SizedBox(height: 4),
                ],
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Average Screen'),
        backgroundColor: Colors.blue,
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () => _fetchJsonData(),
              child: Text(
                'Fetch Data',
                style: TextStyle(fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.blue,
                onPrimary: Colors.white,
              ),
            ),
            SizedBox(
              height: 10,
            ),
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
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return DataScreen();
                    },
                  ));
                },
                child: Text('Next')),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
