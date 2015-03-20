@Queries = new Mongo.Collection('queries')

Queries.attachSchema new SimpleSchema(
	createdAt:
		type: Date
		autoValue: ->
			if this.isInsert
				return new Date()
	updatedAt:
		type: Date
		autoValue: ->
			return new Date()
	url:
		type: String
		label: 'URL'
		index: 1
	response:
		type: Object
		optional: true
		blackbox: true
	pass:
		type: Boolean
		optional: true
	score:
		type: Number
		optional: true
	owner:
		type: String
		index: 1
		regEx: SimpleSchema.RegEx.Id
		autoValue: ->
			if this.isInsert
				return Meteor.userId()
		autoform:
			options: ->
				_.map Meteor.users.find().fetch(), (user) ->
					label: user.emails[0].address
					value: user._id
)

Queries.helpers(
	displayCreatedAt: ->
		return moment(@createdAt).fromNow()
)

if Meteor.isServer
	Queries.after.insert (userId, doc) ->
		job = QueriesQueue.createJob('mobileReadyJob',
			owner: userId
			queryId: doc._id
		)
		job.retry
			retries: 3
			wait: 30*1000 # waiting 30 seconds between attempts
			backoff: 'constant' # wait constant amount of time between each retry
		job.save()
