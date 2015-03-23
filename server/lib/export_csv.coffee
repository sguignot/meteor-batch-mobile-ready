@exportCSV = (userId, responseStream) ->
	stream = createStream()
	fut = new Future

	CSV().from(stream).to(responseStream).transform((query, index) ->
		if query._id
			dateUpdated = new Date(query.updatedAt)
			passStr = if query.pass
				'PASS'
			else if query.pass?
				'FAIL'
			else
				''
			[query.url, passStr, query.score, dateUpdated.toString()]
		else
			query
	).on('error', (error) ->
		console.error 'Error streaming CSV export: ', error.message
		return
	).on 'end', (count) ->
		responseStream.end()
		fut.return()
		return

	stream.write ['URL', 'Pass', 'Score', 'Updated']
	queries = Queries.find({owner: userId, score: {$exists: true}}, {sort: {updatedAt: -1}})
	urls = {} # used to output only the latest score for each url
	queries.forEach (query) ->
		stream.write query unless urls[query.url]
		urls[query.url] = true
		return
	
	stream.end()
	fut.wait()


createStream = ->
	stream = Npm.require('stream')
	myStream = new (stream.Stream)
	myStream.readable = true
	myStream.writable = true

	myStream.write = (data) ->
		myStream.emit 'data', data
		true

	myStream.end = (data) ->
		myStream.write data if arguments.length
		myStream.writable = false
		myStream.emit 'end'
		return

	myStream.destroy = ->
		myStream.writable = false
		return

	myStream
