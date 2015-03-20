QueriesQueue.setLogStream process.stdout
QueriesQueue.promote 2500

Meteor.startup ->
	QueriesQueue.startJobs()
