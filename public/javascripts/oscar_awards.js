OscarAwards = {
    Start: function(nominees){
        var viewModel = OscarAwards.ViewModel(nominees);
        console.log('started');
    }
};


OscarAwards.ViewModel = function(nominees){
    var self = this;
    var model = ko.mapping.toJS(nominees);
    console.log('view model created');
};
