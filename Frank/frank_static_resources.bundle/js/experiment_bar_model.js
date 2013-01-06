(function() {

  define(function() {
    var ExperimentBarModel;
    return ExperimentBarModel = Backbone.Model.extend({
      defaults: {
        engines: ['shelley_compat', 'uiquery'],
        selectorEngine: 'shelley_compat',
        selector: ''
      },
      actionClicked: function(actionName) {
        return this.trigger("" + actionName + "-clicked", this);
      }
    });
  });

}).call(this);
