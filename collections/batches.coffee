@Batches = new Mongo.Collection('batches')

Batches.attachSchema new SimpleSchema(
	createdAt:
		type: Date
		autoValue: ->
			if this.isInsert
				return new Date()
	updatedAt:
		type: Date
		autoValue: ->
			return new Date()
	urls:
		type: String
		label: 'URLs'
		autoform:
			rows: 5
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

if Meteor.isServer
	Batches.after.insert (userId, doc) ->
		for url in doc.urls.split(/\n+/)
			continue unless url.match /^https{0,1}:\/\//
			Queries.insert(url: url)
