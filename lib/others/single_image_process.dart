import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_project_screens/globalVars.dart';
import 'package:flutter_project_screens/widgets/SignInButton.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';

import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class SingleImageProcess extends StatefulWidget {
  const SingleImageProcess({super.key});

  @override
  State<SingleImageProcess> createState() => _SingleImageProcessState();
}

class _SingleImageProcessState extends State<SingleImageProcess> {
  bool isFirstImageSelect = false;

  bool hideText = false;
  bool changeBtn = false;
  bool appydone = false;
  File? _image;
  Uint8List? _imageBytes;
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(children: [
        Container(
          height: 200,
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
                  "SingleImageProcessing",
                  style: TextStyle(
                      fontSize: 25,
                      color: GlobalVars.themecolor,
                      fontWeight: FontWeight.w800),
                ))
          ]),
        ),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Container(
              height: 230,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(50),
                    bottomLeft: Radius.circular(5),
                    topLeft: Radius.circular(5),
                    bottomRight: Radius.circular(5),
                  ),
                  color: GlobalVars.themecolor
                      .withOpacity(isFirstImageSelect ? 0.7 : 0.7)),
              child: GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                        top: Radius.circular(30),
                      )),
                      builder: (context) => DraggableScrollableSheet(
                          initialChildSize: 0.4,
                          maxChildSize: 0.9,
                          minChildSize: 0.32,
                          expand: false,
                          builder: (context, scrollController) {
                            return SingleChildScrollView(
                              controller: scrollController,
                              child: widgetsInBottomSheet(),
                            );
                          }),
                    );
                  },
                  child: Container(
                      height: 400,
                      child: Image.asset("assets/images/img111.jpeg"))),
            )),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Material(
              color: GlobalVars.themecolor,
              borderRadius: BorderRadius.circular(changeBtn ? 50 : 8),
              child: InkWell(
                splashColor: Colors.transparent,
                onTap: (() async {
                  downloadFile(
                      "http://192.168.100.9:8009/GETpdf?id=50", "50.pdf");
                }),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  width: changeBtn ? 50 : 150,
                  height: 50,
                  alignment: Alignment.center,
                  child: appydone
                      ? Icon(
                          Icons.done,
                          color: Colors.white,
                        )
                      : !hideText
                          ? Text("Detect",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold))
                          : CircularProgressIndicator(
                              backgroundColor: Colors.white,
                              color: GlobalVars.themecolor.withOpacity(0.7),
                            ),
                ),
              ),
            ),
          ],
        ),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 230,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(5),
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                  ),
                  color: GlobalVars.themecolor.withOpacity(0.7)),
              child: Container(
                  height: 500,
                  width: 500,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: AssetImage("assets/images/Processd_img.jpg"),
                    fit: BoxFit.contain,
                  ))),
            ))
      ]),
    );
  }

  static var httpClient = new HttpClient();

  Future<void> downloadFile(String url, String filename) async {
    final file = await _downloadFile(url, filename);
    if (file == null) return;
    OpenFile.open(file.path);
  }

  Future<File?> _downloadFile(String url, String filename) async {
    final dir = (await getApplicationDocumentsDirectory()).path;
    File file = File('$dir/$filename');
    try {
      final response = await Dio().get(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          receiveTimeout: 0,
        ),
      );

      final raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      raf.close();
      return file;
    } catch (e) {
      return null;
    }
  }

  Future getImage(bool FromCamera) async {
    _imageBytes = null;

    setState(() {});
    final ImagePicker _picker = ImagePicker();
    final image = await _picker.pickImage(
        source: FromCamera ? ImageSource.camera : ImageSource.gallery);
    if (image == null) {
      return;
    }

    final tempImg = File(image.path);
    setState(() {
      _image = tempImg;
      isFirstImageSelect = true;
    });
  }

  Widget widgetsInBottomSheet() {
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
              getImage(true);
              Navigator.pop(context);
            },
            iconPath: 'assets/logos/camera.png',
            textLabel: 'Take from camera',
            backgroundColor: Colors.grey.shade300,
            elevation: 0.0,
          ),
          const SizedBox(
            height: 40,
          ),
          SignInButton(
            onTap: () {
              getImage(false);
              Navigator.pop(context);
            },
            iconPath: 'assets/logos/gallery.png',
            textLabel: 'Take from gallery',
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

  Future<void> RecievePic() async {
    setState(() {
      hideText = true;
      changeBtn = true;
    });
    var postUri = Uri.parse("http://192.168.100.9:8009/stitch_imgs?id=50");

    var request = http.MultipartRequest('GET', postUri);

    var res = await request.send();

    if (res.statusCode == 200) {
      print("done");
      setState(() {
        appydone = true;
      });
      var respStr = await res.stream.toBytes();

      setState(() {
        _imageBytes = respStr;
      });
      await Future.delayed((Duration(milliseconds: 500)));
      setState(() {
        changeBtn = false;
        appydone = false;
        hideText = false;
      });
    } else {
      print('failed to upload...');
    }
  }

  //http://127.0.0.1:8009/uploads\\aa.jpg
  Future<void> sendPic(File file) async {
    var postUri = Uri.parse("http://192.168.100.9:8009/postImage?id=50");

    var request = http.MultipartRequest('POST', postUri);
    request.files.add(await http.MultipartFile.fromPath('img', file.path));
    request.headers.addAll({'Content-type': 'multipart/formdata'});

    var res = await request.send();
  }
}
