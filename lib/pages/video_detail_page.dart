
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VideoDetialPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.white,
        leading: IconButton(icon: Icon(Icons.arrow_back),  onPressed: () {
          Navigator.of(context).pop();
        }),
      ),
    );
  }

}



