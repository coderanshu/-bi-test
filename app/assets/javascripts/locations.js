$(function() {
  setTimeout(sortPatientPanels, 1000);
  $("#container").on('click', '.add-data a', function(event) {
    event.preventDefault();
    addPatientData($(this).attr("data-patientid"));
  });
  $("#patient_search_panel").on("keyup", 'input', function(event) {
    delay(function(){
      $("#patient_search").submit();
    }, 200 );
  });
});

var delay = (function(){
  var timer = 0;
  return function(callback, ms){
    clearTimeout (timer);
    timer = setTimeout(callback, ms);
  };
})();

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

function addPatientData(id) {
  getPatientDataForm(id, 'observations');
  getPatientDataForm(id, 'alerts');
  getPatientDataForm(id, 'flowsheets');
  getPatientDataForm(id, 'checklists');
  displayAddDataDialog();
}

function getPatientDataForm(id, controller) {
  $.ajax({
    type: "GET",
    url: '/' + controller + '/new?patient_id=' + id,
    contentType: 'text/javascript',
    success: function(data) {
      $("#dialog #" + controller + "-tab").html(data);
    },
    error: function(err) {
      if (err.status == 200) {
        $("#dialog #" + controller + "-tab").html(err.responseText);
      }
    }
  });
}

function displayAddDataDialog(obsForm, alertForm) {
  $("#dialog").dialog(
    {
      minWidth: 500,
      minHeight: 500,
      modal: true,
      buttons: {
        Save: function() {
          submitAddData();
        },
        Cancel: function() {
          closeDialog();
        }
      }
    }).dialog('open');
}

function submitAddData() {
  var activeTab = $("#tabs").tabs('option', 'active');
  if (activeTab == 2) { // Observation
    $.ajax({
      type: "POST",
      url: '/observations/',
      data: $('#new_observation :input').serialize(),
      success: function() { closeDialog(); },
      error: function(err) {
        if (err.status == 200) { closeDialog(); }
      }
    });
  }
  else if (activeTab == 3) {  // Alert
    $.ajax({
      type: "POST",
      url: '/alerts/',
      data: $('#new_alert :input').serialize(),
      success: function() { seeLocationChanges(); closeDialog(); },
      error: function(err) {
        if (err.status == 200) { seeLocationChanges(); closeDialog(); }
      }
    });
  }
}

function closeDialog() { $("#dialog").dialog('close') }

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

function seeLocationChanges() {
  dialogDisplay = $(".ui-dialog").css('display');
  if (dialogDisplay != 'none' && dialogDisplay != undefined) {
    setTimeout(function() { seeLocationChanges(); }, 15000);
    return;
  }

  location_id = $("#location_id").val();
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

  setTimeout(function() { seeLocationChanges(); }, 15000);
}
