function Script() {
  var spreadsheet = SpreadsheetApp.getActiveSpreadsheet();
  var eventHostingSheet = spreadsheet.getSheetByName('Event Hosting');
  var sourceRangeValues = eventHostingSheet.getRange('A3:A').getValues().flat().filter(String);

  for (var i = sourceRangeValues.length - 1; i > 0; i--) {
    var j = Math.floor(Math.random() * (i + 1));
    [sourceRangeValues[i], sourceRangeValues[j]] = [sourceRangeValues[j], sourceRangeValues[i]];
  }

  var targetRanges = [
    eventHostingSheet.getRange('F9:F18'),
    eventHostingSheet.getRange('G9:G18'),
    eventHostingSheet.getRange('I9:I18'),
    eventHostingSheet.getRange('J9:J18')
  ];

  var teamsCount = targetRanges.length;
  var valuesPerTeam = Math.floor(sourceRangeValues.length / teamsCount);
  var remainder = sourceRangeValues.length % teamsCount;

  var currentIndex = 0;

  for (var i = 0; i < teamsCount; i++) {
    var targetRange = targetRanges[i];

    var valuesToAssign = valuesPerTeam + (i < remainder ? 1 : 0);

    var selectedValues = sourceRangeValues.slice(currentIndex, currentIndex + valuesToAssign);

    while (selectedValues.length < 10) {
      selectedValues.push([""]);
    }

    var formattedValues = selectedValues.map(function (value) {
      return [value];
    });

    targetRange.setValues(formattedValues);

    currentIndex += valuesToAssign;

    randomNumbers();
  }
}

function randomNumbers() {
  var spreadsheet = SpreadsheetApp.getActiveSpreadsheet();
  var eventHostingSheet = spreadsheet.getSheetByName('Event Hosting');
  var rangeA = eventHostingSheet.getRange('A3:A');
  var valuesA = rangeA.getValues().flat().filter(String);
  var count = valuesA.length;

  if (count > 0) {
    var randomNumbers = generateRandomNumbers(count);
    eventHostingSheet.getRange('C3:C' + (count + 2)).setValues(randomNumbers);
  }
}

function generateRandomNumbers(count) {
  var randomNumbers = [];
  var uniqueNumbers = new Set();

  for (var i = 0; i < count; i++) {
    var randomNum;
    do {
      randomNum = Math.floor(Math.random() * count) + 1;
    } while (uniqueNumbers.has(randomNum));

    uniqueNumbers.add(randomNum);
    randomNumbers.push([randomNum]);
  }

  return randomNumbers;
}