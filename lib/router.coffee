Router.configure
	layoutTemplate: 'app_layout'
	loadingTemplate: 'loading'
	notFoundTemplate: 'not_found'
	routeControllerNameConverter: 'camelCase'
	onBeforeAction: ->
		@next()

Router.map ->
	@route 'home',
		path: '/'
		waitOn: ->
			if Meteor.user()
				return [
					Meteor.subscribe 'queriesQueue'
					Meteor.subscribe 'queries'
				]
			else
				return []
		data:
			queriesQueue: ->
				QueriesQueue.find({}, {sort: {status: -1, created: -1}, limit: 100}).fetch()
				
	@route 'report',
		waitOn: ->
			if Meteor.user()
				return [
					Meteor.subscribe 'successedQueries'
				]
			else
				return []

	@route 'export.csv', (->
		exportCSV @request.query.q, @response
	), where: 'server'


Router.waitOn ->
	Meteor.subscribe 'user'
