$().ready(function() {
  $(".question input:radio").change(function() {
    saveQuestionResponse(this);
  });

  $(".question input:text").blur(function() {
    saveQuestionResponse(this);
  });
});

function saveQuestionResponse(element) {
  question = $(element).closest("div.question");
  if (question.length) {
    $.ajax({
      type: "POST",
      url: '/observations/',
      data: JSON.stringify({ patient_id: $("#patient_id").val(), question: question[0].id, answer: $(element).val() }),
      dataType: 'json',
      contentType: 'application/json',
      success: function(msg) {

      }
    });
  }
}
