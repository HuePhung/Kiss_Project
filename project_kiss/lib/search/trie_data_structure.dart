import 'dart:core';

import 'package:test_final/search/ingredient.dart';


class TrieNode {
  Ingredient ingredient;

  List<String> info = List();
  String char;
  Map<String,TrieNode> children = new Map();
  bool isLeafNode = false;
  bool isRoot;
  TrieNode parent;
  TrieNode();
  TrieNode.withLetter(this.char);
  toString() => "($char, $children)";
  int distance;
}

class Trie {
  TrieNode root;
  Trie() {
    root = new TrieNode();
    root.isRoot = true;
  }

  void add(String word, Ingredient ingredient) {
    Map children = root.children;
    TrieNode currParent = root;
    //currParent = root;

    for (int i = 0; i < word.length; i++) {
      String c = word[i];
      TrieNode node;
      if (children.containsKey(c)) {
        node = children[c];
      }
      else {
        node = new TrieNode.withLetter(c);
        node.isRoot = false;
        node.parent = currParent;
        //root.children[c] = node;
        children.putIfAbsent(c, () => node);
      }
      children = node.children;
      currParent = node;

      if (i == word.length - 1) {
        node.isLeafNode = true;
        node.ingredient = ingredient;
      }
    }
  }

  TrieNode searchNode(String word) {
    TrieNode node;
    word = word.toUpperCase();
    Map<String,TrieNode> children = root.children;
    for (int i = 0; i < word.length; i++) {
      String c = word[i];
      if (children.containsKey(c)) {
        node = children[c];
        children = node.children;
      }
      else
        return null;
    }

    return node;
  }
  String buildWord(TrieNode node){
    TrieNode currParent = node.parent;
    String actualWord = node.char;
    while(currParent != null){
      if(currParent.parent != null){
        actualWord += currParent.char;
      }
      currParent = currParent.parent;
    }
    return reverseString(actualWord);
  }
  //needed to print
  static String reverseString(String s) {
    var sb = new StringBuffer();
    for(var i = s.length - 1; i >= 0; --i) {
      sb.write(s[i]);
    }
    return sb.toString();
  }
}
