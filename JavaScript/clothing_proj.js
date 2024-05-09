const database = SpreadsheetApp.getActiveSpreadsheet().getSheetByName("Database");
const terminal = SpreadsheetApp.getActiveSpreadsheet().getSheetByName("Terminal");
const databaseRange = "A2:C";
const ui = SpreadsheetApp.getUi();
const terminalRange = terminal.getRange("B6:D6");

function addClothing() {
  if (terminalRange.getValues()[0][0] != "" || terminalRange.getValues()[0][1] != "" || terminalRange.getValues()[0][2] != "") {
    var [terminalName, terminalPrice, terminalLink] = terminalRange.getValues()[0];
    var nextRow = getNextAvailableRow(database.getRange(databaseRange));

    database.getRange(nextRow, 1, 1, 3).setValues([[terminalName, terminalPrice, `=HYPERLINK("${terminalLink}","${terminalName}")`]]);

    terminalRange.clearContent(); 
  }

  else {
    ui.alert("There is no data in the terminal to add to the database \n Please validate this!");
  }
}


function getNextAvailableRow(sheetRange) {
  var values = sheetRange.getValues();
  for (var i = 0; i < values.length; i++) {
    var row = values[i];
    if (row.every(function(cell) {
      return cell === "";
    })) {
      return i + sheetRange.getRow(); 
    }
  }
  return sheetRange.getLastRow();
}


function onOpen() {
  ui.createMenu('🛠️ Clothing Tools')
      .addItem('Add Piece of Clothing', 'addClothing')
      .addToUi();
}