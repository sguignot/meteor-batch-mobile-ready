ReactiveTable.publish 'rtSuccessedQueries', (-> Queries), ->
	{ owner: @userId, score: {$exists: true} }
