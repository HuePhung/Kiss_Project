import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test_final/cameraScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

String imagePath = "";

Future<void> main() async{
  String temp = await getStringValuesSF();
  if(temp == null)
    imagePath = "";
  else if(temp != null)
    imagePath = temp;

  print(temp);
}

Future<String> getStringValuesSF() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // Return String
  String stringValue = prefs.getString("testImagePath");
  return stringValue;
}

class HistoryScreen extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _HistoryScreen();
  }

}

class _HistoryScreen extends State<HistoryScreen> with AutomaticKeepAliveClientMixin<HistoryScreen> {
  List items = getDummyList();

  @override
  bool get wantKeepAlive => false;

  @override
  void initState() {
    super.initState();
    main();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
          title: Text("Historie"),
          backgroundColor: Colors.black
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: ListView.separated(
          //shrinkWrap: true,
          separatorBuilder: (context, index) => Divider(
            height: 30.0,
            color: Colors.black,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return Dismissible(
              key: Key(items[index]),
              background: Container(
                color: Colors.red,
                alignment: AlignmentDirectional.centerEnd,
                child: Icon(
                    Icons.delete,
                    color: Colors.white
                ),
              ),
              onDismissed: (direction) {
                setState(() {
                  items.removeAt(index);
                });
              },
              direction: DismissDirection.endToStart,
              child: InkWell(
                  onTap: () async {

                    try {
                      if(imagePath == null) imagePath = "";

                      imagePath = await getStringValuesSF();

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DisplayPictureScreen(imagePath: imagePath)
                          )
                      );

                    } catch (e) {
                      print(e);
                    }

                  },
                  child:Container(
                    padding: EdgeInsets.all(20.0),
                    height: 125,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Image.file(File(imagePath), width: 125, height: 125),
                        Text(items[index], textAlign: TextAlign.end, style: TextStyle(fontSize: 15),)
                      ],
                    ),
                  )
              ),
            );
          },
        ),
      ),
    );
  }

  static List getDummyList() {
    List list = List.generate(7, (index) {
      return "Scan ${index + 1}";
    });
    return list;
  }
}

