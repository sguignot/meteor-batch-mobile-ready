@QueriesQueue = new JobCollection 'queries_queue', { idGeneration: 'MONGO' }

QueriesQueue.helpers(
	displayCreated: ->
		moment(@created).fromNow()
	url: ->
		Queries.findOne(@data.queryId).url
	pass: ->
		Queries.findOne(@data.queryId).pass
	passDefined: ->
		Queries.findOne(@data.queryId).pass?
	score: ->
		Queries.findOne(@data.queryId).score
	jobRowClass: ->
		switch @status
			when 'running' then 'warning'
			when 'completed' then ''
			when 'failed' then 'danger'
)
