$(function() {
  $("#manage_patients").on('click', '.add_patient', function(event) {
    event.preventDefault();
    displayAddPatientDialog();
  });
});

function displayAddPatientDialog() {
  $("#dialog").dialog({
      minWidth: 500,
      minHeight: 500,
      width: 650,
      modal: true,
      buttons: {
        Save: function() {
          submitAddPatient();
        },
        Cancel: function() {
          closeDialog();
        }
      }
    }).dialog('open');
}

function submitAddPatient() {
  $.ajax({
    type: "POST",
    url: '/patients/',
    data: $('#new_patient :input').serialize(),
    success: function() { closeDialog(); window.location.reload(); },
    error: function(err) {
      if (err.status == 200) { closeDialog();  window.location.reload(); }
    }
  });
}