import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_project_screens/globalVars.dart';
import 'package:flutter_project_screens/screens/khubaib/TrackRecordScreen.dart';
import 'package:flutter_project_screens/screens/khubaib/activitylogScreen.dart';
import 'package:flutter_project_screens/screens/zetro/confliction.dart';
import 'package:flutter_project_screens/screens/zetro/fileDownload.dart';
import 'package:http/http.dart' as http;
class RecordingPage extends StatefulWidget {
  const RecordingPage({super.key});

  @override
  State<RecordingPage> createState() => _RecordingPageState();
}

class _RecordingPageState extends State<RecordingPage> {
  void startCamera() async{

    cameras = await availableCameras();

    cameraController = CameraController(cameras[0], ResolutionPreset.low,enableAudio: true);

    await cameraController.initialize().then((value){
        if(!mounted)
        {
        return;
        }
        
        setState(() {
          iscamera=true;
        });
    } ).catchError((e){
      print(e);
    });


if (cameraController == null || !cameraController.value.isInitialized) {
     
      return null;
    }

    if (cameraController.value.isTakingPicture) {
    
      return null;
    }

    try {
      
    Timer.periodic(Duration(seconds: 5), (timer) async {
      if (turnOFsnapping)
      {   
        
        timer.cancel();
       
      }
      
        final file = await cameraController.takePicture();
        setState((){} );
        sendPic(file);
        setState((){});


        
      
    });
      
    } on CameraException catch (e) {
      
      return null;
    }


  }



    Future<void> sendPic(XFile file)async{
          
    var postUri =
        Uri.parse("http://192.168.91.52:8009/postImage?id=${GlobalVars.lectureID}");
    //var postUri = Uri.parse("http://192.168.43.49:5000/testCall/2018-ARID-01961");

    var request = http.MultipartRequest('POST', postUri);
    request.files.add(await http.MultipartFile.fromPath('img', file.path));
    request.headers.addAll({'Content-type': 'multipart/formdata'});

    var res = await request.send();
    print('Status Code ${res.statusCode}');
    if (res.statusCode == 200) {
      print('uploaded...');
    } else {
      print('failed to upload...');
    } 
    }

@override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  late List<CameraDescription> cameras;

  late CameraController cameraController;

  bool iscamera=false;

  @override
  void initState() {
    startCamera();
    super.initState();
  }

  bool turnOFsnapping=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: 
      Padding(
       padding: const EdgeInsets.only(top: 30.0, right: 30,left: 30),
        child:!iscamera?CircularProgressIndicator(): Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Text("Recording",style: TextStyle(fontSize: 34,fontWeight: FontWeight.bold),),
          SizedBox(height: 50,),
          recodingContainer(),
          SizedBox(height: 80,),
          
          Row(
         mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: (() {
              turnOFsnapping=true;
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return filedownloadPage();
              },));
            }), child: NativeButton())
          ],)
        ],),
      )),
    );
  }

  Padding recodingContainer() {
     if (!cameraController.value.isInitialized) {
      return Padding(
     padding: const EdgeInsets.only(right: 10,left: 10),

          child: Container(
            height: 250,
            width: 400,
             decoration: BoxDecoration(
                color: Colors.grey[200],
                
                border: Border.all(
                 color: Colors.black,
                ),
                
              ),
            child: Center(child: Text("Recoding will be displayed here")),
          ),
        );
    }
    else{
 return Padding(
                padding: const EdgeInsets.all(1.0),
                child: Center(
                  child: CameraPreview(cameraController),
                ),
              );
    }
   
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
                borderRadius: BorderRadius.all(Radius.circular(5))
              ),
              child: Center(child: Text("End Recording",style: TextStyle(color: Colors.white,fontSize: 22),))
            );
}



}