import 'dart:math';
import 'dart:core';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_final/search/ingredient.dart';
import 'csv_reader.dart';
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
  static List _allergyNames = [];
  static Trie root = new Trie();
  static SharedPreferences prefs;
  static void init(){
    //cheap workaround
    _loadCSV().then((value) => _initAllergies());
    _initPrefs();
  }
  static void _initPrefs() async{
    prefs = await SharedPreferences.getInstance();
  }
  static void _initAllergies() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _allergyNames = prefs.getStringList("allergyList");
    if(_allergyNames.isNotEmpty){
    for(String name in _allergyNames){
      TrieNode node = root.searchNode(name);
      node.ingredient.isAllergic = true;
    }
    }
  }
  static Future<bool> _loadCSV() async {
    var myCSV = CSV.from(
        path: 'assets/cosing.csv', delimiter: ";", title: false);
        //hasData does absolutely nothing for me and only returns null which makes this async/await call kinda weird :/
        bool hasData = await myCSV.initFinished;
      for (var i = 0; i < myCSV.data.length; i++) {
        //ingridientsListItems.add(myCSV.data[i][0]);
        root.add(myCSV.data[i][0], new Ingredient(
            myCSV.data[i][0], myCSV.data[i][1], myCSV.data[i][3],
            myCSV.data[i][4]));
    }
      return Future.value(true);
  }

  //returns map with all the words that are similar to the param. word together with the distance
  static Map<String, TrieNode> search(String word, int maxDistance){ //hier
    List<int> currentRow = new List(word.length+1);
    Map<String,TrieNode> results = new Map(); //hier
    for(int j=0;j<currentRow.length;j++){
      currentRow[j] = j;
    }
    for(String letter in root.root.children.keys){
      //not sure why results.addAll doesn't work?
      results = _searchRecursive(root.root.children[letter], letter, word, currentRow, results, maxDistance);
    }
    return results;
  }
  //calls search function but instead of returning a map it only returns the word the smallest distance.
  static Ingredient searchForOneIngredient(String word, int maxDistance){
    MapEntry<String, TrieNode> min = null;
    Map<String, TrieNode> res = search(word, maxDistance);
    //List<String> returnVal = List();
    if(res.length == 1){
      return res.values.first.ingredient;
    }
    Ingredient result;
    for(MapEntry entry in res.entries){
      TrieNode node = entry.value;
      if(min == null || node.distance < min.value.distance){
        min = entry;
      }
    }
    if(min == null){
      //we should come up with a better solution
      return new Ingredient("error", "error", "error", "error");
    }
    result = min.value.ingredient;
    return result;

  }
  static List<Ingredient> autoComplete(String word){
    List<Ingredient> list = new List();
    TrieNode node = root.searchNode(word);
    if(node != null){
      list = _recursiveForAutoComplete(node, list);
    }
    return list;
  }
  //function should only get called via autoComplete() func.
  static List<Ingredient> _recursiveForAutoComplete(TrieNode node, List<Ingredient> list){
    List<Ingredient> ret = list;
    for(TrieNode child in node.children.values){
      if(child.isLeafNode){
        ret.add(child.ingredient);
      }
      _recursiveForAutoComplete(child, ret);
    }
    return ret;
  }
  //get the list of all the allergy ingredients
  static List<Ingredient> getAllergyList() {
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> list = prefs.getStringList("allergyList");
    List<Ingredient> result = [];
    for(String name in list){
      result.add(root.searchNode(name).ingredient);
    }
    return result;
  }
  //function should only get called via search() func.
  static Map<String,TrieNode> _searchRecursive(TrieNode node, String letter, String word, List<int> prevRow, Map<String,TrieNode> results, int maxDistance){ //hier
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
      node.distance = currRow[currRow.length-1];
      results.putIfAbsent(root.buildWord(node), () => node );
    }
      //node.distance = currRow[currRow.length-1];
      //results.putIfAbsent(root.buildWord(node), () => node );
    //if any entries in the row are less than the maximum cost, then recursively search each branch of the trie
    if(currRow.reduce(min) <= maxDistance){
      for(String letter in node.children.keys){
        _searchRecursive(node.children[letter], letter, word, currRow, results, maxDistance);
      }
    }
    return results;
  }
  //needed to calc the min distance for levenshtein
  static int findMin(int x, int y, int z){
    if(x <= y && x <= z)
      return x;
    if(y <= x && y <= z)
      return y;
    else
      return z;
  }

  static int calcDistance(String word){
    var dst = (word.length / 4);
    return dst.toInt();
  }

  static List<Ingredient> getIndividualItems(String startString){
    List<Ingredient> ret = List();
    if (startString.contains(",")){
    //  print("Comma!");
      List<String> ingridientsString;
      ingridientsString = startString.split(",");
      //Delete Whitespace:
      for (int i=0; i < ingridientsString.length; i++){
        ingridientsString[i] = ingridientsString[i].trim();
        ingridientsString[i] = ingridientsString[i].toUpperCase();
        Ingredient result = searchForOneIngredient(ingridientsString[i], 2);
        if(result.name != "error")
            ret.add(result);
      }
      return ret;
    }
    else {
     // print("No comma!");
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
          Ingredient searchResult = searchForOneIngredient(searchString, 2);
         // print(searchString);
          if(searchResult.name != "error"){
            //print("lol ${searchResult.name}");
            ret.add(searchResult);
            i = n ;

            break;
          }

          //für denn fall das nur errors für ein wort gefunden werden:
          if(i == n && searchResult.name == "error" ){

            i = n ;
          }
        }
      }
      return ret;
    }
  }
}