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
  CSV.from({this.path, this.delimiter = ",", this.title = false}){
    _futureDone = _init();
  }

  _init() async {

    String rawString= await rootBundle.loadString(path);
    List<String> rawData = LineSplitter().convert(rawString);

    this.rowsCount = rawData.length; // row length

    /// Split by delimiter
    for (int i = this.title ? 1 : 0; i < this.rowsCount; i++) {
      this.data.add(rawData[i].split(this.delimiter));
    }

    /// column length
    this.columnCount = this.data[0].length;

  }

  ///  Await the instance of Reader
  Future get initFinished => _futureDone;

  /// Access cells directly
  operator [](int i) => this.data[i];
}