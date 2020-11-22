import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_final/api/cameraShotToFile.dart';

Future<void> main() async{
  // WidgetsFlutterBinding.ensureInitialized();
  //cameras = await availableCameras();
}

class CameraScreen extends StatefulWidget{
  List<CameraDescription> cameras = [];

  CameraScreen(List<CameraDescription> list){
    this.cameras = list;
  }

  @override
  _CameraScreenState createState() => _CameraScreenState(cameras);
}

class _CameraScreenState extends State<CameraScreen>{
  CameraController controller;

  List<CameraDescription> cameras = [];

  _CameraScreenState(List<CameraDescription> list){
    this.cameras = list;
  }

  @override
  void initState(){
    super.initState();
    controller = CameraController(cameras[0], ResolutionPreset.high, enableAudio: false);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  addStringToSF(String imagePath) async {
    if(imagePath != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("testImagePath", imagePath);
    }
    else if(imagePath == null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("testImagePath", "");
    }

  }

  @override
  Widget build(BuildContext context) {
    if(!controller.value.isInitialized){
      return Container();
    }

    // return AspectRatio(
    //  aspectRatio: controller.value.aspectRatio,
    //  child: CameraPreview(controller),
    //);

    var ImagePath;

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.88,//690,
            child:AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: CameraPreview(controller)
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.05,//40,
            child:Scaffold(
                backgroundColor: Colors.black,
                floatingActionButton: FloatingActionButton.extended(
                  onPressed:() async {
                    // add functionality here later
                    try {

                      final path = join(
                        (await getTemporaryDirectory()).path, //Temporary path
                        '${DateTime.now()}.png',
                      );
                      ImagePath = path;
                      await addStringToSF(path);
                      await controller.takePicture(path); //take photo
                      // mithilfe imagepicker
                      await CameraShotToFile.createFile();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DisplayPictureScreen(imagePath: ImagePath)
                          )
                      );
                    } catch (e) {
                      print(e);
                    }
                  },
                  label: Text('Schieße ein Foto', style: TextStyle(color: Colors.black)),
                  icon: Icon(Icons.camera_alt, color: Colors.black),
                  backgroundColor: Colors.white,
                ),
                floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat
            ),
          ),
        ],
      ),
    );
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  const DisplayPictureScreen({Key key, this.imagePath}) : super(key: key);

  /*addStringToSF() async {
    if(imagePath != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("testImagePath", imagePath);
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('Gescanntes Produkt'),
            backgroundColor: Colors.black),
        // The image is stored as a file on the device. Use the `Image.file`
        // constructor with the given path to display the image.
        body: Center(
          child: SingleChildScrollView(scrollDirection: Axis.vertical, child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children:  [
              Image.file(
                  File(imagePath),
                  width: 250,
                  height: 250
              ),
              Text(
                "Inhaltsstoffe",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                ),
              ),
              Container(
                padding: EdgeInsets.all(20.0),
                child: DataTable(
                  columns: [
                    DataColumn(label: Text("Inhaltsstoff")),
                    DataColumn(label: Text("Einstufung")),
                  ],
                  rows: [
                    DataRow(
                      cells: [
                        DataCell(Text("Name 1")),
                        DataCell(Text("gefährlich")),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text("Name 2")),
                        DataCell(Text("ungefährlich")),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text("Name 3")),
                        DataCell(Text("hautverträglich")),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text("Name 1")),
                        DataCell(Text("gefährlich")),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text("Name 2")),
                        DataCell(Text("ungefährlich")),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text("Name 3")),
                        DataCell(Text("hautverträglich")),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text("Name 1")),
                        DataCell(Text("gefährlich")),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text("Name 2")),
                        DataCell(Text("ungefährlich")),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text("Name 3")),
                        DataCell(Text("hautverträglich")),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text("Name 1")),
                        DataCell(Text("gefährlich")),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text("Name 2")),
                        DataCell(Text("ungefährlich")),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text("Name 3")),
                        DataCell(Text("hautverträglich")),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          )
          ),
        ));
  }
}