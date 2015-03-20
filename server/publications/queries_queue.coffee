Meteor.publish 'queriesQueue', ->
	check this.userId, String # ensure that the user is connected
	return QueriesQueue.find('data.owner': this.userId)
