import 'dart:core';
class TrieNode {
  String word;
  String char;
  Map<String,TrieNode> children = new Map();
  bool isLeafNode = false;
  bool isRoot;
  TrieNode parent;
  TrieNode();
  TrieNode.withLetter(this.char);
  toString() => "($char, $children)";
  List<String> info = List();
  int distance;
}

class Trie {
  TrieNode root;
  Trie() {
    root = new TrieNode();
    root.isRoot = true;
  }

  void add(String word, List<String> list) {
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
        node.info = list;
      }
    }
  }

  TrieNode searchNode(String word) {
    TrieNode node;
    for (int i = 0; i < word.length; i++) {
      String c = word[i];
      if (root.children.containsKey(c)) {
        node = root.children[c];
        root.children = node.children;
      }
      else
        return null;
    }

    return node;
  }
}
