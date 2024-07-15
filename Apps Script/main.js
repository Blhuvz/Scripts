const trainingHistorySheetName = "Training History";
const templateSheetName = "Introduction Template";
const activeSpreadsheet = SpreadsheetApp.getActiveSpreadsheet();
const trainingHistory = activeSpreadsheet.getSheetByName(trainingHistorySheetName);
const templateSheet = activeSpreadsheet.getSheetByName(templateSheetName);
const dropdown = trainingHistory.getRange("D3");

 //Duplicates the sheet based on the template.
function duplicateSheet() {
  try {
    var date = new Date();
    var dateString = Utilities.formatDate(date, activeSpreadsheet.getSpreadsheetTimeZone(), "dd-MM-yyyy");
    var newSheetName;
    var sheetNumber = 1;

    do {
      newSheetName = "Induction " + dateString + (sheetNumber === 1 ? "" : " (" + sheetNumber + ")");
      var sheet = activeSpreadsheet.getSheetByName(newSheetName);
      sheetNumber++;
    } while (sheet);

    var newSheet = templateSheet.copyTo(activeSpreadsheet);
    newSheet.setName(newSheetName);
    newSheet.showSheet();

    var applicantCardRanges = [
      "D13:D16", "I13:I16", "N13:N16",
      "D30:D33", "I30:I33", "N30:N33",
      "D47:D50", "I47:I50", "N47:N50",
      "D64:D67", "I64:I67", "N64:N67"
    ];
    
    let day = (new Date()).getDate();
    let obj = {
      10: "K8:O",
      23: "Q8:U",
      1: "W8:AA"
    };

    Logger.log("day: " + day);
    Logger.log("Selected data range: " + obj[day]);
    
    let data = SpreadsheetApp.getActiveSpreadsheet().getSheetByName("Data").getRange(obj[day]).getValues().filter(e => e[0] != "");

    Logger.log("Data retrieved from 'Data' sheet: " + JSON.stringify(data));

    for (let [i, applicant] of Object.entries(data)) {
  if (applicant && applicant.length >= 4) {
    let forumID = (applicant[3] || '').split("profile/")[1]?.split("-")[0] || '';
    newSheet.getRange(applicantCardRanges[i]).setValues([[applicant[0]], [applicant[1]], [forumID], [applicant[2]] ]);
    console.log("Applicant:", applicant); 
  } else {
    console.error("Invalid applicant data at index " + i);
  }
}

    Logger.log("Script executed successfully.");
  } catch (error) {
    console.error("An issue has come up with this script: " + error);
  }
}

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