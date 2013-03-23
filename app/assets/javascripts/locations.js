function distinct(anArray) {
  var result = [];
  $.each(anArray, function(i,v){
     if ($.inArray(v, result) == -1) result.push(v);
  });
  return result;
}

$(function() {
  setTimeout(updatePatientPanels, 1000);
});

function updatePatientPanels () {
  var scores = []
  $(".patient-panel").each(function() {
    scores.push($(this).data('score'));
  });
  scores = distinct(scores.sort(compareScores));
  if (scores.length > 0) {
    var parent = document.getElementById('container');
    for(var i = 0, l = scores.length; i < l; i++) {
        panels = $(".patient-panel[data-score='" + scores[i] + "']");
        panels.each(function() {
          parent.appendChild(this);
        });
    }

    setTimeout(updatePatientPanels, 60000);
  }
}

// Sorts in descending order
function compareScores(a, b) { return b-a; }

