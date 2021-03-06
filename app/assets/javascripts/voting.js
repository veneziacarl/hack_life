var makeAjaxRequestPost = function(buttonEle, reviewId, voteScore) {
  var request = $.ajax({
    method: 'POST',
    data: { score: voteScore },
    url: '/api/v1/reviews/' + reviewId + '/votes'
  });

  request.success(function(data) {
    var buttons = $(buttonEle).closest('.vote_buttons_create');
    $(buttons).removeClass('vote_buttons_create');
    $(buttons).addClass('vote_buttons_update');
    var voteButtons = $(buttons).children();
    for (var i = 0; i < voteButtons.length; i++) {
      $(voteButtons[i]).attr('action',
        '/reviews/' + reviewId + '/vote/' + data.vote.id);
    }
    var parentRevScore = $(buttonEle).closest('tr.rev_row').find('.rev_score');
    parentRevScore.text(data.data.review.sum_score);
    if (voteScore == 1) {
      $(buttonEle).find('input.vote').addClass('upvoted');
    } else if (voteScore == -1) {
      $(buttonEle).find('input.vote').addClass('downvoted');
    }
    $('.flash-ajax').remove();
    $('.messages').append('<div class="spacer"></div>');
  });
};

var makeAjaxRequestUpdate = function(buttonEle, reviewId, voteId, voteScore) {
  var request = $.ajax({
    method: 'PATCH',
    data: { score: voteScore },
    url: '/api/v1/reviews/' + reviewId + '/votes/' + voteId
  });

  request.success(function(data) {
    var parentRevScore = $(buttonEle).closest('tr.rev_row').find('.rev_score');
    parentRevScore.text(data.review.sum_score);
    var parentVoteButtons = $(buttonEle).closest('.vote_buttons_update');
    if (voteScore == 1) {
      $(parentVoteButtons).find('input.downvoted').removeClass('downvoted');
      $(buttonEle).find('input.vote').addClass('upvoted');
    } else if (voteScore == -1) {
      $(parentVoteButtons).find('input.upvoted').removeClass('upvoted');
      $(buttonEle).find('input.vote').addClass('downvoted');
    }
    $('.flash-ajax').remove();
    $('.messages').append('<div class="spacer"></div>');
  });

  request.error(function(data) {
    $('.spacer').remove();
    $('.messages').html(
      '<div data-alert class="alert-box info radius flash flash-ajax">' +
      data.responseJSON.error + '<a href="#" class="close">&times;</a></div>');
  });
};

$(document).ready(function() {
  $(document).on('click', '.vote_buttons_create', function(event) {
    event.preventDefault();

    var reviewButton = event.target;
    var reviewButtonTo = $(reviewButton).closest('.button_to');
    var reviewId = $(reviewButtonTo).attr('action').match(/\/(\d+)\//)[1];
    var voteType = $(reviewButtonTo).find('.vote').attr('value');

    makeAjaxRequestPost(reviewButtonTo, reviewId, voteType);
  });


  $(document).on('click', '.vote_buttons_update', function(event) {
    event.preventDefault();

    var reviewButton = event.target;
    var reviewButtonTo = $(reviewButton).closest('.button_to');
    var reviewId = $(reviewButtonTo).attr('action').match(/\/(\d+)\//)[1];
    var voteId = $(reviewButtonTo).attr('action').match(/\/(\d+$)/)[1];
    var voteType = $(reviewButtonTo).find('.vote').attr('value');

    makeAjaxRequestUpdate (reviewButtonTo, reviewId, voteId, voteType);
  });
});
