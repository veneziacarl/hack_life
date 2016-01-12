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
      $(voteButtons[i]).attr('action', '/reviews/' + reviewId + '/vote/' + data['vote']['id']);
    }
    var parentReviewScore = $(buttonEle).closest('.review').find('.score');
    parentReviewScore.text('Score: ' + data.data.review.sum_score);
  });
};

var makeAjaxRequestUpdate = function(buttonEle, reviewId, voteId, voteScore) {
  var request = $.ajax({
    method: 'PATCH',
    data: { score: voteScore },
    url: '/api/v1/reviews/' + reviewId + '/votes/' + voteId
  });

  request.success(function(data) {
    var parentReviewScore = $(buttonEle).closest('.review').find('.score');
    parentReviewScore.text('Score: ' + data.review.sum_score);
    $('.flash-ajax p').remove();
  });

  request.error(function(data) {
    $('.flash-ajax').html('<p>' + data.responseJSON.error + '</p>');
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

// var makeAjaxRequestPost = function(buttonEle, reviewId, voteScore) {
//   var request = $.ajax({
//     method: 'POST',
//     data: { score: voteScore },
//     url: '/api/v1/reviews/' + reviewId + '/votes'
//   });
//
//   request.success(function(data) {
//     var buttons = $(buttonEle).closest('.vote_buttons_create');
//     $(buttons).removeClass('vote_buttons_create');
//     $(buttons).addClass('vote_buttons_update');
//     var voteButtons = $(buttons).children();
//     for (var i = 0; i < voteButtons.length; i++) {
//       $(voteButtons[i]).attr('action', '/reviews/' + reviewId + '/vote/' + data['vote']['id']);
//     }
//     var parentReviewScore = $(buttonEle).closest('.review').find('.score');
//     parentReviewScore.text('Score: ' + data.data.review.sum_score);
//   });
// };
//
// var makeAjaxRequestUpdate = function(buttonEle, reviewId, voteId, voteScore) {
//   var request = $.ajax({
//     method: 'PATCH',
//     data: { score: voteScore },
//     url: '/api/v1/reviews/' + reviewId + '/votes/' + voteId
//   });
//
//   request.success(function(data) {
//     var parentReviewScore = $(buttonEle).closest('.review').find('.score');
//     parentReviewScore.text('Score: ' + data.review.sum_score);
//     $('.flash-ajax p').remove();
//   });
//
//   request.error(function(data) {
//     $('.flash-ajax').html('<p>' + data.responseJSON.error + '</p>');
//   });
// };
