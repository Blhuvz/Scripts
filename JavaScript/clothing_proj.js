const database = SpreadsheetApp.getActiveSpreadsheet().getSheetByName("Database");
const terminal = SpreadsheetApp.getActiveSpreadsheet().getSheetByName("Terminal");
const ui = SpreadsheetApp.getUi();
const terminalRange = terminal.getRange("B6:D6");

const databaseNames = database.getRange("A3:A21").getValues();

function addClothing() {
  if (terminalRange.getValues()[0][0] != "" || terminalRange.getValues()[0][1] != "" || terminalRange.getValues()[0][2] != "") {
    var [terminalName, terminalPrice, terminalLink] = terminalRange.getValues()[0];
    var nextRow = getNextAvailableRow(database.getRange("A2:C"));

    database.getRange(nextRow, 1, 1, 3).setValues([[terminalName, terminalPrice, `=HYPERLINK("${terminalLink}","${terminalName}")`]]);

    terminalRange.clearContent(); 
  }

  else {
    ui.alert("There is no data in the terminal to add to the database \n Please validate this!");
  }
}


function updateClothing() {
  var clothing = ui.prompt("Enter the name of the clothing you want to update: ");
  var userInput = clothing.getResponseText();

  var requestedValue = ui.prompt("Enter the name of the new piece of clothing: ");
  var requestedInput = requestedValue.getResponseText();

  var clothingExists = false;

  for (let i = 0; i < databaseNames.length; i++) {
    if (databaseNames[i][0] === userInput && userInput != "" && requestedInput != "") {
      var cell = database.getRange("A" + (i + 3));

      cell.setValue(requestedInput);

      clothingExists = true;
      break;
    }
  }

  if (!clothingExists) {
    ui.alert("Invalid Input, Please validate your data");
  }
}


function getNextAvailableRow(sheetRange) {
  var values = sheetRange.getValues();
  for (let i = 0; i < values.length; i++) {
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
      .addItem('Update a Piece of Clothing', 'updateClothing')
      .addToUi();
}