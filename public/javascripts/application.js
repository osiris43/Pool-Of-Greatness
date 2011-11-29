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

App = {
  start: function() {
    new App.ConfidencePoolRouter();
  } 
}

App.ConfidencePoolRouter = Backbone.Router.extend ({
  initialize: function(){
    new App.RankingsView();
  }
})


App.RankingsView = Backbone.View.extend({
  el: "#rankings",

  initialize: function() {
    $('#save_confidence_picks').click(this.validatePicks);
    $('.bowlrankselect').change(this.updateRankTable);
  },

  updateRankTable: function(e) {
    /* The event passed in has a srcElement of the select tag.  Its value is the 
    * rank chosen by the end user.  Its parent
    * node is a TD that has an id with the name of the bowl. Grabbing that and
    * assigning it to the html in the rank list. */
    var rankElement = $('#selected_rank_'+e.srcElement.value).eq(0);
    var bowlGame = e.srcElement.parentNode["id"];

    $('[id^="selected_rank_"]').each(function(index) {
      if(bowlGame == $(this).text()){
        $(this).hide();
      }
    });

    rankElement.text(bowlGame).show();

    /* console.log(e.srcElement);
    console.log(e.srcElement.value);
    console.log($('#selected_rank_' + e.srcElement.value)[0]);
    console.log(e.srcElement.parentNode["id"]);

    $('#selected_rank_' + e.srcElement.value)[0].innerHTML = e.srcElement.parentNode["id"];

    for(var x in e.srcElement){
      console.log(x);
    }*/
  },

  validatePicks : function() {
    ranks = {};
    duplicates = [];

    $('.bowlrankselect').each(function(idx, el){
      if(ranks[$(el)]){
        duplicates.push(el);
        duplicates.push(ranks[$(el)]);
      }
      else{
        ranks[$(el)] = true;
      }
    });

    if(duplicates.length > 0){
      for(var i = 0; i < duplicates.length; i++){
        selectEl = duplicates[i];
        bowlId = $(selectEl).attr("id").split('_')[2];
        $('#bowlid_row_'+bowlId).addClass('duplicateRank');
      }
    } 

    return false;
  }
})

