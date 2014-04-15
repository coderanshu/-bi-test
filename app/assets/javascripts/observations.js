var diagnoses = { "" : "" };
var medications = { "" : "" };
var vitalSigns = { "" : "" };
var labs = {
  "blood urea nitrogen" : {code_system:"LOINC", code:"12961-9", name:"blood urea nitrogen"},
  "bicarbonate" : {code_system:"LOINC", code:"14627-4", name:"bicarbonate"},
  "alanine aminotransferase" : {code_system:"LOINC", code:"1742-6", name:"alanine aminotransferase"},
  "albumin, serum" : {code_system:"LOINC", code:"1751-7", name:"albumin, serum"},
  "aspartate aminotransferase" : {code_system:"LOINC", code:"1920-8", name:"aspartate aminotransferase"},
  "Creatinine" : {code_system:"LOINC", code:"2161-8", name:"Creatinine"},
  "platelets" : {code_system:"LOINC", code:"26515-7", name:"platelets"},
  "pH" : {code_system:"LOINC", code:"2746-6", name:"pH"},
  "paO2" : {code_system:"LOINC", code:"3148-4", name:"paO2"},
  "paCO2" : {code_system:"LOINC", code:"33022-5", name:"paCO2"},
  "hemoglobin" : {code_system:"LOINC", code:"726-0", name:"hemoglobin"}
  };
var nursing = { "" : "" };
var empty = { "" : "" };



function setObservationTypeList(category) {
  var categoryValue = category.val();
  var observationType = category.closest("tr").find("#obs_type");
  observationType.find('option').remove().end();
  
  var dataList;
  if (categoryValue == "DX") {
    dataList = diagnoses;
  } else if (categoryValue == "RX") {
    dataList = medications;
  } else if (categoryValue == "VX") {
    dataList = vitalSigns;
  } else if (categoryValue == "LX") {
    dataList = labs;
  } else if (categoryValue == "NX") {
    dataList = nursing;
  } else {
    dataList = empty;
  }
  
  for(var item in dataList) {
    $('<option value="' + item + '" data-code="' + dataList[item]["code"] + '" data-code-system="' + dataList[item]["code_system"] + '">' + dataList[item]["name"] + '</option>').appendTo(observationType);
  }
}