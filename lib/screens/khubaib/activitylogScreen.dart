import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ActivityLogPage extends StatelessWidget {
  const ActivityLogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(child: 
      Padding(
       padding: const EdgeInsets.only(top: 30.0, right: 30,left: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Live Recording",style: TextStyle(fontSize: 32,fontWeight: FontWeight.bold),),
            ],
          ),
         
          SizedBox(height: 30,),
          Text("Selected Activity",style: TextStyle(fontSize: 20),),
           SizedBox(height: 10,),
           BehaviourLogs(),
          SizedBox(height: 20,),
        
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
                  Text("1- arfar  60%  activity"),
                    Text("1- arfar  80%  activity"),
                    
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