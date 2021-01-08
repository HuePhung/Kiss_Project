import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_final/search/fast_levenshtein.dart';
import 'package:test_final/search/ingredient.dart';



void main() async{
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  FastLevenshtein.init();

 //SharedPreferences prefs = await SharedPreferences.getInstance();

  test('Take a string and return it in reverse',() async{
    //ARRANGE


   Ingredient expected = FastLevenshtein.searchForOneIngredient("AQUA", 2);

    //ACT

    //ASSERT
    expect(expected,new Ingredient("AQUA", "", "SOLVENT", "15/10/2010") );

  });

  /*test('Search in a list and return a list of results matching the given maxDistance ',() async{
    //ARRANGE

    final lev = new FastLevenshtein();
    List<String> testList = [
      "joe",
      "john",
      "johny",
      "johnny",
      "jane",
      "jack",
      "lane",
      "tone"
    ];
    List<List<String>> additionalInfoTest = [
      ["abc"],
      ["def"],
      ["ghi"],
      ["jkl"],
      ["mno"],
      ["pqr"],
      ["stu"],
      ["vwx"]
    ];
    //ACT
 
    for (int i=0; i < 8; i++){
      lev.root.add(testList[i], additionalInfoTest[i]);
    }
    //ASSERT
    List<String> levenTestResults = lev.search("jane", 0).keys.toList();

   expect(levenTestResults, ["jane"]);

  });*/
}