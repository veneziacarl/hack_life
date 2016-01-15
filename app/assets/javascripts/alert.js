$(document).on('click', '.alert-box a.close', function() {
  $('.alert-box').remove();
  $('.messages').append('<div class="spacer"></div>');
});
