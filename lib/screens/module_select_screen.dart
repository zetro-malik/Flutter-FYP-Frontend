import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_project_screens/globalVars.dart';
import 'package:flutter_project_screens/screens/lecture_into_slides/RecordingOrDirectorScreen.dart';
import 'package:flutter_project_screens/screens/roomdata_screen.dart';


class ModuleSelect extends StatelessWidget {
  List imgList = [
    'Lecture into Slide',
    'Abnormal Behavior',
    'Attendance',
    'Cheating'
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
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
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
        child: ListView(
          children: [
            Container(
              padding:
                  EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 10),
              decoration: BoxDecoration(
                  color: GlobalVars.themecolor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  )),
              child: Column(children: [
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
                  child: Text("Classroom Assistant",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                        wordSpacing: 2,
                      )),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5, bottom: 20),
                  width: MediaQuery.of(context).size.width,
                  height: 55,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: TextFormField(
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search Modules...",
               
                        hintStyle: TextStyle(
                          color: Colors.black.withOpacity(0.5),
                        ),
                        prefixIcon: Icon(
                          Icons.home,
                          size: 25,
                        )),
                  ),
                ),
              ]),
            ),
            Padding(
                padding: EdgeInsets.only(top: 40, left: 15, right: 15),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Explore Modules",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "See All",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: GlobalVars.themecolor),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GridView.builder(
                        itemCount: 4,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio:
                              (MediaQuery.of(context).size.height - 50 - 25) /
                                  (4 * 240),
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                        ),
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                               if (imgList[index]=="Lecture into Slide")
                                  {
      
                                     Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return RecordingOrDirectorScreen();
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
                                    width: 100,
                                    height: 100,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  imgList[index],
                                  style: TextStyle(
                                    fontSize: 16,
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
    );
  }
}
