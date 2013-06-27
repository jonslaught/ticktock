// random helper functions

_.extend(Meteor.Collection.prototype, {
	getOrCreate: function(selector) {
		// Find the element matching selector
		// If nothing is found, create that and return it
		var self = this;
		var match = self.findOne(selector);
		if (match) {
			return match._id
		} else {
			return this.insert(selector)
		}
	}




})

if(Meteor.isClient) {
	
	templateHelpers = {
		toPercent: function(num) {
			return (num * 100).toFixed(1) + '%'
		},
		toGain: function(num) {
			return (num > 0 ? '+' : '') + num.toFixed(2)
		},
		toDollars: function(num) {
			return '$' + num.toFixed(2)
		}

	}

	_.each(templateHelpers, function(helper,name) {
		Handlebars.registerHelper(name,helper)
	})


}