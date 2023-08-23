import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_screens/globalVars.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';


class directorView extends StatefulWidget {
  const directorView({Key? key}) : super(key: key);

  @override
  State<directorView> createState() => _directorViewState();
}

class _directorViewState extends State<directorView> {
  List<Map<String, dynamic>> _jsonDataList = [];
  List<Map<String, dynamic>> _filteredDataList = [];
  String _searchText = '';
  String _selectedFilter = 'All';
  String _selectedTeacher = 'All';
  String _selectedCourse = 'All';
  DateTime? _selectedDate;

  Future<void> _fetchJsonData() async {
    final jsonUrl = '${GlobalVars.IP}:8009/getAllLecturesInfo'; // Replace with your JSON data URL
    var jsonResponse = await http.get(Uri.parse(jsonUrl));

    if (jsonResponse.statusCode == 200) {
      final jsonResult = json.decode(jsonResponse.body);
      if (jsonResult is List) {
        setState(() {
          _jsonDataList = jsonResult.cast<Map<String, dynamic>>();
          _jsonDataList = _jsonDataList.reversed.toList();
          _filterData();
        });
      }
    } else {
      print('Failed to get JSON data with status code ${jsonResponse.statusCode}');
    }
  }

  void _filterData() {
    _filteredDataList = _jsonDataList.where((data) {
      if (_selectedFilter == 'All' && _selectedTeacher == 'All' && _selectedCourse == 'All') {
        return true;
      } else if (_selectedFilter != 'All' && _selectedTeacher != 'All' && _selectedCourse != 'All') {
        return data['class'] == _selectedFilter &&
            data['teacher'] == _selectedTeacher &&
            data['course'] == _selectedCourse;
      } else if (_selectedFilter != 'All' && _selectedTeacher != 'All') {
        return data['course'] == _selectedFilter &&
            data['teacher'] == _selectedTeacher;
      } else if (_selectedFilter != 'All' && _selectedCourse != 'All') {
        return data['course'] == _selectedFilter &&
            data['course'] == _selectedCourse;
      } else if (_selectedTeacher != 'All' && _selectedCourse != 'All') {
        return data['teacher'] == _selectedTeacher &&
            data['course'] == _selectedCourse;
      } else if (_selectedFilter != 'All') {
        return data['course'] == _selectedFilter;
      } else if (_selectedTeacher != 'All') {
        return data['teacher'] == _selectedTeacher;
      } else {
        return data['course'] == _selectedCourse;
      }
    }).toList();
  }

  Widget _buildDataList() {
    List<Map<String, dynamic>> filteredDataList = _filteredDataList;

    if (_searchText.isNotEmpty) {
      filteredDataList = filteredDataList.where((data) {
        return data['class'].toLowerCase().contains(_searchText) ||
            data['section'].toLowerCase().contains(_searchText) ||
            data['course'].toLowerCase().contains(_searchText) ||
            data['teacher'].toLowerCase().contains(_searchText);
          
      }).toList();
    }

    if (_selectedDate != null) {
      final selectedDateFormatted = DateFormat('MM/dd/yy').format(_selectedDate!);
      filteredDataList = filteredDataList.where((data) {
        final dataDateParts = data['date'].split('_')[0].split('/');
        final dataDate = dataDateParts[0];
        final dataMonth = dataDateParts[1];
        final dataYear = dataDateParts[2];

        final selectedDateParts = selectedDateFormatted.split('/');
        final selectedDate = selectedDateParts[0];
        final selectedMonth = selectedDateParts[1];
        final selectedYear = selectedDateParts[2];

        return dataDate == selectedDate &&
            dataMonth == selectedMonth &&
            dataYear == selectedYear;
      }).toList();
    }

    if (filteredDataList.isNotEmpty) {
      return ListView.builder(
        itemCount: filteredDataList.length,
        itemBuilder: (context, index) {
          final data = filteredDataList[index];
          final lectureId = data['lectureID'];
          final classs = data['class'];
          final section = data['section'];
           final time = data['date'].split('_')[1];
          final formattedTime = DateFormat.jm().format(DateTime.parse('2000-01-01 $time'));
          return InkWell(
            onTap: () {
              // Add your onTap logic here
            },
            child: Card(
              elevation: 2,
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: ListTile(
                title: Text(
                  '$classs $section',
                  style: TextStyle(fontSize: 14,color:  Color(0xFF674AEF),fontWeight: FontWeight.w600),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 4),
                   Row(
                    children: [
                       Text(
                      'Course: ',
                      style: TextStyle(fontSize: 12,color: Colors.lightBlueAccent),
                    ),
                      Text(
                      '${data['course']}',
                      style: TextStyle(fontSize: 12,color: Colors.grey[900]),
                    ),
                    ],
                   ),
                    SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                      'Teacher: ',
                      style: TextStyle(fontSize: 12,color: Colors.redAccent),
                    ),
                     Text(
                      '${data['teacher']}',
                      style: TextStyle(fontSize: 12,color: Colors.grey[900]),
                    ),
                      ],
                    )
                  ],
                ),
                trailing: Column(
                  children: [
                    Text(
                      'Date: ${data['date'].split('_')[0]}',
                      style: TextStyle(fontSize: 12),
                    ),
                    SizedBox(height: 10,),
                    Text(
                      'Time: ${formattedTime}',
                      style: TextStyle(fontSize: 12),
                    ),
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

  @override
  void initState() {
    super.initState();
    _fetchJsonData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Director View'),
        backgroundColor: Color(0xFF674AEF),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    _searchText = value.toLowerCase();
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Color(0xFFEDEDED),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
           Row(
            
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
   DropdownButton<String>(
    
  value: _selectedFilter,
  onChanged: (String? newValue) {
    setState(() {
      _selectedFilter = newValue!;
      _filterData();
    });
  },
  items: <String>[
    'All',
    'PF',
    'AI',
  ].map<DropdownMenuItem<String>>((String value) {
    return DropdownMenuItem<String>(
      
      value: value,
      child: Text(
        value,
        style: TextStyle(color: Colors.black),
      ),

    );
  }).toList(),

),
    SizedBox(width: 16),
    DropdownButton<String>(
      value: _selectedTeacher,
      onChanged: (String? newValue) {
        setState(() {
          _selectedTeacher = newValue!;
          _filterData();
        });
      },
      items: <String>[
        'All',
        'Dr. Hassan',
        'Teacher 2',
        'Teacher 3',
        // Add more teacher options as needed
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: TextStyle(color: Colors.black),
          ),
        );
      }).toList(),

    ),
    SizedBox(width: 16),
    DropdownButton<String>(
      value: _selectedCourse,
      onChanged: (String? newValue) {
        setState(() {
          _selectedCourse = newValue!;
          _filterData();
        });
      },
      items: <String>[
        'All',
        'Course 1',
        'Course 2',
        'Course 3',
        // Add more course options as needed
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: TextStyle(color: Colors.black),
          ),
        );
      }).toList(),

    ),
    SizedBox(width: 16),
    IconButton(
      onPressed: () async {
        final selectedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2022),
          lastDate: DateTime(2030),
        );
        if (selectedDate != null) {
          setState(() {
            _selectedDate = selectedDate;
          });
        }
      },
      icon: Icon(Icons.calendar_month),
      color: Color(0xFF674AEF),
      iconSize: 35,
    ),
  ],
),
            SizedBox(height: 16),
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
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
