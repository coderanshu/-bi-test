$(function() {
  setTimeout(sortPatientPanels, 1000);
});

function distinct(anArray) {
  var result = [];
  $.each(anArray, function(i,v){
     if ($.inArray(v, result) == -1) result.push(v);
  });
  return result;
}

function sortPatientPanels () {
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

    setTimeout(sortPatientPanels, 60000);
  }
}

// Sorts in descending order
function compareScores(a, b) { return b-a; }

function updateLocationPartial(id) {
  $.ajax({
    type: "GET",
    url: '/locations/' + id,
    contentType: 'text/javascript',
    success: function(data) {
      swapLocationHTML(data);
    },
    error: function(err) {
      if (err.status == 200) {
        swapLocationHTML(err.responseText);
      }
    }
  });
}

function swapLocationHTML(data) {
  $("#" + $(data).attr('id')).replaceWith(data);
  sortPatientPanels();
}

function seeLocationChanges(location_id) {
  $.ajax({
    type: "GET",
    url: '/locations/' + location_id + '/updated?timestamp=' + $("#timestamp").val(),
    contentType: 'application/json',
    success: function(data) {
      if (data.updated) {
        location.reload();
      }
      else {
        if (data.updated_children != undefined && data.updated_children.length > 0) {
          $(data.updated_children).each(function() { updateLocationPartial(this); });
        }
      }

      $("#timestamp").val(data.timestamp);
    }
  });

  setTimeout(function() { seeLocationChanges(location_id); }, 15000);
}
