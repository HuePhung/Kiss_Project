import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:exif/exif.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:test_final/api/recordDate.dart';
import 'package:test_final/api/firebase_text_api.dart'; // vorher -> 'package:test_final/api/firebase_ml_api.dart', gibt Fehler @TODO abklären
import 'package:test_final/search/fast_levenshtein.dart';
import 'package:test_final/impressumScreen.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:test_final/search/ingredient.dart';
import 'package:test_final/scanscreen.dart';

class CameraScreen extends StatefulWidget {
  final CameraDescription camera;

  const CameraScreen({Key key, @required this.camera}) : super(key: key);

  @override
  CameraScreenState createState() => CameraScreenState(camera: camera);
}

class CameraScreenState extends State<CameraScreen> {

  final CameraDescription camera;
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  CameraScreenState({Key key, @required this.camera});
  var keyboardController = KeyboardVisibilityController();

  @override
  void initState() {
    super.initState();
    //FocusScope.of(context).unfocus();
    //leven = new FastLevenshtein();
    //loadCSV();

    // To display the current output from the camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      this.camera,
      // Define the resolution to use.
      ResolutionPreset.high,
      // disable audio capturing
      enableAudio: false,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  /* addStringToSF(String imagePath) async {
    if(imagePath != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("testImagePath", imagePath);
    }
    else if(imagePath == null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("testImagePath", "");
    }
  }*/

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  addStringToSFList(String imagePath) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> prefList = prefs.getStringList("imagePathList");

    if (prefList == null) {
      prefList = [];
    }

    if (imagePath != null) {
      prefList.add(imagePath);
    } else {
      prefList.add("undefined");
    }

    prefs.setStringList("imagePathList", prefList);
  }

  Future<File> fixExifRotation(String imagePath) async {
    debugPrint("in fixExif");

    final originalFile = File(imagePath);
    List<int> imageBytes = await originalFile.readAsBytes();

    final originalImage = img.decodeImage(imageBytes);

    final height = originalImage.height;
    final width = originalImage.width;

    // Let's check for the image size
    // This will be true also for upside-down photos but it's ok for me
    if (height >= width) {
      // I'm interested in portrait photos so
      // I'll just return here
      return originalFile;
    }

    // We'll use the exif package to read exif data
    // This is map of several exif properties
    // Let's check 'Image Orientation'
    final exifData = await readExifFromBytes(imageBytes);

    img.Image fixedImage;

    if (height < width) {
      debugPrint('Rotating image necessary');

      /* exifData.keys.forEach((element){
        debugPrint(element);
      });

      debugPrint(exifData["ComponentsConfiguration"].toString());*/

      // rotate
      /*if (exifData['Image Orientation'].printable.contains('Horizontal')) {
        fixedImage = img.copyRotate(originalImage, 90);
      } else if (exifData['Image Orientation'].printable.contains('180')) {
        fixedImage = img.copyRotate(originalImage, -90);
      } else if (exifData['Image Orientation'].printable.contains('CCW')) {
        fixedImage = img.copyRotate(originalImage, 180);
      } else {
        fixedImage = img.copyRotate(originalImage, 0);
      }*/

      // TODO in the final build on devices check for right orientation
      fixedImage = img.copyRotate(originalImage, 90);
    }

    // Here you can select whether you'd like to save it as png
    // or jpg with some compression
    // I choose jpg with 100% quality
    final fixedFile =
        await originalFile.writeAsBytes(img.encodeJpg(fixedImage));

    return fixedFile;
  }

  File _image;
  final picker = ImagePicker();
  bool _noImageChosen = false;

  Future getImage(String newPath) async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        File(pickedFile.path).copy(newPath);
        _image = File(newPath); // hier wird das Bild zum File
        //
        _noImageChosen = false;
      } else {
        debugPrint('No image selected.');
        _image = null;
        _noImageChosen = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //if keyboard is still exposed when entering the camera screen, dismiss it
    keyboardController.onChange;
    if (keyboardController.isVisible) {
      FocusScope.of(context).unfocus();
    }

    if (!_controller.value.isInitialized) {
      return Container();
    }

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          //expanded fixed the overflow exception with the keyboard
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.88,
              child: Stack(
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: FutureBuilder<void>(
                      future: _initializeControllerFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          // If the Future is complete, display the preview.
                          return CameraPreview(_controller);
                        } else {
                          // Otherwise, display a loading indicator.
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 50, right: 20),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: FloatingActionButton.extended(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ImpressumScreen()));
                        },
                        label: Icon(
                          Icons.info,
                          color: Colors.black,
                        ),
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.05,
            child: Scaffold(
              backgroundColor: Colors.black,
              floatingActionButton: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FloatingActionButton.extended(
                    heroTag: "choose",
                    // Provide an onPressed callback.
                    onPressed: () async {
                      // Take the Picture in a try / catch block. If anything goes wrong,
                      // catch the error.
                      try {
                        // Find the local app directory using the `path_provider` plugin.
                        final String directoryPath = await _localPath;

                        // Construct the path where the image should be saved using the
                        // pattern package.
                        final path = join(
                          // Store the picture in the local app directory.
                          directoryPath,
                          '${DateTime.now()}.png',
                        );

                        // getting the image using the gallery chooser
                        // copying the chosen image to local app directory
                        await getImage(path);

                        if (_image != null) {
                          // saving path to device storage
                          await addStringToSFList(path);

                          // maybe fixing rotation
                          //await fixExifRotation(path);
                          File fileImageFromGallery =
                              File(path); // die Fkt um ein File zu erhalten
                          final textFromGallery =
                              await FirebaseMLApi.recogniseText(
                                  fileImageFromGallery);
                          //print(textFromGallery);
                          //List <Ingredient> ingredients = leven.getIndividualItems(textFromGallery);
                          List<Ingredient> ingredients =
                              FastLevenshtein.getIndividualItems(
                                  textFromGallery);
                          //print(ingredients);

                          // If the picture was chosen, display it on a new screen.
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DisplayPictureScreen(
                                  appBarTitle: 'Selected product',
                                  imagePath: path,
                                  ingredients:
                                      ingredients), // tempList => list of ingredients per item
                            ),
                          );
                        } else if (_image == null && _noImageChosen) {
                          /*Navigator.push(
                                  context,
                                    MaterialPageRoute(builder: (context) =>
                                        AlertDialog(
                                          title: Text("Fehler: Es wurde kein Bild ausgewählt."),
                                          actions: [
                                            FlatButton(
                                              child: Text("OK"),
                                              onPressed: () {
                                                Navigator.pop(context);
                                                },
                                            ),
                                          ],
                                        )
                                    ),
                              );*/

                          final snackbar = SnackBar(
                              content: Text(
                                  "Error: You have not selected an image."),
                              backgroundColor: Colors.red,
                              duration: Duration(seconds: 3),
                              margin: EdgeInsets.all(18.0),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25))));

                          Scaffold.of(context).showSnackBar(snackbar);
                        }

                      } catch (e) {
                        // If an error occurs, log the error to the console.
                        print(e);
                      }
                    },
                    label: Icon(Icons.photo_library, color: Colors.black),
                    backgroundColor: Colors.white,
                  ),
                  FloatingActionButton.extended(
                    heroTag: "make",
                    // Provide an onPressed callback.
                    onPressed: () async {
                      // Take the Picture in a try / catch block. If anything goes wrong,
                      // catch the error.
                      try {
                        // Ensure that the camera is initialized.
                        await _initializeControllerFuture;

                        // Find the local app directory using the `path_provider` plugin.
                        final String directoryPath = await _localPath;
                        //alter current date and save as basename
                          final currentDate = await RecordDate.recordDateNow();
                          print(currentDate);
                        // Construct the path where the image should be saved using the
                        // pattern package.
                        final path = join(
                          // Store the picture in the local app directory.
                          directoryPath,
                          '${DateTime.now()}' + '.' + currentDate +'.png',
                        );

                        // saving path to device storage
                        //await addStringToSF(path);
                        await addStringToSFList(path);

                        // Attempt to take a picture and log where it's been saved.
                        await _controller.takePicture(path);
                        await fixExifRotation(path);
                        File fileImageFromCam =
                            File(path); // die Fkt um ein File zu erhalten
                        final textFromCam =
                            await FirebaseMLApi.recogniseText(fileImageFromCam);
                        //List <Ingredient> ingredients = leven.getIndividualItems(textFromCam);
                        List<Ingredient> ingredients =
                            FastLevenshtein.getIndividualItems(textFromCam);
                        // If the picture was taken, display it on a new screen.
                        //List<Ingredient> testDb = leven.getIndividualItems(textFromCam);
                        //print(testDb);
                        if (textFromCam != " ") {
                          print(textFromCam);

                          // If the picture was taken, display it on a new screen.
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DisplayPictureScreen(
                                  appBarTitle: 'Scanned product',
                                  imagePath: path,
                                  ingredients:
                                      ingredients), // tempList => list of ingredients per item
                            ),
                          );
                        } else {
                          final snackbarCam = SnackBar(
                              content: Text("Error: No text was recognized."),
                              backgroundColor: Colors.red,
                              duration: Duration(seconds: 3),
                              margin: EdgeInsets.all(18.0),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25))));

                          Scaffold.of(context).showSnackBar(snackbarCam);
                        }
                      } catch (e) {
                        // If an error occurs, log the error to the console.
                        print(e);
                      }
                    },
                    label: Text('Take a picture',
                        style: TextStyle(color: Colors.black)),
                    icon: Icon(Icons.camera_alt, color: Colors.black),
                    backgroundColor: Colors.white,
                  ),
                ],
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              //resizeToAvoidBottomInset: true,
              //resizeToAvoidBottomPadding: true,
            ),
          ),
        ],
      ),
    );
  }
}


tempList(List<Ingredient> ingredients) {
  List<Ingredient> temp = ingredients;

  return temp;
}

/*class Ingredient {
  String name;
  String rating;

  Ingredient({this.name, this.rating});
}*/

/*return DataRow(
        cells: [
          DataCell(Text(key)),
          DataCell(Text(value)),
        ],
      );
    });*/
