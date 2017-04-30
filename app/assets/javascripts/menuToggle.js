$(document).ready(function(){
  $("#js-user_nav_select").unbind('click').bind('click', function(event) {
    var togglableDiv = $("#user-menu-options");    

    if(togglableDiv.hasClass("selected")) {
      togglableDiv.removeClass("selected");
    } else {
      togglableDiv.addClass("selected");
    }
  });
})
