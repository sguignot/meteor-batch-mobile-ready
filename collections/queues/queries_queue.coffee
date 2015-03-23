@QueriesQueue = new JobCollection 'queries_queue', idGeneration: 'MONGO'

QueriesQueue.helpers(
	displayCreated: ->
		moment(@created).fromNow()
	url: ->
		@data.url
	pass: ->
		@data.pass
	passDefined: ->
		@data.pass?
	score: ->
		@data.score
	jobRowClass: ->
		switch @status
			when 'running' then 'warning'
			when 'completed' then ''
			when 'failed' then 'danger'
)
