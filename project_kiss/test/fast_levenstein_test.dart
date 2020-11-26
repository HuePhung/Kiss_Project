import 'package:flutter_test/flutter_test.dart';
import 'package:project_kiss/search/fast_levenshtein.dart';


void main(){
  test('Take a string and return it in reverse',() async{
    //ARRANGE
    final lev = new FastLevenshtein();
    String word = "hello";
    String reversed = "olleh";

    //ACT

    //ASSERT
    expect(lev.reverseString(word), reversed);

  });

  test('Search in a list and return a list of results matching the given maxDistance ',() async{
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

  });
}