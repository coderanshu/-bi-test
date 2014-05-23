var GlobalVocabList = [
  // Labs
  {label:"blood urea nitrogen", value:{code_system:"LOINC", code:"12961-9", name:"blood urea nitrogen"}},
  {label:"bicarbonate", value:{code_system:"LOINC", code:"14627-4", name:"bicarbonate"}},
  {label:"alanine aminotransferase", value:{code_system:"LOINC", code:"1742-6", name:"alanine aminotransferase"}},
  {label:"albumin, serum", value:{code_system:"LOINC", code:"1751-7", name:"albumin, serum"}},
  {label:"aspartate aminotransferase", value:{code_system:"LOINC", code:"1920-8", name:"aspartate aminotransferase"}},
  {label:"creatinine", value:{code_system:"LOINC", code:"2161-8", name:"Creatinine"}},
  {label:"platelets", value:{code_system:"LOINC", code:"26515-7", name:"platelets"}},
  {label:"arterial pH", value:{code_system:"LOINC", code:"2746-6", name:"arterial pH"}},
  {label:"aterial pO2", value:{code_system:"LOINC", code:"3148-4", name:"arterial pO2"}},
  {label:"arterial pCO2", value:{code_system:"LOINC", code:"33022-5", name:"arterial pCO2", units:"mm Hg"}},
  {label:"hemoglobin", value:{code_system:"LOINC", code:"726-0", name:"hemoglobin"}},
  {label:"serum sodium (mEq/L)", value:{code_system:"LOINC", code:"2951-2", name:"serum sodium", units:"mEq/L"}},

  // Vital signs
  {label:"systolic blood pressure", value:{code_system:"LOINC", code:"8480-6", name:"Systolic blood pressure"}},
  {label:"diastolic blood pressure", value:{code_system:"LOINC", code:"8462-4", name:"diastolic blood pressure"}},
  {label:"heart rate", value:{code_system:"LOINC", code:"LP32063-7", name:"heart rate"}},
  {label:"temperature (F)", value:{code_system:"LOINC", code:"LP29701-7", name:"temperature", units:"F"}},
  {label:"body weight (lbs)", value:{code_system:"LOINC", code:"3141-9", name:"body weight", units:"lbs"}},
  {label:"height (in)", value:{code_system:"LOINC", code:"LP64598-3", name:"height", units:"in"}},

  // Ventilator setting
  {label:"tidal volume", value:{code_system:"LOINC", code:"20112-9", name:"tidal volume"}},
  {label:"ventilator set rate", value:{code_system:"LOINC", code:"19834-1", name:"ventilator set rate"}},
  {label:"plateau pressure", value:{code_system:"LOINC", code:"LP94729-8", name:"plateau pressure"}},
  {label:"fraction of inspired oxygen", value:{code_system:"LOINC", code:"19994-3", name:"fraction of inspired oxygen"}},

  // Nursing documentation
  {label:"Glasgow Coma Scale", value:{code_system:"SNOMEDCT", code:"386557006", name:"Glasgow Coma Scale"}},
  {label:"CAM-ICU", value:{code_system:"LOINC", code:"LP74647-6", name:"CAM-ICU"}},
  {label:"CIWA score", value:{code_system:"BI", code:"ciwa_score", name:"CIWA score"}},

  // Medications
  {label:"phenylephrine", value:{code_system:"RXNORM", code:"8163", name:"phenylephrine"}},
];

var VentAirwayValueList = [
  {label:"ETT", value:"ETT"},
  {label:"Trach", value:"Trach"},
  {label:"NC", value:"NC"},
  {label:"Nasal", value:"NC"},
  {label:"Facemask", value:"Facemask"},
];

var VentSupportValueList = [
  {label:"Yes", value:"Y"},
  {label:"No", value:"N"},
];

var VentModeValueList = [
  {label:"AC", value:"AC"},
  {label:"SIMV", value:"SIMV"},
  {label:"APRV", value:"APRV"},
  {label:"PS", value:"PS"},
  {label:"VC+", value:"VC+"},
];
