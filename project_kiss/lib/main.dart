import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'historyScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cameraScreen.dart';

CameraDescription camera;

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  List<CameraDescription> cameras = await availableCameras();
  camera = cameras.first;

  final bool exists = await listExists();

  if(!exists){
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> list = [];

    prefs.setStringList("imagePathList", list);
  }

  runApp(MyApp());
}

Future<bool> listExists() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  if(prefs.getStringList("imagePathList") == null){
    return false;
  }
  else return true;
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return new MaterialApp(
      color: Colors.white,
      home: DefaultTabController(
        length: 3,
        initialIndex: 1,
        child: new Scaffold(
          body: TabBarView(
            children: [
              new Container(
                color: Colors.white,
                child: Center(child: Text("More to come...", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
              ),
              new Container(
                child: CameraScreen(camera: camera),
              ),
              new Container(
                child: HistoryScreen(),
              ),
            ],
          ),
          bottomNavigationBar: new TabBar(
            onTap: (int) {
              if(int == 3){

              }
            },
            tabs: [
              Tab(
                icon: new Icon(Icons.search),
              ),
              Tab(
                icon: new Icon(Icons.camera_alt),
              ),
              Tab(
                icon: new Icon(Icons.history),
              )
            ],
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey[700],
            indicatorSize: TabBarIndicatorSize.label,
            indicatorPadding: EdgeInsets.all(5.0),
            indicatorColor: Colors.white,
          ),
          backgroundColor: Colors.black,
        ),
      ),
    );
  }


}
