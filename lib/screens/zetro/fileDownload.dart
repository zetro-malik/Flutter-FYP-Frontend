import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class filedownloadPage extends StatelessWidget {
  const filedownloadPage({super.key});

  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 150.0, right: 30,left: 30),
            child: Center(
              child: Column(
               
                children: [
               Center(
          child: Column(children: [
           Transform.scale(
            scale: 6,
            child: Icon(Icons.file_open))
          ]),
        ),
        SizedBox(height: 70,),
        Text("Slide File Name.pptx",style: TextStyle(fontSize: 20),),

         SizedBox(height: 30,),
        Text("File Size: 800kb",style: TextStyle(fontSize: 18),),
SizedBox(height: 40,),
        Container(
                width: 150,
                padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green[700],
                
                border: Border.all(
                 color: Colors.green,
                ),
                borderRadius: BorderRadius.all(Radius.circular(5))
              ),
              child: Center(child: Text("Download",style: TextStyle(color: Colors.white,fontSize: 20),))
            ),
            SizedBox(height: 200,),
            NativeButton()
              ]),
            ),
          ),
        ),
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
              child: Center(child: Text("Done",style: TextStyle(color: Colors.white,fontSize: 22),))
            );
}
}


 