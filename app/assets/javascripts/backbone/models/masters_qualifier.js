POG.Models.MastersQualifier = Backbone.Model.extend({

});

POG.Collections.MastersQualifiers = Backbone.Collection.extend({
    model: POG.Models.MastersQualifier,
    url: '/masters_qualifiers'
});
