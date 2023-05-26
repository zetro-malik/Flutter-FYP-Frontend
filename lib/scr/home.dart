import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_project_screens/globalVars.dart';
import 'package:flutter_project_screens/scr/khubaib/recordingScreen.dart';
import 'package:flutter_project_screens/screens/admin_setting_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
class Home extends StatefulWidget {


  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
Future<bool> sendData() async {
  var respose=await http.post(
    Uri.parse('http://192.168.91.52:8009/postRoomData?class=${cls.text}&section=${section.text}&subject=${subject.text}&teacher=${teacher.text}'),
  );
  
   GlobalVars.lectureID =respose.body;
  if(respose.statusCode==200)
  {
    print(GlobalVars.lectureID);
    return true;
  }
    print("123");

  return false;
}

  TextEditingController cls = TextEditingController();

  TextEditingController section = TextEditingController();

  TextEditingController subject = TextEditingController();

  TextEditingController teacher = TextEditingController();

  double height=0;

  double width=0;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;

    return Scaffold(
      
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 40.0, right: 30,left: 30),
            child: Center(
              child: Column(children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal:25),
                child: Column(children: [
                Container(
                  height: 120,
                  child: Image.asset("assets/a.png")),
                  SizedBox(height: 10,),
                  Text("Classroom Assitant",style: TextStyle(color: Colors.grey,fontSize: 20,fontWeight: FontWeight.bold),),
                
                ]),),
                
                SizedBox(height: 20,),
                Container(child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
        
                  children: [
                  
                    Text("Class",style: TextStyle(color: Colors.blue[800],fontSize: 18,fontWeight: FontWeight.bold)),
                    TextFormField(controller: cls,),
                ],)),
                SizedBox(height: 20,),
                
                 Container(child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
        
                  children: [
                  
                    Text("Section",style: TextStyle(color: Colors.blue[800],fontSize: 18,fontWeight: FontWeight.bold)),
                    TextFormField(controller: section,),
                ],)),
                SizedBox(height: 20,),
        
                 Container(child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
        
                  children: [
                  
                    Text("Subject",style: TextStyle(color: Colors.blue[800],fontSize: 18,fontWeight: FontWeight.bold)),
                    TextFormField(controller: subject,),
                ],)),
                SizedBox(height: 20,),
        
                 Container(child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
        
                  children: [
                  
                    Text("Teacher",style: TextStyle(color: Colors.blue[800],fontSize: 18,fontWeight: FontWeight.bold)),
                    TextFormField(controller: teacher,),
                ],)),
               SizedBox(height: 20,),
              InkWell(
                
                onTap: ()  async{
                   check=await sendData();
                  if(check!){
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return AdminSetting();
                  },));
                  }
                 setState(() {
                   
                 });
                },
                child: NativeButton(),
              )
              ]),
            ),
          ),
        ),
      ),
    );
  }

bool? check=null;

  Container NativeButton() {
    return Container(
                width: 250,
                padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue,
                
                border: Border.all(
                 color: Colors.blue,
                ),
                borderRadius: BorderRadius.all(Radius.circular(25))
              ),
              child: Center(child: Text("Next",style: TextStyle(color: Colors.white,fontSize: 22),))
            );
  }
}