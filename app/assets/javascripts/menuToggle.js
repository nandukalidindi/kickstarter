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

  })

})
