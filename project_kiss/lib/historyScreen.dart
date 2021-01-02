import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_final/search/ingredient.dart';
import 'package:path/path.dart' as p;
import 'package:test_final/scanscreen.dart';

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

Future<List<Ingredient>> getIngredientsOfProduct(String key) async {
  List<Ingredient> ingredients = [];

  SharedPreferences prefs = await SharedPreferences.getInstance();

  debugPrint(prefs.getString(key));

  json
      .decode(prefs.getString(key))
      .forEach((map) => ingredients.add(new Ingredient.fromJson(map)));

  if(ingredients.isNotEmpty)
    return ingredients;
  else
    return [];
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
                                    prefs.remove("Scan$idx");
                                    File(deleteByIdx).deleteSync();
                                  }

                                  imagePathList.forEach((imagePath) {
                                    prefs.remove(imagePath);
                                  });

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
                    name = prefs.getString("Scan$index");
                    if (name == null) name = "Scan $index";
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
                          prefs.remove('Scan$index');
                          // deleting ingredients for this product
                          prefs.remove(deletePath);
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
                              debugPrint(imagePath);
                              ingredients = await getIngredientsOfProduct(imagePath);

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          DisplayPictureScreen(
                                              appBarTitle: "Scanned product",
                                              imagePath: imagePath,
                                              ingredients: ingredients)))
                                  .then((value) =>
                                  setState(() => name = prefs.getString("Scan$index"),
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
                                  p
                                      .extension(
                                      imagePathList[index].toString(), 4)
                                      .substring(1, 11),
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
