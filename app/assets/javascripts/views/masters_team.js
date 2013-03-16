var MastersTeamView = Backbone.View.extend({
  el: $("#masters_team"),

  initialize: function() {
    MastersQualifiers.fetch();
  }

});
