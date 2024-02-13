function importData() {
  var targetSheetName = dropdown.getValue();
  if (!targetSheetName) {
    Logger.log("No sheet selected in the dropdown.");
    return;
  }

  var targetSheet = activeSpreadsheet.getSheetByName(targetSheetName);
  if (!targetSheet) {
    Logger.log("This sheet doesn't exist.", "Sheet '" + targetSheetName + "' does not exist.");
    return;
  }

  var sheetRange = targetSheet.getRange("A1:P79");
  var sheetData = sheetRange.getValues();
  var notesRange = sheetRange.getNotes();

  var importRange = trainingHistory.getRange("A8");
  var importDataRange = importRange.offset(0, 0, sheetData.length, sheetData[0].length);
  var importNotesRange = importRange.offset(0, 0, sheetData.length, sheetData[0].length);
  importDataRange.setValues(sheetData);
  importNotesRange.setNotes(notesRange);

  Logger.log("Data imported successfully.");
}