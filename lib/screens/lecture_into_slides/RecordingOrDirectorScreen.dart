
import 'package:flutter/material.dart';
import 'package:flutter_project_screens/screens/lecture_into_slides/directorView.dart';

import '../../globalVars.dart';
import '../roomdata_screen.dart';


class RecordingOrDirectorScreen extends StatelessWidget {
  List imgList = [
    'Record Lecture',
    'Director View',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomAppBar(
          color: Colors.transparent,
          child: Container(
            height: 50,
            padding: EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 10),
            decoration: BoxDecoration(
                color: GlobalVars.themecolor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(0),
                  topRight: Radius.circular(0),
                )),
            child: Text(
              "",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          elevation: 0,
        ),
        body: SafeArea(
            child: ListView(children: [
          Container(
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 10),
            decoration: BoxDecoration(
                color: GlobalVars.themecolor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                )),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.dashboard,
                      size: 30,
                      color: Colors.white,
                    ),
                    Icon(
                      Icons.notifications,
                      size: 30,
                      color: Colors.white,
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.only(left: 3, bottom: 15),
                  child: Text("Selecting Mode",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                        wordSpacing: 2,
                      )),
                ),
                Padding(
                    padding: EdgeInsets.only(top: 40, left: 15, right: 15),
                    child: Column(
                      children: [
                        GridView.builder(
                            itemCount: imgList.length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              childAspectRatio:
                                  (MediaQuery.of(context).size.height) /
                                      (2 * 350),
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                            ),
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  if (imgList[index] == "Record Lecture") {
                                    Navigator.push(context, MaterialPageRoute(
                                      builder: (context) {
                                        return RoomData();
                                      },
                                    ));
                                  }
                                  else  if (imgList[index] == "Director View") {
                                    Navigator.push(context, MaterialPageRoute(
                                      builder: (context) {
                                        return directorView();
                                      },
                                    ));
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Color(0xFFF5F3FF)),
                                  child: Column(children: [
                                    Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Image.asset(
                                        "assets/images/${imgList[index]}.png",
                                        width: 130,
                                        height: 130,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      imgList[index],
                                      style: TextStyle(
                                        fontSize: 21,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black.withOpacity(0.6),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ]),
                                ),
                              );
                            }),
                      ],
                    )),
              ],
            ),
          ),
        ])));
  }
}