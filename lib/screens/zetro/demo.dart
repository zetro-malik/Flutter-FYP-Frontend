import 'dart:async';
import 'dart:convert' as convert;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:onlineexaminvigilation0001/recordingvideo/video_recording.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:video_player/video_player.dart';

// import '../Papersubmit.dart';
// import '../main.dart';
// import '../mainpage.dart';

class CameraPage extends StatefulWidget {
  var id;
  String ttime;

  CameraPage({Key? key, required this.id, required this.ttime}) {
    print('Time = $ttime');
  }

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  bool wrns = true;
  List<VideoPlayerController> video_controllers = [];



  bool loop = true;

  int length = 0;

  final _fair = TextEditingController();

  final List<TextEditingController> _offer = [];

  static List<dynamic> jsonResult = [];

  late SnackBar sb;


  bool role = true;
  List<bool> selectA = [];
  List<bool> selectB = [];
  List<bool> selectC = [];
  List<bool> selectD = [];

  var extra;

  


  Timer? t;
  bool _isLoading = true;
  bool _isRecording = false;
  late CameraController _cameraController;

//List<String> MCQ=['Question Number 1', 'Question Number 2'];
  @override
  void initState() {
   
    _initCamera();
    displayVideo();
    super.initState();
    String s = widget.ttime;
    int tt = 0;
    if (s.isNotEmpty) {
      tt = int.parse(s);
    }
    print("tayyab"+widget.ttime);
    print("asim asim"+tt.toString());

    Timer.periodic(Duration(seconds: tt), (timer) async {
      print('inside timer.... ');

      if (_isRecording) {
        print('Uploading video.... ');
        final file = await _cameraController.stopVideoRecording();
        setState(() => _isRecording = false);

        videoupload(context: context, fpath: file.path);
        Future.delayed(const Duration(seconds: 1));
        await _cameraController.prepareForVideoRecording();
        await _cameraController.startVideoRecording();
        setState(() => _isRecording = true);
      } else {
        _isRecording = true;
        await _cameraController.prepareForVideoRecording();
        await _cameraController.startVideoRecording();
        setState(() => _isRecording = true);
      }
    });
  }

  // void initState() {
  //   _initCamera();
  //   super.initState();
  //
  // }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  _initCamera() async {
    final cameras = await availableCameras();
    final front = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front);
    _cameraController = CameraController(front, ResolutionPreset.max);
    await _cameraController.initialize();
    setState(() => _isLoading = false);
  }

  _recordVideo1() async {
    if (_isRecording) {
      final file = await _cameraController.stopVideoRecording();
      setState(() => _isRecording = false);
      // final route = MaterialPageRoute(
      //   fullscreenDialog: true,
      //   builder: (_) => VideoPage(filePath: file.path),
      // );
      // Navigator.push(context, route);
    } else {
      await _cameraController.prepareForVideoRecording();
      await _cameraController.startVideoRecording();
      setState(() => _isRecording = true);
    }
  }

  _recordVideo() async {
    if (_isRecording) {
      final file = await _cameraController.stopVideoRecording();
      setState(() => _isRecording = false);
      // final route = MaterialPageRoute(
      //   fullscreenDialog: true,
      //   builder: (_) => VideoPage(filePath: file.path),
      // );
      //Navigator.push(context, route);
    } else {
      await _cameraController.prepareForVideoRecording();
      await _cameraController.startVideoRecording();
      setState(() => _isRecording = true);
    }
  }



  void displayVideo() {
    super.initState();
      VideoPlayerController cont = VideoPlayerController.asset(
          'assets/aa.mp4');
      cont.addListener(() {
        setState(() {});
      });
      cont.setLooping(true);
      cont.initialize().then((_) => setState(() {}));
      cont.play();
      video_controllers.add(cont);
    }
//alert box for submitted paper

  submitpaperalert(BuildContext context) {

    return showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text('Successfully ' ),
        content: Text('Paper Submitted',style: TextStyle(

          fontSize: 18,
          color: Colors.black,)),

        actions: [
          MaterialButton(

            child:Text('OK',style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Colors.blue,

            ),), onPressed: () {

            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //       builder: (context) => new submitpaper1(
            //         id: widget.id,
            //       )),
            // );
          },)
        ],
      );
    }
    );}

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
    return Container(
        margin: EdgeInsets.only(
          top: 20, left: 0, right: 5,),
        decoration: BoxDecoration(
            border: Border.all(width: 5.0,color: Colors.white)

        ),
          child: Scaffold(
        backgroundColor: Colors.grey,

        body: Column(
          children: [
            Container(height:100,width:100,

          margin: EdgeInsets.only(
              top: 20, left: 180, right: 5,),
          decoration: BoxDecoration(
              color: Colors.white,
            border: Border.all(width: 5.0,color: Colors.green)

            ),
              child:  GridView.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 1 / 2,
                      crossAxisSpacing: 0,
                      mainAxisSpacing: 0),
                  itemCount: video_controllers.length,
                  itemBuilder: (cont, index) {
                    print('Building$index');
                    VideoPlayerController controller = video_controllers[index];

                    print('Playing..');

                    print('Aspect Ratio${controller.value.aspectRatio}');


                    return
                      Container(
                          child: Column(
                              children: [
                                Container(


                                  height:100,
                                  width: 100,





//                   return InkWell(
// //                 onTap: (){},

                                    child: AspectRatio(
                                      aspectRatio: controller.value.aspectRatio,
                                      child: VideoPlayer(controller),

                                    ),

                                  ),


                               ])

                      );

                  }

              ),
            ),
            SizedBox(
              height: 5,
            ),
            Expanded(
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  CameraPreview(_cameraController),
                  Container(
                  child: FutureBuilder<List<dynamic>>(
                    future: null,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        return ListView.builder(
                            itemCount: length,
                            itemBuilder: (context, index) {
                              return Column(children: [
                                Container(
                                  width: 390,
                                  height: 50,
                                  padding: EdgeInsets.only(
                                      left: 10, top: 5, right: 10, bottom: 10),
                                  margin: EdgeInsets.only(
                                      top: 0, left: 5, right: 5, bottom: 0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25.0),
                                      color: Colors.grey),
                                  child: Row(
                                    children: <Widget>[
                                      Text(
                                        "Q$index",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      Text(
                                        snapshot.data![index]["mcqsQuestion"]
                                            .toString(),
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 15.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: <Widget>[
                                    ListTile(
                                      title: Text(
                                        snapshot.data![index]["opt1"].toString(),
                                        style: TextStyle(fontSize: 20.0),
                                      ),
                                      leading: Checkbox(
                                        value: selectA[index],
                                        onChanged: (value) {
                                          //print("dddddddddddddddddddddddddddddddddd");
                                          this.setState(() {
                                            selectA[index] = value!;
                                            selectB[index] = false;
                                            selectC[index] = false;
                                            selectD[index] = false;
                                          });
                                          print(selectA[index]);
                                        },
                                      ),
                                    )
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    ListTile(
                                      title: Text(
                                        snapshot.data![index]["opt2"].toString(),
                                        style: TextStyle(fontSize: 20.0),
                                      ),
                                      leading: Checkbox(
                                        value: selectB[index],
                                        onChanged: (value) {
                                          this.setState(() {
                                            selectA[index] = false;
                                            selectB[index] = value!;
                                            selectC[index] = false;
                                            selectD[index] = false;
                                          });
                                        },
                                      ),
                                    )
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    ListTile(
                                      title: Text(
                                        snapshot.data![index]["opt3"].toString(),
                                        style: TextStyle(fontSize: 20.0),
                                      ),
                                      leading: Checkbox(
                                        value: selectC[index],
                                        onChanged: (value) {
                                          this.setState(() {
                                            selectA[index] = false;
                                            selectB[index] = false;
                                            selectC[index] = value!;
                                            selectD[index] = false;
                                          });
                                        },
                                      ),
                                    )
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    ListTile(
                                      title: Text(
                                        snapshot.data![index]["opt4"].toString(),
                                        style: TextStyle(fontSize: 20.0),
                                      ),
                                      leading: Checkbox(
                                        value: selectD[index],
                                        onChanged: (value) {
                                          print("2");
                                          this.setState(() {
                                            print("1");
                                            selectA[index] = false;
                                            selectB[index] = false;
                                            selectC[index] = false;
                                            selectD[index] = value!;
                                          });
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ]);
                            });
                      }
                    },
                  ),
                  color: Colors.grey,
                    ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Container(
                    width: 120,
                    height: 60,
                    padding: EdgeInsets.only(left: 1, top: 5, right: 0, bottom: 10),
                    margin: EdgeInsets.only(top: 5, right: 50, left: 50, bottom: 5),
                    child: ElevatedButton(
                      child: Text(
                        "Submit",
                        style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      onPressed: () {
                        // createAlerDialog(context);
                        submitpaperalert(context);
                        //SubmitPaper();
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => new submitpaper1(
                        //             id: widget.id,
                        //           )),
                        // );
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                      ),
                    ),
                  ),
                  // Expanded(child:Container(
                  // child: ListView.builder(
                  //     itemCount: MCQ.length,
                  //     itemBuilder: (context,index){
                  //    String q=MCQ[index];
                  //    return Text(q);
                  // }),
                  //
                  //   color: Colors.grey,
                  // )
                  //
                  // )
                  // Padding(
                  //   padding: const EdgeInsets.all(25),
                  //   child: FloatingActionButton(
                  //     backgroundColor: Colors.red,
                  //     child: Icon(_isRecording ? Icons.stop : Icons.circle),
                  //     onPressed: () => _recordVideo(),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ));
    }
  }
}

Future<void> videoupload({context, fpath}) async {
//  final cameras = await availableCameras();
  // final front = cameras.firstWhere((camera) =>
  // camera.lensDirection == CameraLensDirection.front);
  // final _cameraController = CameraController(front, ResolutionPreset.max);
  // var file = await _cameraController.stopVideoRecording();

  var postUri =
      Uri.parse("http://" + "/getVideoFile/2018-ARID-1122");
  //var postUri = Uri.parse("http://192.168.43.49:5000/testCall/2018-ARID-01961");

  var request = http.MultipartRequest('POST', postUri);
  request.files.add(await http.MultipartFile.fromPath('video', fpath));
  request.files.add(await http.MultipartFile.fromPath('video2', fpath));
  request.headers.addAll({'Content-type': 'multipart/formdata'});

  print("fpath: $fpath");
  var res = await request.send();
  print('Status Code ${res.statusCode}');
  if (res.statusCode == 200) {
    print('uploaded...');
  } else {
    print('failed to upload...');
  }

  // request.files.add(
  //     await http.MultipartFile.fromPath(
  //         'video',
  //         fpath)
  // );
  //http.StreamedResponse response = await request.send();
  //print(response.statusCode);
  // http.Response response = await http.Response.fromStream(
  //     await request.send());
  // String _msg = response.body.toString().replaceAll("'", "").replaceAll(
  //     "[", "").replaceAll("]", "");
  // print(_msg);
// var request = http.MultipartRequest('POST', Uri.parse('https://.....com'));
// request.headers.addAll(headers)
// request.files.add(
// http.MultipartFile.fromBytes(
// 'image',
// await ConvertFileToCast(_fileBytes),
// filename: fileName,
// contentType: MediaType('', '')
// )
// )
// request.fields.addAll(fields)
// var response = await request.send()
}