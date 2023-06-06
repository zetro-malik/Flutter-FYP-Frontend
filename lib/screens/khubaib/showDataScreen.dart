import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../globalVars.dart';

class DataScreen extends StatefulWidget {
  DataScreen({Key? key}) : super(key: key);

  @override
  State<DataScreen> createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  List<Map<String, dynamic>>? jsonDataActivity;
  List<Map<String, dynamic>>? jsonDataMostMischief;

  Future<void> _showData() async {
    final jsonUrlActivity =
        '${GlobalVars.IP}:8009/fetch_data_activity?ID=${GlobalVars.lectureID}'; // Replace with the URL for JSON data of activity
    var jsonResponseActivity = await http.get(Uri.parse(jsonUrlActivity));

    if (jsonResponseActivity.statusCode == 200) {
      final jsonResultActivity = json.decode(jsonResponseActivity.body);
      // Assuming the JSON data is a list of maps

      setState(() {
        jsonDataActivity = List<Map<String, dynamic>>.from(jsonResultActivity);
      });
    } else {
      print(
          'Failed to get JSON data with status code of screen data ${jsonResponseActivity.statusCode}');
    }
  }

  Future<void> _showMostMischief() async {
    final jsonUrlMostMischief =
        '${GlobalVars.IP}:8009/fetch_data_mischief?ID=${GlobalVars.lectureID}'; // Replace with the URL for JSON data of most mischief
    var jsonResponseMostMischief =
        await http.get(Uri.parse(jsonUrlMostMischief));

    if (jsonResponseMostMischief.statusCode == 200) {
      final jsonResultMostMischief = json.decode(jsonResponseMostMischief.body);
      // Assuming the JSON data is a list of maps

      setState(() {
        jsonDataMostMischief =
            List<Map<String, dynamic>>.from(jsonResultMostMischief);
      });
    } else {
      print(
          'Failed to get JSON data with status code of screen data ${jsonResponseMostMischief.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data Screen'),
        backgroundColor: Color(0xFF674AEF),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: _showData,
              child: Text('Show Activities'),
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 61, 25, 219),
                onPrimary: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: jsonDataActivity != null
                  ? jsonDataActivity!.length == 0
                      ? Text('No Activity Found')
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: jsonDataActivity!.length,
                          itemBuilder: (context, index) {
                            final data = jsonDataActivity![index];
                            final activity = data["activity"];
                            return ListTile(
                              leading: Text(
                                '${index + 1} - Activity',
                                style: TextStyle(fontSize: 15),
                              ),
                              trailing: Text(
                                activity,
                                style: TextStyle(fontSize: 15),
                              ),
                            );
                          },
                        )
                  : Text(
                      'Fetch Data',
                      style: TextStyle(fontSize: 16),
                    ),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _showMostMischief,
              child: Text('Show Most Mischief Students'),
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 61, 25, 219),
                onPrimary: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: jsonDataMostMischief != null
                  ? jsonDataMostMischief!.length == 0
                      ? Text('No Students Found')
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: jsonDataMostMischief!.length,
                          itemBuilder: (context, index) {
                            final data = jsonDataMostMischief![index];
                            final reg = data["StudentID"];
                            final name = data["StudentName"];
                            final activity = data["Activity"];
                            return ListTile(
                              title: Text(
                                'RegNo: ${reg}',
                                style: TextStyle(fontSize: 12),
                              ),
                              subtitle: Text('Name: ${name}'),
                              trailing: Text('Activity ${activity}',
                                  style: TextStyle(fontSize: 12)),
                            );
                          },
                        )
                  : Text(
                      'Fetch Data',
                      style: TextStyle(fontSize: 16),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}


















































// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

// import '../../globalVars.dart';

// class DataScreen extends StatefulWidget {
//   DataScreen({Key? key}) : super(key: key);

//   @override
//   State<DataScreen> createState() => _DataScreenState();
// }

// class _DataScreenState extends State<DataScreen> {
//   Map<String, dynamic>? jsonDataActivity;
//   Map<String, dynamic>? jsonDataMostMischief;

//   Future<void> _showData() async {
//     final jsonUrlActivity =
//         '${GlobalVars.IP}:8009/fetch_data_activity?ID=9'; // Replace with the URL for JSON data of activity
//     var jsonResponseActivity = await http.get(Uri.parse(jsonUrlActivity));

//     if (jsonResponseActivity.statusCode == 200) {
//       final jsonResultActivity = json.decode(jsonResponseActivity.body);
//       // Assuming the JSON data is a map

//       setState(() {
//         jsonDataActivity = jsonResultActivity as Map<String, dynamic>?;
//       });
//     } else {
//       print(
//           'Failed to get JSON data with status code of screen data ${jsonResponseActivity.statusCode}');
//     }
//   }

//   Future<void> _showMostMischief() async {
//     final jsonUrlMostMischief =
//         '${GlobalVars.IP}:8009/fetch_data_mischief?ID=9'; // Replace with the URL for JSON data of most mischief
//     var jsonResponseMostMischief =
//         await http.get(Uri.parse(jsonUrlMostMischief));

//     if (jsonResponseMostMischief.statusCode == 200) {
//       final jsonResultMostMischief = json.decode(jsonResponseMostMischief.body);
//       // Assuming the JSON data is a map

//       setState(() {
//         jsonDataMostMischief = jsonResultMostMischief as Map<String, dynamic>?;
//       });
//     } else {
//       print(
//           'Failed to get JSON data with status code of screen data ${jsonResponseMostMischief.statusCode}');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Data Screen'),
//         backgroundColor: Color(0xFF674AEF),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             ElevatedButton(
//               onPressed: _showData,
//               child: Text('mostActivity'),
//               style: ElevatedButton.styleFrom(
//                 primary: Color.fromARGB(255, 61, 25, 219),
//                 onPrimary: Colors.white,
//               ),
//             ),
//             SizedBox(height: 16),
//             Container(
//               padding: EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.grey[200],
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: jsonDataActivity != null
//                   ? Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('key1: ${jsonDataActivity!["key1"]}'),
//                         Text('key2: ${jsonDataActivity!["key2"]}'),
//                         // Add more keys as needed
//                       ],
//                     )
//                   : Text(
//                       'No data',
//                       style: TextStyle(fontSize: 16),
//                     ),
//             ),
//             SizedBox(height: 32),
//             ElevatedButton(
//               onPressed: _showMostMischief,
//               child: Text('Show Most Mischief Students'),
//               style: ElevatedButton.styleFrom(
//                 primary: Color.fromARGB(255, 61, 25, 219),
//                 onPrimary: Colors.white,
//               ),
//             ),
//             SizedBox(height: 16),
//             Container(
//               padding: EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.grey[200],
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: jsonDataMostMischief != null
//                   ? Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('key1: ${jsonDataMostMischief!["key1"]}'),
//                         Text('key2: ${jsonDataMostMischief!["key2"]}'),
//                         // Add more keys as needed
//                       ],
//                     )
//                   : Text(
//                       'No data',
//                       style: TextStyle(fontSize: 16),
//                     ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
