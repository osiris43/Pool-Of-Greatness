ConfidencePoolLab = {
    Start: function(bowls){
        var viewModel = ConfidencePoolLab.ViewModel(bowls);
        console.log('started');
    }
};

ConfidencePoolLab.ViewModel = function(bowls){
    var self = this;
    var model = ko.mapping.toJS(bowls);
    console.log('view model created');
};
