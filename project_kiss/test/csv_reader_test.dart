import 'package:flutter_test/flutter_test.dart';
import 'package:project_kiss/csv_reader.dart';


void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('Takes CSV Data and stores each value in right position in 2D Array', () async {
    //ARRANGE
    var myCSV = CSV.from(
        path: 'assets/testData.csv', delimiter: ";", title: false);
    bool hasData = await myCSV.initFinished;

    //ACT

    //ASSERT
    expect(myCSV.data[5][2], "Lambert");
  });

  test('Ensures that every line is read', () async {
    //ARRANGE
    var myCSV = CSV.from(
        path: 'assets/testData.csv', delimiter: ";", title: false);
    bool hasData = await myCSV.initFinished;

    //ACT

    //ASSERT
    expect(myCSV.rowsCount, 10);
  });
}