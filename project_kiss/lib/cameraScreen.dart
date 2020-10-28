import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

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
    controller = CameraController(cameras[0], ResolutionPreset.medium);
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

  @override
  Widget build(BuildContext context) {
    if(!controller.value.isInitialized){
      return Container();
    }

   // return AspectRatio(
    //  aspectRatio: controller.value.aspectRatio,
    //  child: CameraPreview(controller),
    //);

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: 690,
            child:AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: CameraPreview(controller)
          ),
          ),
          Container(
            height: 40,
              child:Scaffold(
                backgroundColor: Colors.black,
              floatingActionButton: FloatingActionButton.extended(
                onPressed:(){
                  // add functionality here later
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