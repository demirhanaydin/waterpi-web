function takeAction() {
  var button = $('#pumper'),
      action = $('#action_input').val();

  $('#action-form').trigger('submit');

  if (action == 'start') {
    // button.data('action', 'stop');
    $('#action_input').val('stop');
    button.text('stop');
  } else {
    // button.data('action', 'start');
    $('#action_input').val('start');
    button.text('start');
  }
}

$(document).ready(function() {
  $('#action-form').submit(function(event) {
    event.preventDefault(); // Prevent the form from submitting via the browser
    var form = $(this);
    $.ajax({
      type: form.attr('method'),
      url: form.attr('action'),
      data: form.serialize()
    }).done(function(data) {
      // Optionally alert the user of success here...
    }).fail(function(data) {
      // Optionally alert the user of an error here...
    });
  });
});