import 'dart:math';
import 'dart:core';
import 'trie_data_structure.dart';
class FastLevenshtein {
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
  Trie root = new Trie();
  void init(){

    /*for(String word in testList){
      root.add(word);
    }
    print(search("jane", 2));
    print(searchForOneWord("jane", 2));*/
  }

  //returns map with all the words that are similar to the param. word together with the distance
  Map<String, TrieNode> search(String word, int maxDistance){ //hier
    List<int> currentRow = new List(word.length+1);
    Map<String,TrieNode> results = new Map(); //hier
    for(int j=0;j<currentRow.length;j++){
      currentRow[j] = j;
    }
    for(String letter in root.root.children.keys){
      //not sure why results.addAll doesn't work?
      results = searchRecursive(root.root.children[letter], letter, word, currentRow, results, maxDistance);
    }
    return results;
  }

  //calls search function but instead of returning a map it only returns the word the smallest distance.
  List<String> searchForOneWord(String word, int maxDistance){
    MapEntry<String, TrieNode> min = null;
    Map<String, TrieNode> res = search(word, maxDistance);
    List<String> returnVal = List();
    for(MapEntry entry in res.entries){
      TrieNode node = entry.value;
      if(min == null || node.distance < min.value.distance){
        min = entry;
      }
    }
    if(min == null){
      returnVal.add("error");
      return returnVal;
    }

    returnVal.add(min.key);
    returnVal.addAll(min.value.info);
    return returnVal;
  }
  //function should only get called via search() func.
  Map<String,TrieNode> searchRecursive(TrieNode node, String letter, String word, List<int> prevRow, Map<String,TrieNode> results, int maxDistance){ //hier
    int columns = word.length+1;
    List<int> currRow = [prevRow[0]+1];

    //Build one row for the letter, with a column for each letter in the target word, plus one for the empty string at column 0
    int insertCost,deleteCost,replaceCost;
    for(int column=1;column<columns;column++){
      //int column = columns[i];
      insertCost = currRow[column-1]+1;
      deleteCost = prevRow[column]+1;
      if(word[column-1] != letter) replaceCost = prevRow[column-1]+1;
      else replaceCost = prevRow[column-1];

      currRow.add(findMin(insertCost,deleteCost,replaceCost));

    }

    //if the last entry in the row indicates the optimal cost is less than the maximum cost, and there is a word in this trie node, then add it.
    //if(currRow[currRow.length-1] <= maxCost && node.char != null){
    if(currRow[currRow.length-1] <= maxDistance && node.isLeafNode){
      TrieNode currParent = node.parent;
      String actualWord = node.char;
      while(currParent != null){
        if(currParent.parent != null){
          actualWord += currParent.char;
        }
        currParent = currParent.parent;
      }
      //results.add(reverseString(actualWord));
      //print(node.info);
      node.distance = currRow[currRow.length-1];
      results.putIfAbsent(reverseString(actualWord), () => node );
    }

    //if any entries in the row are less than the maximum cost, then recursively search each branch of the trie
    if(currRow.reduce(min) <= maxDistance){
      for(String letter in node.children.keys){
        searchRecursive(node.children[letter], letter, word, currRow, results, maxDistance);
      }
    }
    return results;
  }
  //needed to calc the min distance for levenshtein
  int findMin(int x, int y, int z){
    if(x <= y && x <= z)
      return x;
    if(y <= x && y <= z)
      return y;
    else
      return z;
  }
  //needed to print out the results
  String reverseString(String s) {
    var sb = new StringBuffer();
    for(var i = s.length - 1; i >= 0; --i) {
      sb.write(s[i]);
    }
    return sb.toString();
  }

  List<List<String>> getIndividualItems(String startString){
    List<List<String>> ret = List();
    if (startString.contains(",")){
      print("Comma!");
      List<String> ingridients;
      ingridients = startString.split(",");
      //Delete Whitespace:
      for (int i=0; i < ingridients.length; i++){
        ingridients[i] = ingridients[i].trim();
        ingridients[i] = ingridients[i].toUpperCase();
       ret.add(this.searchForOneWord(ingridients[i], 2));
      }
      return ret;
    }
    else {

      print("No comma!");
      List <String> spaceDevided = startString.split(" ");

      //for(int i = 0; i < spaceDevided.length; i++){
      //  if(this.searchForOneWord(spaceDevided[i], 2)[0] != "error"){
      //    ret.add(this.searchForOneWord(spaceDevided[i], 2));
      //  }
     // }

      //von vorne:
      int i = 0;

      while ( i < spaceDevided.length){

        //von hinten:
        for (int n = spaceDevided.length; n >= i ; n--){

          //Um aus Liste an einzelnen Wörtern ein String ohne komma zu machen
          String searchString = spaceDevided.sublist(i,n).toString().replaceAll(",", "");

          List<String> searchResult = this.searchForOneWord(searchString, 2);
         // print(searchString);
         print(searchString);
          if(searchResult[0] != "error"){
            ret.add(searchResult);
            i = n ;

            break;
          }

          //für denn fall das nur errors für ein wort gefunden werden:
          if(i == n && searchResult[0] == "error" ){

            i = n ;
          }

        }

      }
      
      
      return ret;
    }
  }
//void setWordList(List<String> words){
// for(String word in words){
//  root.add(word);
//}
//}
}