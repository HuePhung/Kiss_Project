import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/services.dart';

class CSV {

  Future<void> _futureDone;
  String path;
  String delimiter;
  int rowsCount;
  int columnCount;
  bool title;
  List<List<String>> data = [];

  /// Read from Path
  CSV.from({this.path, this.delimiter = ",", this.title = false}) {
    _futureDone = _init();
  }

  _init() async {

    String rawString= await rootBundle.loadString(path);
    List<String> rawData = LineSplitter().convert(rawString);
    //print(rawData.length);
    /// row length is the length of the map as the map has the same number of lines in the CSV File
    this.rowsCount = rawData.length; // row length

    /// If ParseTitle is false, We skip, we split those strings by our delimiter
    for (int i = this.title ? 1 : 0; i < this.rowsCount; i++) {
      this.data.add(rawData[i].split(this.delimiter));
    }

    /// column length is the length of any inner array
    this.columnCount = this.data[890].length;

  }

  /// This ensures that we can await the instance of this Reader making it more flexible
  Future get initFinished => _futureDone;

  /// Allowing access of any cell by using X[i][k]
  operator [](int i) => this.data[i];
}