
ImportErrorApp = {
  start: function(){
    var view = new ImportErrorApp.MainView();
  }
}

ImportErrorApp.MainView = Backbone.View.extend({
  el: "body",

  events: {
      "click #import-player-link" : "showImport"
  },


  initialize: function(){
    _.bindAll(this, 'render');
    this.render();
  },

  render: function(){
    console.log("in the render function");
    return this;
  },


  showImport: function(){
    console.log("showImport");
  }
})




