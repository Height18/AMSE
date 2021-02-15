// ignore: avoid_web_libraries_in_flutter
import 'dart:io';
import 'package:dio/dio.dart';
import "dart:convert";
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(new MaterialApp(
    title: "background remover",
    home: LandingScreen(),
  ));
}

class LandingScreen extends StatefulWidget {

  @override
  _LandingScreenState createState() => _LandingScreenState();

}

class _LandingScreenState extends State<LandingScreen> {

  File imageFile;

  _openGallary() async {
    var picture = await ImagePicker.pickImage(source: ImageSource.gallery);
    this.setState((){
      imageFile = picture;
    });
  }

  Widget _decideImageView(){
    if(imageFile ==null){
      return Text("No image selected !");
    }
    else{
      return Image.file(imageFile,width: 500,height: 500);
    }
  }

  Widget _backgroundRemoverButton(){
    if(imageFile != null){
      return RaisedButton(onPressed: () async {
        final uri = 'http://192.168.43.104:8080/remove';
        FormData data = new FormData();
        data.files.add(MapEntry("file", await MultipartFile.fromFile(imageFile.path, filename: "image.png"), ));
        // Send a post request to server
        Dio dio = new Dio();
        try {
          Response response = await dio.post(uri, data:data);
          print(response);
          imageFile = Image.memory(base64Decode(response.data)) as File;
        } catch (e) {
          print(e);
        }
      },child: Text("Remove Background"),);

    }else{
      return SizedBox.shrink();

    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Main Screen"),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _decideImageView(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    RaisedButton(onPressed: (){
                      _openGallary();
                    },child: Text("Select Image"),),
                    _backgroundRemoverButton(),
                  ],
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}


