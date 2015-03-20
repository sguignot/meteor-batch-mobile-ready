Meteor.publish 'queries', ->
	check this.userId, String # ensure that the user is connected
	return Queries.find(owner: this.userId)

Meteor.publish 'successedQueries', ->
	check this.userId, String # ensure that the user is connected
	return Queries.find(owner: this.userId, score: {$exists: true})
