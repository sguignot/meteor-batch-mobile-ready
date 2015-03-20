# Only allow job owners to manage or rerun jobs
QueriesQueue.allow
	manager: (userId, method, params) ->
		ids = params[0]
		unless typeof ids is 'object' and ids instanceof Array
			ids = [ ids ]
		numIds = ids.length
		numMatches = QueriesQueue.find({ _id: { $in: ids }, 'data.owner': userId }).count()
		return numMatches is numIds

	jobRerun: (userId, method, params) ->
		id = params[0]
		numMatches = QueriesQueue.find({ _id: id, 'data.owner': userId }).count()
		return numMatches is 1

	stopJobs: (userId, method, params) ->
		return userId?


Queries.allow
	insert: (userId, doc) ->
		return userId?
	fetch: ['owner']

Batches.allow
	insert: (userId, doc) ->
		return userId?
	fetch: ['owner']
