@MobileReadyApiCache = new Mongo.Collection('mobile_ready_api_cache')

MobileReadyApiCache.attachSchema new SimpleSchema(
	createdAt:
		type: Date
		autoValue: ->
			if this.isInsert
				return new Date()
	url:
		type: String
		index: 1
	response:
		type: Object
		blackbox: true
)
