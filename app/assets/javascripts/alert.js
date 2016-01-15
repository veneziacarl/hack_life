$(document).on('click', '.alert-box a.close', function(event) {
  $('.alert-box').remove();
  $('.messages').append('<div class="spacer"></div>');
});
