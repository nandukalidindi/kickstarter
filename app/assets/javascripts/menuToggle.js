$(document).ready(function(){
  $("#js-user_nav_select").unbind('click').bind('click', function(event) {
    var togglableDiv = $("#user-menu-options");

    if(togglableDiv.hasClass("selected")) {
      togglableDiv.removeClass("selected");
    } else {
      togglableDiv.addClass("selected");
    }
  });

  $("#search-toggle-icon").unbind('click').bind('click', function(event) {
    var searchToggleDiv = $("#search-togglable-nav");
    var inputSearchDiv = $("#show-search-input");

    searchToggleDiv.addClass("site-nav--search-is-visible");
    inputSearchDiv.addClass("site-nav__item--searchbar--visible");
  });

  $("#search-toggle-icon-close").unbind('click').bind('click', function(event) {
    var searchToggleDiv = $("#search-togglable-nav");
    var inputSearchDiv = $("#show-search-input");

    searchToggleDiv.removeClass("site-nav--search-is-visible");
    inputSearchDiv.removeClass("site-nav__item--searchbar--visible");
  });


  $("#pledge-button").unbind('click').bind('click', function(event) {
    var pledgeInput = $("#pledge-input"),
        pledgeValue = parseInt(pledgeInput.val() || "0"),
        projectId = pledgeInput.attr('project-id');

    if(pledgeValue > 0 && projectId) {
        $.ajax({

          type: "POST",
          url: '/projects/' + projectId + '/pledge',
          dataType: 'json',
          data: {pledge: pledgeValue},
          success: function (data) {
            // location.reload();
          },
          error: function (data) {
            location.reload();
          }
      });
    }
  });

  $('#term').keypress(function (e) {
    var str = $('#term').val();
    var domain = "/projects?search=" + str;
    if (e.keyCode == 13) {
        window.location.href = domain;
    }
  });

  var togglableChildren = $("#type_list_divs").children()
  if(togglableChildren) {
    for(var i=0; i<togglableChildren.length; i++) {
      togglableChildren[i].children[0].addEventListener('click', showRelevantTypeProject);
    }
  }

  function showRelevantTypeProject(event) {
    var child = document.getElementById(event.target.id + "_project");

    child.parentNode.insertBefore(child, child.parentNode.firstChild);
  }

  var ratingChildren = $("#rating-stars").children()
  if(ratingChildren) {
    for(var i=0; i<ratingChildren.length; i++) {
      ratingChildren[i].addEventListener('click', sendRatingAJAX);
    }
  }

  function sendRatingAJAX(event) {
    var rating = event.target.attributes['for'].value.split("-")[2];

    if(rating) {
        $.ajax({
          type: "POST",
          url: location.href + '/rating',
          dataType: 'json',
          data: {rating: rating},
          success: function (data) {
            // location.reload();
          },
          error: function (data) {
            location.reload();
          }
      });
    }
  }

  $("#like_unlike").unbind('click').bind('click', function(event) {
    $.ajax({
      type: "POST",
      url: location.href + '/like',
      dataType: 'json',
      data: {likeType: event.target.innerText},
      success: function (data) {
        // location.reload();
      },
      error: function (data) {
        location.reload();
      }
    });
  });

  $("#project-comment-submit").unbind('click').bind('click', function(event) {
    var comment = $("#project-comment").val();
    $.ajax({
      type: "POST",
      url: location.href + '/comment',
      dataType: 'json',
      data: {comment: comment},
      success: function (data) {
        // location.reload();
      },
      error: function (data) {
        location.reload();
      }
    });
  });

  $("#user-profile-follow-button").unbind('click').bind('click', function(event) {
    $.ajax({
      type: "POST",
      url: location.href + '/follow',
      dataType: 'json',
      success: function(data) {

      },
      error: function(data) {
        location.reload();
      }
    })
  });

  $("#user-profile-unfollow-button").unbind('click').bind('click', function(event) {
    $.ajax({
      type: "POST",
      url: location.href + '/unfollow',
      dataType: 'json',
      success: function(data) {

      },
      error: function(data) {
        location.reload();
      }
    })
  });

  $("#show-follow-button").unbind('click').bind('click', function(event) {
    $.ajax({
      type: "POST",
      url: '/users/' + event.target.attributes['user-id'].value + '/profile/about/follow',
      dataType: 'json',
      success: function(data) {

      },
      error: function(data) {
        location.reload();
      }
    })
  });

  var unfollowableElements = document.getElementsByName("unfollow-followers");

  for(var i=0; i<unfollowableElements.length; i++) {
    unfollowableElements[i].addEventListener('click', function(event) {
      $.ajax({
        type: "POST",
        url: '/users/' + event.target.attributes['user-id'].value + '/profile/about/unfollow',
        dataType: 'json',
        success: function(data) {
        },
        error: function(data) {
          location.reload();
        }
      });
    });
  }

  var existingCreditCards = document.getElementsByName("existing-cc-cards");

  for(var i=0; i<existingCreditCards.length; i++) {
    existingCreditCards[i].addEventListener('click', function(event) {
      $.ajax({
        type: "DELETE",
        url: '/credit_cards/' + event.target.attributes['card-id'].value,
        dataType: 'json',
        success: function(data) {
        },
        error: function(data) {
          location.reload();
        }
      });
    });
  }



  $("#credit_card_create").unbind('click').bind('click', function(event) {
    var is_default = document.getElementById('rounded').checked,
        number = document.getElementById('cc-card-number').value;

    $.ajax({
      type: "POST",
      url: '/credit_cards',
      dataType: 'json',
      data: {is_default: is_default, number: number},
      success: function(data) {
      },
      error: function(data) {
        location.reload();
      }
    });
  });


  $("#video_pitch").unbind('click').bind('click', function(event) {
    var playVideo = document.getElementById('play-video');

    event.target.style['display'] = 'none';
    playVideo.style['display'] = 'block';
    playVideo.play();
  });
})
