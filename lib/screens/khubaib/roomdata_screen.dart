import 'package:find_dropdown/find_dropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_project_screens/globalVars.dart';
import 'package:flutter_project_screens/screens/khubaib/single_image_process.dart';
import 'package:flutter_project_screens/screens/zetro/camera_video_screen.dart';
import 'package:flutter_project_screens/screens/zetro/gallery_video_screen.dart';
import 'package:flutter_project_screens/others/single_image_process.dart';
import 'package:flutter_project_screens/widgets/CustomDropDown/customdropdown.dart';

import '../../widgets/SignInButton.dart';



class kRoomData extends StatefulWidget {
  const kRoomData({super.key});

  @override
  State<kRoomData> createState() => _kRoomDataState();
}

class _kRoomDataState extends State<kRoomData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
      Container(
        height: 150,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(bottomRight: Radius.circular(50)),
            color: GlobalVars.themecolor),
        child: Stack(children: [
          Positioned(
            top: 80,
            left: 0,
            child: Container(
              height: 100,
              width: 300,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(50),
                      bottomRight: Radius.circular(50))),
            ),
          ),
          Positioned(
              top: 115,
              left: 20,
              child: Text(
                "Room Data",
                style: TextStyle(
                    fontSize: 25,
                    color: GlobalVars.themecolor,
                    fontWeight: FontWeight.w800),
              )),
        ]),
      ),
      Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Select Class",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: GlobalVars.themecolor.withOpacity(1),
                    fontSize: 18),
              ),
              SizedBox(height: 7),
              CustomSearchableDropdown(
                backgroundColor: Colors.white,
                items: ["BCS", "BIT", "BAI"],
                onChanged: (item) {
                  print(item);
                },
                selectedItem: "BCS",
                showSearchBox: true,
                validate: (String? item) {
                  if (item == null)
                    return "Required field";
                  else
                    return null;
                },
              ),
            ],
          )),
      SizedBox(
        height: 10,
      ),
      Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Select Section",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: GlobalVars.themecolor.withOpacity(1),
                    fontSize: 18),
              ),
              SizedBox(height: 7),
              CustomSearchableDropdown(
                backgroundColor: Colors.white,
                items: ["4A", "4B", "4C", "5A"],
                onChanged: (item) {
                  print(item);
                },
                selectedItem: "4A",
                showSearchBox: true,
                validate: (String? item) {
                  if (item == null)
                    return "Required field";
                  else if (item == "Brasil")
                    return "Invalid item";
                  else
                    return null;
                },
              ),
            ],
          )),
      SizedBox(
        height: 10,
      ),
      Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Select Subject",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: GlobalVars.themecolor.withOpacity(1),
                    fontSize: 18),
              ),
              SizedBox(height: 7),
              CustomSearchableDropdown(
                backgroundColor: Colors.white,
                items: [
                  "PROGRAMMING FUNDAMENTALS",
                  "PARALLEL & DISTRIBUTED COMPUTING",
                  "PROFESSIONAL PRACTICES",
                  "MACHINE LEARNING"
                ],
                onChanged: (item) {
                  print(item);
                },
                selectedItem: "PROGRAMMING FUNDAMENTALS",
                showSearchBox: true,
                validate: (String? item) {
                  if (item == null)
                    return "Required field";
                  else if (item == "Brasil")
                    return "Invalid item";
                  else
                    return null;
                },
              ),
            ],
          )),
      SizedBox(
        height: 10,
      ),
      Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Select Teacher",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: GlobalVars.themecolor.withOpacity(1),
                    fontSize: 18),
              ),
              SizedBox(height: 7),
              CustomSearchableDropdown(
                backgroundColor: Colors.white,
                items: ["Dr. Hassan", "Dr. Naseer", "Dr. Mohsin", "Prof. Umer"],
                onChanged: (item) {
                  print(item);
                },
                selectedItem: "Dr. Hassan",
                showSearchBox: true,
                validate: (String? item) {
                  if (item == null)
                    return "Required field";
                  else
                    return null;
                },
              ),
            ],
          )),
      SizedBox(
        height: 15,
      ),
      Material(
          color: GlobalVars.themecolor,
          borderRadius: BorderRadius.circular(30),
          child: InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return PhotoUploadScreen();
              },));
              // showModalBottomSheet(
              //         context: context,
              //         isScrollControlled: true,
              //         shape: const RoundedRectangleBorder(
              //             borderRadius: BorderRadius.vertical(
              //           top: Radius.circular(30),
              //         )),
              //         builder: (context) => DraggableScrollableSheet(
              //             initialChildSize: 0.4,
              //             maxChildSize: 0.9,
              //             minChildSize: 0.32,
              //             expand: false,
              //             builder: (context, scrollController) {
              //               return SingleChildScrollView(
              //                 controller: scrollController,
              //                 child: widgetsInBottomSheet(context),
              //               );
              //             }),
              //       );
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
              child: Text(
                "Next",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
          )),
    ]));
  }
}


  Widget widgetsInBottomSheet(context) {
    return Stack(
      alignment: AlignmentDirectional.topCenter,
      clipBehavior: Clip.none,
      children: [
        tipOnBottomSheet(),
        Column(children: [
          const SizedBox(
            height: 100,
          ),
          SignInButton(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return CameraVideoScreen();
              },));
            },
            iconPath: 'assets/logos/camera.png',
            textLabel: 'video from camera',
            backgroundColor: Colors.grey.shade300,
            elevation: 0.0,
          ),
          const SizedBox(
            height: 40,
          ),
          SignInButton(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return GalleryVideoScreen();
              },));
            },
            iconPath: 'assets/logos/gallery.png',
            textLabel: 'video from gallery',
            backgroundColor: Colors.grey.shade300,
            elevation: 0.0,
          ),
        ])
      ],
    );
  }

  Widget tipOnBottomSheet() {
    return Positioned(
      top: -15,
      child: Container(
        width: 60,
        height: 7,
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
        ),
      ),
    );
  }

// CustomSearchableDropdown(
//         backgroundColor: GlobalVars.themecolor.withOpacity(0.7),
//         items: ["aaaaa", "hassan", "azhar", "umair"],
//         onChanged: (item) {
//           print(item);
//         },
//         selectedItem: "Brasil",
//         showSearchBox: true,
//         validate: (String? item) {
//           if (item == null)
//             return "Required field";
//           else if (item == "Brasil")
//             return "Invalid item";
//           else
//             return null;
//         },
//       )