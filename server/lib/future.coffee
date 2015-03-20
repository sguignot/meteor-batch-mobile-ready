Meteor.startup ->
	@Future = Npm.require 'fibers/future'
