import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';

// Global variable for storing the list of
// cameras available
List<CameraDescription> cameras = [];

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    // Retrieve the device cameras
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print(e);
  }
  runApp(FacePage());
}

class FacePage extends StatefulWidget {
  @override
  createState() => _FacePageState();
}

class _FacePageState extends State<FacePage> {
  File _imageFile;
  List<Face> _faces;

  void _getImageAndDetectedFaces() async {
    final imageFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    final image = FirebaseVisionImage.fromFile(imageFile);
    final faceDetector =
    FirebaseVision.instance.faceDetector(
      FaceDetectorOptions(
        mode: FaceDetectorMode.accurate,
        enableLandmarks: true,
      ),
    );
    final faces = await faceDetector.detectInImage(image);
    setState( () {
      if (mounted) {
        _imageFile = imageFile;
        _faces = faces;
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Text Detector'),
      ),
      body: ImageAndFaces(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _getImageAndDetectedFaces,
        tooltip: 'Pick an image',
        child: Icon(Icons.add_a_photo),
      ),
    );
  }
}

class ImageAndFaces extends StatelessWidget{
  ImageAndFaces({this.imageFile, this.faces});
  final File imageFile;
  final List<Face> faces;

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Flexible(
          flex:2,
          child: Container(
            constraints: BoxConstraints.expand(),
            child: Image.file(
              imageFile,
              fit: BoxFit.cover,
            ),
          )
      ),
      Flexible(
        flex: 1,
        child: ListView(
          children: faces.map<Widget>((f) => FaceCoordinates(f)).toList(),
        ),
      ),

    ]

    );
  }
}

class FaceCoordinates extends StatelessWidget {
  FaceCoordinates(this.face);
  final Face face;

  @override
  Widget build(BuildContext context) {
    final pos = face.boundingBox;
    return ListTile(
      title: Text('(${pos.top}, ${pos.left}, ${pos.bottom}, ${pos.right})' ),
    );
  }
}

