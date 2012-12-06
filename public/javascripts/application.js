// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

jQuery.ajaxSetup({
  'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
})

$(document).ready(function(){
  $('#save_weekly_picks').click(function() {
    var games = $('.gamerow');
    var selectedGames = 0;
    $('form input[name^=gameid]:radio').each(
      function(intIndex) {
        if ($(this).attr("checked")) {
          selectedGames++;
        }

    })

    if(games.length != selectedGames) {
      alert("You missed a game");
      return false;
    }

    if($('form input[name=mnftotal]').val() == ''){
      alert("The Monday night total is required.");
      return false;
    }
  })
})

$(document).ready(function() {
  $('#pool_type').change(function() {
    if ($('#pool_type').val() == 'PickemPool') {
      $('#pickem_options').slideToggle('medium');
    }
  })
})

$(document).ready(function() {
  $("ul.site_menu_body li:even").addClass("alt");
  $("img.site_menu_head").click(function() {
    $('ul.site_menu_body').slideToggle('medium');
  });
});

