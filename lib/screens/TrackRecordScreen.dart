
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_project_screens/screens/activitylogScreen.dart';

class trackRecord extends StatelessWidget {
  const trackRecord({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: 
      Padding(
       padding: const EdgeInsets.only(top: 30.0, right: 30,left: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Track Record",style: TextStyle(fontSize: 28,fontWeight: FontWeight.bold),),
            ],
          ),
           SizedBox(height: 10,),
          Text("Abnormal Behaviour",style: TextStyle(fontSize: 18),),
          SizedBox(height: 20,),
          recodingContainer(context),
          SizedBox(height: 10,),
          Text("Most Mishcheif Students",style: TextStyle(fontSize: 14),),
           SizedBox(height: 10,),
           BehaviourLogs(),
          SizedBox(height: 20,),
          Row(
         mainAxisAlignment: MainAxisAlignment.center,
        children: [
          NativeButton()
          ],)
        ],),
      )),
    );
  }

  


  Padding recodingContainer(context) {
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
                  activitylogPush(context,"1- Sleeping  30%"),
                  activitylogPush(context,"2- Talking   50%"),
                  activitylogPush(context,"3- Phone     70%"),
                
                  
              ],
            )),
          ),
        );
  }

  InkWell activitylogPush(cont, txt) {
    return InkWell(onTap: () {
      print("object");
                  Navigator.push(cont, MaterialPageRoute(builder: (context) {
                    return ActivityLogPage();
                  },));
                }, child: Text(txt,style: TextStyle(fontSize: 14),));
  }

  Padding BehaviourLogs() {
    return Padding(
     padding: const EdgeInsets.only(right: 10,left: 10),

          child: Container(
            height: 150,
            width: 300,
           
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
                width: 200,
                padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue,
                
                border: Border.all(
                 color: Colors.blue,
                ),
                borderRadius: BorderRadius.all(Radius.circular(5))
              ),
              child: Center(child: Text("Done",style: TextStyle(color: Colors.white,fontSize: 22),))
            );
}
}