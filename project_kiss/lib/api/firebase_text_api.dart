import 'dart:io';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:test_final/search/fast_levenshtein.dart';
import 'package:test_final/search/ingredient.dart';

class FirebaseMLApi {
  static Future<String> recogniseText(File imageFile) async {
    if (imageFile == null) {
      return 'No selected image';
    } else {
      final visionImage = FirebaseVisionImage.fromFile(imageFile);
      final textRecognizer = FirebaseVision.instance.textRecognizer();
      try {
        final visionText = await textRecognizer.processImage(visionImage);
        await textRecognizer.close();

        final text = extractText(visionText);
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

    //Start nach "Ingredients"
    //FastLevenshtein startLeven = new FastLevenshtein();
    List<String> recogTextList = text.split(" ");

    for (var i=0; i <recogTextList.length; i++){
      //ingridientsListItems.add(myCSV.data[i][0]);
      //startLeven.root.add(recogTextList[i].toUpperCase(), new Ingredient("dummy", "dummy", "dummy", i.toString()));
      FastLevenshtein.root.add(recogTextList[i].toUpperCase(), new Ingredient("dummy", "dummy", "dummy", i.toString()));
    }
    //Ingredient searchResult = startLeven.searchForOneIngredient("INGREDIENTS", 3);
    Ingredient searchResult = FastLevenshtein.searchForOneIngredient("INGREDIENTS", 3);
    int index;
    if (searchResult.date != "error"){
      index = int.parse(searchResult.date) +1; // +1 da "INGREDIENTS" ausschließen
    } else{
      index= 0;
    }
    
    String returnText = "";
    for(int i = index  ; i < recogTextList.length; i++){
      returnText = returnText +  recogTextList[i] + " ";
    }
    //print(returnText);
   /* String pattern = r'INGREDIENTS[\s\S]*(\sml)'; //INGREDIENTS[\s\S]*ml
    RegExp re = new RegExp(pattern, caseSensitive: false);
    Match match = re.firstMatch(text);
    String finale = text.substring(match.start, match.end);
    text = finale;
    return text;*/
    return returnText;

  }

}