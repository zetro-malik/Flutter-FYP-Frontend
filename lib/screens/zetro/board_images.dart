import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../globalVars.dart';

class SelectBoardImages extends StatefulWidget {
  @override
  _SelectBoardImagesState createState() => _SelectBoardImagesState();
}

class _SelectBoardImagesState extends State<SelectBoardImages> {
  List<Map<String, dynamic>> jsonData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('${GlobalVars.IP}:8009/getBoardJson?id=${GlobalVars.lectureID}'));
    if (response.statusCode == 200) {
      setState(() {
        jsonData = json.decode(response.body).cast<Map<String, dynamic>>();
        isLoading = false;
      });
    }
  }

  Future<void> updateCheckbox(bool value, int index) async {
    setState(() {
      jsonData[index]['isChecked'] = value;
    });
    // Send API request or perform any necessary operations to update the original JSON
  }

  Future<void> updateTitle(String value, int index) async {
    setState(() {
      jsonData[index]['title'] = value;
    });
    // Send API request or perform any necessary operations to update the original JSON
  }

  Future<void> sendUpdatedJsonToServer() async {
   // Convert jsonData back to JSON string
    final jsonString = json.encode(jsonData);

    // Send the jsonString to the server using http.post or any suitable method
    // Example:
    final response =  await http.post(
  Uri.parse('${GlobalVars.IP}:8009/postBoardJson?id=${GlobalVars.lectureID}'),
  headers: {'Content-Type': 'application/json'},
  body: jsonString,
);
    if (response.statusCode == 200) {
      // Data successfully sent to the server
      print('Data sent to server');
    }
  }

  @override
  Widget build(BuildContext context) {
    print("the json is ${jsonData}");
    return Scaffold(
      appBar: AppBar(
        title: Text('My Screen'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Show a loading indicator if data is being fetched
          : ListView.builder(
              itemCount: jsonData.length,
              itemBuilder: (BuildContext context, int index) {
                final item = jsonData[index];
                final url = item['image_path'];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    children: [
                      Image.network(
                        '${GlobalVars.IP}:8009/$url',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 200, // Adjust the desired height as needed
                      ),
                      SizedBox(height: 16),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: TextFormField(
                          initialValue: item['title'],
                          onChanged: (value) => updateTitle(value, index),
                          decoration: InputDecoration(
                            labelText: 'Title',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Checkbox(
                            value: item['isChecked'],
                            onChanged: (value) => updateCheckbox(value!, index),
                          ),
                          Text('Include this image'),
                        ],
                      ),
                      Divider(), // Add a divider for better visual separation
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: sendUpdatedJsonToServer,
        child: Icon(Icons.send),
      ),
    );
  }
}
