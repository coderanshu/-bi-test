$(function() {
  $("#alert-list").on('click', ".alert-button", function(event) {
    $button = $(event.target);
    $alert = $button.closest('.alert');
    alertID = $alert.attr('data-alertid');
    $.ajax({
      type: "PUT",
      url: '/alerts/' + alertID,
      data: JSON.stringify({alert: {id: alertID, status: $button.attr('data-status')} }),
      dataType: 'json',
      contentType: 'application/json',
      success: function() { seeLocationChanges(); },
      error: function(err) {
        if (err.status == 200) { seeLocationChanges(); }
      }
    });
  });

  $("#alert-list").on('click', ".action-button", function(event) {
    $button = $(event.target);
    $alert = $button.closest('.alert');
    alertID = $alert.attr('data-alertid');
    $.ajax({
      type: "PUT",
      url: '/alerts/' + alertID + '/action',
      data: JSON.stringify({alert: {id: alertID, action_id: $button.attr('data-actionid'), action: $button.attr('data-action')} }),
      dataType: 'json',
      contentType: 'application/json',
      success: function() { seeLocationChanges(); },
      error: function(err) {
        if (err.status == 200) { seeLocationChanges(); }
      }
    });
  });
});
