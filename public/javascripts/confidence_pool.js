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
    /* $('#save_confidence_picks').click(this.validatePicks); */
    $('.bowlrankselect').change(this.updateRankTable);
  },

  updateRankTable: function(e) {
    /* The event passed in has a srcElement of the select tag.  Its value is the
    * rank chosen by the end user.  Its parent
    * node is a TD that has an id with the name of the bowl. Grabbing that and
    * assigning it to the html in the rank list. */
   console.log(e);
   console.log('aefoiajef');
   var chosenRank = 0;
   var bowlGame = '';

   if(e.srcElement){
       chosenRank = e.srcElement.value;
       bowlGame = e.srcElement.parentNode["id"];
   }else{
       console.log(e.target.value);
       chosenRank = e.target.value;
       bowlGame = e.target.parentElement["id"];
   }


   console.log(e.target.value);
    var rankElement = $('#selected_rank_'+chosenRank).eq(0);
    //var bowlGame = e.srcElement.parentNode["id"];

    /* if the user is changing a rank, it needs to be removed from the list */
    $('[id^="selected_rank_"]').each(function(index) {
      if(bowlGame == $(this).text()){
        $(this).hide();
      }
    });

    /* set the text and show it */
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

