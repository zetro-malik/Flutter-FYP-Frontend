import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_project_screens/screens/TrackRecordScreen.dart';

class RecordingPage extends StatelessWidget {
  const RecordingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: 
      Padding(
       padding: const EdgeInsets.only(top: 30.0, right: 30,left: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Text("Live Recording",style: TextStyle(fontSize: 32,fontWeight: FontWeight.bold),),
          SizedBox(height: 20,),
          recodingContainer(),
          SizedBox(height: 10,),
          Text("Behaviour Logs",style: TextStyle(fontSize: 20),),
           SizedBox(height: 10,),
           BehaviourLogs(),
          SizedBox(height: 20,),
          Row(
         mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: (() {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return trackRecord();
              },));
            }), child: NativeButton())
          ],)
        ],),
      )),
    );
  }





  Padding recodingContainer() {
    return Padding(
     padding: const EdgeInsets.only(right: 10,left: 10),

          child: Container(
            height: 250,
            width: 400,
            color: Colors.grey[400],
            child: Center(child: Text("Recoding will be displayed here")),
          ),
        );
  }

  Padding BehaviourLogs() {
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
            child: Center(
              
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                  Text("person 1 is using phone at 13.05"),
                    Text("person 2 us talking at 13.19"),
                      Text("person 1 is using phone at 13.32"),
                Text("prson 1 sleeping at 13.35"),
              ],
            )),
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
                borderRadius: BorderRadius.all(Radius.circular(5))
              ),
              child: Center(child: Text("End Recording",style: TextStyle(color: Colors.white,fontSize: 22),))
            );
}
}