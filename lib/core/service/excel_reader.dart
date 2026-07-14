import 'package:excel_plus/excel_plus.dart';
import 'package:firebaseappdistribution/data/data.dart';
import 'package:flutter/rendering.dart';

abstract class ExcelReader {
  static Future<List<T>> readPremiumRate<T>({
    required String path,
    required List<String> columns,
    required List<String> sheets,
    required T Function(Map<String, dynamic> map) fromMap,
  }) async {
    // Master list to collect mapped objects from all valid sheets
    final List<T> results = [];

    // 3. Read the file into raw bytes
    final file = await FileStorageService.getSecureDocument(path);

    // 4. Decode the raw bytes using excel_plus
    var excel = Excel.decodeBytes(file);

    // 5. Iterate through every available Sheet in the Workbook
    for (String sheetName in excel.tables.keys) {
      // Check if this sheet is included in the target sheets list.
      if (sheets.isNotEmpty && !sheets.contains(sheetName)) {
        debugPrint('Skipping Sheet: $sheetName (Not in target sheets list)');
        continue;
      }

      debugPrint('--- Processing Sheet: $sheetName ---');

      var table = excel.tables[sheetName];
      if (table == null || table.maxRows == 0) {
        debugPrint('This worksheet is empty.');
        continue;
      }

      // 6. Extract Column Headers dynamically, falling back to default columns when empty
      List<String> headers = [];
      var firstRow = table.row(0);
      int columnCount = table.maxColumns; // excel_plus uses maxCols

      for (int colIndex = 0; colIndex < columnCount; colIndex++) {
        String parsedHeader = '';
        if (colIndex < firstRow.length) {
          parsedHeader = firstRow[colIndex]?.value?.toString().trim() ?? '';
        }

        // If the parsed Excel header is missing or empty, use your default columns configuration
        if (parsedHeader.isEmpty) {
          if (colIndex < columns.length) {
            parsedHeader = columns[colIndex];
          } else {
            parsedHeader = 'Column_${colIndex + 1}';
          }
        }
        headers.add(parsedHeader);
      }

      debugPrint('Resolved Headers/Columns: $headers');

      // 7. Process remaining data rows (Starting from index 1)
      for (int rowIndex = 1; rowIndex < table.maxRows; rowIndex++) {
        var row = table.row(rowIndex);
        Map<String, dynamic> rowMap = {};

        for (int colIndex = 0; colIndex < headers.length; colIndex++) {
          String columnName = headers[colIndex];

          if (columnName.isNotEmpty) {
            // Fallback safely to null if a data row runs shorter than the header template row
            var cellValue = colIndex < row.length ? row[colIndex]?.value : null;

            // Map the raw data value to its corresponding header name
            rowMap[columnName] = cellValue;
          }
        }

        // Convert the Map into your generic model T using the fromMap function
        try {
          T entity = fromMap(rowMap);
          results.add(entity);
        } catch (e) {
          debugPrint('Error mapping row $rowIndex in sheet $sheetName: $e');
        }
      }
    }

    // Return the complete collection after parsing all targeted sheets
    return results;
  }
}
