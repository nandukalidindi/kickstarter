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
  })

  $("#search-toggle-icon-close").unbind('click').bind('click', function(event) {
    var searchToggleDiv = $("#search-togglable-nav");
    var inputSearchDiv = $("#show-search-input");

    searchToggleDiv.removeClass("site-nav--search-is-visible");
    inputSearchDiv.removeClass("site-nav__item--searchbar--visible");
  })
})
