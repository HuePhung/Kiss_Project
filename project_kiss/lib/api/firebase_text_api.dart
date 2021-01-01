import 'dart:io';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:test_final/search/fast_levenshtein.dart';
import 'package:test_final/search/ingredient.dart';
import 'package:test_final/search/levenshtein.dart';
//import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';

class FirebaseMLApi {
  static Future<String> recogniseText(File imageFile) async {
    if (imageFile == null) {
      return 'No selected image';
    } else {
      //print(imageFile.path);
      final visionImage = FirebaseVisionImage.fromFile(imageFile);
      final textRecognizer = FirebaseVision.instance.textRecognizer();
      //print(textRecognizer.hashCode);
      try {
        final visionText = await textRecognizer.processImage(visionImage);
        await textRecognizer.close();

        final text = extractText(visionText);
        //print(text);
        return text.isEmpty ? 'No text found in the image' : text;
      } catch (error) {
        return error.toString();
      }
    }
  }
  static extractText(VisionText visionText) {
    String text = '';

    for (TextBlock block in visionText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement word in line.elements) {
          text = text + word.text + ' ';
        }
        // text = text + '\n';
      }
    }

   // print(text);
    //Start nach "Ingredients"
    //FastLevenshtein startLeven = new FastLevenshtein();
    List<String> recogTextList = text.split(' ');

    for (var i=0; i <recogTextList.length; i++){
     // print(recogTextList[i] + "("+i.toString()+")");
      //ingridientsListItems.add(myCSV.data[i][0]);
      //startLeven.root.add(recogTextList[i].toUpperCase(), new Ingredient("dummy", "dummy", "dummy", i.toString()));
      FastLevenshtein.root.add("DUMMY " +recogTextList[i].toUpperCase(), new Ingredient("dummy for search: " + recogTextList[i].toUpperCase(), "dummy", "dummy", i.toString()));
    }
    //Ingredient searchResult = startLeven.searchForOneIngredient("INGREDIENTS", 3);
    Ingredient searchResult = FastLevenshtein.searchForOneIngredient("DUMMY INGREDIENTS", 3);
    //Ingredient searchResult2 = FastLevenshtein.searchForOneIngredient("INGREDIENTS/SASTOJCI:", 3);
    int index;
    if (searchResult.date != "error" /*|| searchResult2.date != "error" */){
      index = int.parse(searchResult.date) + 1; // +1 da "INGREDIENTS" ausschließen
      print(index);
      //print("index:" + index.toString());
    } else{
      print("no INGREDIENTS ");
      index= 0;
    }

    
   // int index = Levenshtein.getIndexOfStart(recogTextList);
    String returnText = "";
    for(int i = index  ; i < recogTextList.length; i++){
     // print (recogTextList[i]);
      returnText = returnText +  recogTextList[i] + " ";
    }
    //print(returnText);
   /* String pattern = r'INGREDIENTS[\s\S]*(\sml)'; //INGREDIENTS[\s\S]*ml
    RegExp re = new RegExp(pattern, caseSensitive: false);
    Match match = re.firstMatch(text);
    String finale = text.substring(match.start, match.end);
    text = finale;
    return text;*/
    //print(returnText);
    return returnText;

  }

}