import 'dart:ffi';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_project_screens/globalVars.dart';
import 'package:flutter_project_screens/scr/home.dart';
import 'package:flutter_project_screens/scr/khubaib/recordingScreen.dart';

import 'package:http/http.dart' as http;

class AdminSetting extends StatefulWidget {
  @override
  State<AdminSetting> createState() => _AdminSettingState();
}

class _AdminSettingState extends State<AdminSetting> {
  TextEditingController con = TextEditingController();




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 80.0, right: 30, left: 30),
            child: Center(
              child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        child: Text(
                          "Admin Setting",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 28),
                        )),
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Snap Interval of snaping pictures",
                            style: TextStyle(
                                color: Colors.blue[800],
                                fontSize: 14,
                                fontWeight: FontWeight.bold)),
                        TextFormField(
                          controller: con,
                        ),
                      ],
                    )),
                    SizedBox(
                      height: 100,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                             GlobalVars.threshold=int.parse(con.text);
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return RecordingPage();
                              },
                            ));
                          },
                          child: NativeButton(),
                        ),
                      ],
                    )
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  Container NativeButton() {
    return Container(
        width: 250,
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: Colors.blue,
            border: Border.all(
              color: Colors.blue,
            ),
            borderRadius: BorderRadius.all(Radius.circular(5))),
        child: Center(
            child: Text(
          "Start Recording",
          style: TextStyle(color: Colors.white, fontSize: 22),
        )));
  }

}
