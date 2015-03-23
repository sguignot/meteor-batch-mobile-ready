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
				]
			else
				return []
		data:
			queriesQueue: ->
				QueriesQueue.find({}, {sort: {created: -1}}).fetch()
				
	@route 'report'

	@route 'export.csv', (->
		exportCSV @request.query.q, @response
	), where: 'server'


Router.waitOn ->
	Meteor.subscribe 'user'
