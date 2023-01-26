import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_project_screens/screens/zetro/fileDownload.dart';

class conflictionpage extends StatelessWidget {
  const conflictionpage({super.key});

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: 
      Padding(
       padding: const EdgeInsets.only(top: 50.0, right: 30,left: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Text("Selecting conflicted Images",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
          SizedBox(height: 50,),
          Text("Confliction 1",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
          SizedBox(height: 10,),
         Row(
          children: [
             recodingContainer("Image 1"), SizedBox(width: 10,),recodingContainer("Image 2"),
          ],
         ),
         SizedBox(height: 30,),
          Row(
          children: [
             recodingContainer("Image 3"),
          ],
         ),
           SizedBox(height: 40,),
          Text("Confliction 2",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
          SizedBox(height: 10,),
         Row(
          children: [
             recodingContainer("Image 1"), SizedBox(width: 10,),recodingContainer("Image 2"),
          ],
         ),
         
          SizedBox(height: 80,),
          
          Row(
         mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: (() {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return filedownloadPage();
              },));
            }), child: NativeButton())
          ],)
        ],),
      )),
    );
  }




  Row recodingContainer(String txt) {
    
    return Row(
      children: [
        Radio(value: "", groupValue: "groupValue", onChanged: (value) {
          
        },),
        Padding(
         padding: const EdgeInsets.only(right: 10,left: 10),

              child: Container(
                height: 100,
                width: 100,
                 decoration: BoxDecoration(
                    color: Colors.grey[200],
                    
                    border: Border.all(
                     color: Colors.black,
                    ),
                    
                  ),
                child: Center(child: Text(txt)),
              ),
            ),
      ],
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
              child: Center(child: Text("Proceed",style: TextStyle(color: Colors.white,fontSize: 22),))
            );
}
}