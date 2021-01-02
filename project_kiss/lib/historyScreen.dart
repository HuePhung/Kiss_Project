import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_final/search/ingredient.dart';
import 'package:path/path.dart' as p;
import 'package:test_final/scanscreen.dart';
import 'package:test_final/api/firebase_text_api.dart'; // vorher -> 'package:test_final/api/firebase_ml_api.dart', gibt Fehler @TODO abklären
import 'package:test_final/search/fast_levenshtein.dart';

String imagePath = "";
List<String> imagePathList = [];

Future<void> main() async {
  String temp = await getStringValuesSF();
  if (temp == null)
    imagePath = "";
  else if (temp != null) imagePath = temp;

  print("yeeeeeeeeeeeeeeeeeeeeeeeeees " + temp);
}

Future<String> getStringValuesSF() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  // Return String

  String stringValue = prefs.getString("testImagePath");
  return stringValue;
}

Future<String> getStringValueFromListSF(int index) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> prefList = prefs.getStringList("imagePathList");

 // prefList = prefList.reversed.toList();
  String path;

  if (prefList != null) {
    path = prefList[index];
  }

  return path;
}

Future<List<String>> getStringListSF() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> prefList = prefs.getStringList("imagePathList");
  //prefList = prefList.reversed.toList();
  imagePathList = prefList;

  return prefList;
}

Future<List<String>> getImagePathList() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> prefList = prefs.getStringList("imagePathList");
 // prefList = prefList.reversed.toList();

  //prefList.forEach((element) {print(element);});
  //debugPrint("what up nigga");

  //if(prefList == null){
  //  return [];
  //} else {
  return prefList;
  //}
}

Future<SharedPreferences> getPrefs() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  debugPrint("getting prefs");
  return prefs;
}

class HistoryScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HistoryScreen();
  }
}

class _HistoryScreen extends State<HistoryScreen>
    with AutomaticKeepAliveClientMixin<HistoryScreen> {
  //List items = getDummyList();
  List<String> pathList = ["0"];

  //Future<List<String>> _pathList;
  List<Ingredient> ingredients;
  Future<SharedPreferences> _prefs;

  @override
  bool get wantKeepAlive => false;

  @override
  void initState() {
    super.initState();
    debugPrint("in initState");
    //getStringListSF();
    _prefs = getPrefs();
    ingredients = [];
  }

  String name;

  @override
  Widget build(BuildContext context) =>
      FutureBuilder(
        future: _prefs,
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.data
                  .getStringList("imagePathList")
                  .isNotEmpty) {
            SharedPreferences prefs = snapshot.data;
            List<String> imagePathList = prefs.getStringList("imagePathList");
            /*for(String test in imagePathList) {
              print('hash ${test.substring(test.length - 19, test.length - 13)+test.substring(test.length - 11, test.length - 9)}');
            }
            print("PATH LIST LENGTH  ${imagePathList.length}");
            */


            return new Scaffold(
              appBar: AppBar(
                title: Text("History"),
                actions: <Widget>[
                  IconButton(
                    icon: new Icon(Icons.delete),
                    onPressed: () async {
                      return await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Delete History"),
                            content: Text(
                                "Are you sure you want to delete all entries?"),
                            actions: <Widget>[
                              FlatButton(
                                onPressed: () async {
                                  for (int idx = 0;
                                  idx < imagePathList.length;
                                  idx++) {
                                    String deleteByIdx = imagePathList[idx];
                                    String num = deleteByIdx.substring(deleteByIdx.length - 9, deleteByIdx.length - 4);
                                    prefs.remove(num);
                                    //prefs.remove("Scan$idx");
                                    File(deleteByIdx).deleteSync();
                                  }
                                  setState(() {
                                    imagePathList.clear();
                                  });
                                  await prefs.setStringList(
                                      "imagePathList", imagePathList);
                                  Navigator.of(context).pop();
                                },
                                child: const Text("DELETE ALL"),
                              ),
                              FlatButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text("CANCEL"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  )
                ],
                backgroundColor: Colors.black,
              ),
              body: Container(
                padding: const EdgeInsets.all(20.0),
                child: ListView.separated(
                  //shrinkWrap: true,
                 // reverse: true,
                  separatorBuilder: (context, index) =>
                      Divider(
                        height: 30.0,
                        color: Colors.black,
                      ),
                  itemCount: imagePathList.length, //.compareTo(0),
                  itemBuilder: (context, index) {
                    index = imagePathList.length - 1 - index ;
                    String imgPath = imagePathList[index];
                    String num = imgPath.substring(imgPath.length - 9, imgPath.length - 4);
                    String date = imgPath.substring(imgPath.length - 19, imgPath.length - 13)+imgPath.substring(imgPath.length - 11, imgPath.length - 9);
                    //name = prefs.getString("Scan$index");
                    //if (name == null) name = "Scan $index";

                    name = prefs.getString("Scan$num");
                    if (name == null) name = " $date";
                    return Dismissible(
                      key: Key(imagePathList[index]),
                      background: Container(
                        color: Colors.red,
                        alignment: AlignmentDirectional.centerEnd,
                        padding: EdgeInsets.only(right: 30),
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      confirmDismiss: (DismissDirection direction) async {
                        return await showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Confirm"),
                              content: const Text(
                                  "Are you sure you want to delete this entry?"),
                              actions: <Widget>[
                                FlatButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    child: const Text("DELETE")),
                                FlatButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: const Text("CANCEL"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      onDismissed: (direction) async {
                        String deletePath = imagePathList[index];
                        setState(() {
                          imagePathList.removeAt(index);
                          prefs.remove(num);
                          //prefs.remove('Scan$index');
                        });
                        File(deletePath).deleteSync();
                        await prefs.setStringList(
                            "imagePathList", imagePathList);
                      },
                      direction: DismissDirection.endToStart,
                      child: InkWell(
                          onTap: () async {
                            // use index
                            try {
                              if (imagePath == null) imagePath = "";

                              imagePath = await getStringValueFromListSF(index);
                              File fileImageFromGallery = File(imagePath); // die Fkt um ein File zu erhalten

                              final textFromGallery = await FirebaseMLApi.recogniseText(fileImageFromGallery);

                              List<Ingredient> ingredients =
                              FastLevenshtein.getIndividualItems(
                                  textFromGallery);


                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          DisplayPictureScreen(
                                              appBarTitle: "Scanned product",
                                              imagePath: imagePath,
                                              ingredients: ingredients)))
                                  .then((value) =>
                                  setState(() => name = prefs.getString("Scan$num"),
                                  ));
                            } catch (e) {
                              print(e);
                            }
                          },
                          child:
                          Container(
                            padding: EdgeInsets.all(20.0),
                            height: 125,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Image.file(File(imagePathList[index]),
                                    width: 125, height: 125),

                                Expanded(child: Text(
                                    name,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    )

                                ),
                                    ),
                                Text(
                                  //text next to the image
                                  date,
                                  textAlign: TextAlign.end,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: 12),
                                ),

                              ],
                            ),
                          ),
                    ),
                    );
                  },
                ),
              ),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Text("History"),
                backgroundColor: Colors.black,
              ),
              body: Container(
                height: MediaQuery
                    .of(context)
                    .size
                    .height,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                color: Colors.white,
                alignment: Alignment.center,
                child: new Text("You haven't scanned any products yet.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 17)),
              ),
            );
          }
        },
      );
}
