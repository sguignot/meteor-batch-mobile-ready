Template.registerHelper 'appName', ->
	Config.name

Template.app_layout.helpers(
	userSignedIn: ->
		Meteor.userId()?
	routeIsHome: ->
		Router.current().route.getName() == 'home'
	routeIsReport: ->
		Router.current().route.getName() == 'report'
	routeIsExportCsv: ->
		Router.current().route.getName() == 'export.csv'
	exportCSVQuery: ->
		'q='+Meteor.userId()
)
