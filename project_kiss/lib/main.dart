import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_final/historyScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cameraScreen.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();

  runApp(MyApp());
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
              ),
              new Container(
                child: CameraScreen(cameras),
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
                icon: new Icon(Icons.history),)
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
