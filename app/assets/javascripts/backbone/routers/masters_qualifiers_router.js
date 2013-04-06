POG.Routers.MastersQualifiersRouter = Backbone.Router.extend({
    initialize: function(options){
        this.qualifiersList = new POG.Collections.MastersQualifiers();
        this.qualifiersList.reset(options.qualifers)
    },

    routes: {
        "":"list"
    },

    list: function(){
    },
});
