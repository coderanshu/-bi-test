$(function() {
  $(document).on('click', "#problem-list-review .problem-button", function(event) {
    $button = $(event.target);
    $problem = $button.closest('.problem');
    problemID = $problem.attr('data-problemid');
    $.ajax({
      type: "PUT",
      url: '/problems/' + problemID,
      data: JSON.stringify({problem: {id: problemID, status: $button.attr('data-status')} }),
      dataType: 'json',
      contentType: 'application/json',
      success: function() {
        getProblemListForm($problem.attr('data-patientid'));
        seeLocationChanges();
      },
      error: function(err) {
        if (err.status == 200) { seeLocationChanges(); }
      }
    });
  });
});