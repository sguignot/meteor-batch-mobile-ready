Template.queries.helpers
	settings: ->
		{
			collection: Queries
			rowsPerPage: 100
			showFilter: true
			useFontAwesome: true
			showNavigation: 'auto'
			fields: [
				{ key: 'displayCreatedAt', label: 'When' }
				{ key: 'url', label: 'URL', tmpl: Template.query_item_url }
				{ key: 'pass', label: 'Pass', tmpl: Template.query_item_pass }
				{ key: 'score', label: 'Score', tmpl: Template.query_item_score, sort: 'ascending' }
			]
		}


Template.query_item_score.helpers
	brokenRules: ->
		rules = _.compact _.map(@response.formattedResults.ruleResults, (res) ->
			"<span style='color:red'>✘</span> #{res.localizedRuleName} (#{res.ruleImpact.toFixed(2)})" if res.ruleImpact > 0
		)
		rules.join('<br>')
