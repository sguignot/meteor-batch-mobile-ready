Meteor.startup ->

	worker = (job, cb) ->
		query = Queries.findOne(_id: job.data.queryId)
		url = query.url
		cache = MobileReadyApiCache.findOne(url: url)

		if cache?
			response = cache.response
			console.log "Found api cache for #{url}"
		else
			try
				result = HTTP.call('GET', 'https://www.googleapis.com/pagespeedonline/v3beta1/mobileReady',
					params:
						key: GOOGLE_MOBILE_READY_API_KEY
						url: url
						screenshot: true
						snapshots: true
						locale: 'en_US'
						strategy: 'mobile'
						filter_third_party_resources: false
						callback: '__removeCallback'
				)
				result.data = JSON.parse(result.content.replace("// API callback\n__removeCallback(", '').replace(/\);$/, ''))
				response = CollectionUtils.fixKeysForMongo(result.data)
				throw "missing ruleGroups.USABILITY:\n#{result.content}" unless response.ruleGroups? and response.ruleGroups.USABILITY?
				console.log "Query ok for #{url}"
			catch e
				job.fail "Error from googleapis for #{url}: #{e}"
				return cb()

			MobileReadyApiCache.insert(url: url, response: response)
			console.log "Inserted api cache for #{url}"

		pass = response.ruleGroups.USABILITY.pass
		score = response.ruleGroups.USABILITY.score

		Queries.update({ _id: query._id }, $set:
			response: response
			pass: pass
			score: score
		)
		QueriesQueue.update({ _id: job._doc._id }, $set: 
			'data.pass': pass
			'data.score': score
		)
		console.log "Updated query #{query._id} with response: #{url} pass=#{pass} score=#{score}"

		job.done()
		cb()

	workers = QueriesQueue.processJobs 'mobileReadyJob', { concurrency: 10, prefetch: 2, pollInterval: 2500 }, worker
