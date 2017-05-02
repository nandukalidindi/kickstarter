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
})


