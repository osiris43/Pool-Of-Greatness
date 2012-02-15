CalendarApp = {
  start: function(){
    var v = new CalendarApp.ScheduleView();
  }
}

CalendarApp.Gamedate = Backbone.Model.extend({
  
});

CalendarApp.GamedateList = Backbone.Collection.extend({
  model: CalendarApp.Gamedate,

});

CalendarApp.GamedateView = Backbone.View.extend({
  tagName: "li",

  template: function(){
    return _.template($('#gamedate-template').html()); 
  }, 

  initialize: function(){
    this.model.bind("change", this.render, this);
  },

  render: function(){
    $(this.el).html(this.template(this.model.toJSON()));
    this.setValues();
    return this;
  },

  setValues: function(){
    var day = this.model.get('day');
    var num = this.model.get('num');
    var games = this.model.get('games');
    this.$('.dayname-text').text(day);
    this.$('.daynumber-text').text(num);
    this.$('a').attr('href',this.model.get('href'));
    var date_param = this.getUrlVars()['schedule_date'];
    
    if(date_param === undefined){
      var today = new Date();
      if(today.getDate() === this.model.get('num')){
        this.addCurrent();
      } 
    } else{
      /* console.log('date param matched');
      console.log(date_param);
      console.log(this.model.get('sched_date'));  */
      if(this.model.get('sched_date') === date_param){
        this.addCurrent();
      }
    } 
  },

  addCurrent: function(){
    $(this.el).addClass("current");
  },

  getUrlVars: function(){
    var vars = [], hash
    var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
    for(var i = 0; i < hashes.length; i++){
      hash = hashes[i].split('=');
      vars.push(hash[0]);
      vars[hash[0]] = hash[1];
    }

    return vars;
  }

});

CalendarApp.ScheduleView = Backbone.View.extend({
  el: "#calendar", 

  initialize: function(){
    _.bindAll(this, 'render');
    this.render();
  },

  render: function(){
    var today = new Date();
    var sunday = today.getDate() - today.getDay();
    var beginWeek = new Date(today.getFullYear(), today.getMonth(), sunday);
    var days = new Array(7);
    days[0] = "Sun";
    days[1] = "Mon";
    days[2] = "Tue";
    days[3] = "Wed";
    days[4] = "Thu";
    days[5] = "Fri";
    days[6] = "Sat";

    for(x=0;x<7;x++){
      schedule_date = beginWeek.getFullYear() + ("00" + (beginWeek.getMonth() + 1)).slice(-2) + ("00" + (beginWeek.getDate() + x)).slice(-2); 
      href = "?schedule_date=" + schedule_date
      var gameDate = new CalendarApp.Gamedate({day : days[x], num : beginWeek.getDate() + x, href : href, sched_date : schedule_date});
      var view = new CalendarApp.GamedateView({model : gameDate});
      $(this.el).find('ul').append(view.render().el); 
    }
  },

})

