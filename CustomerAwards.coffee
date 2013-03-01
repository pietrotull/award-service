eligibilityService = require './EligibilityService'

prizesMap = {
	SPORTS: 'CHAMPIONS_LEAGUE_FINAL_TICKET', 
	KIDS: 'N/A', 
	MUSIC: 'KARAOKE_PRO_MICROPHONE', 
	NEWS: 'N/A',
	MOVIES: 'PIRATES_OF_THE_CARIBBEAN_COLLECTION'
	}

exports.queryAwards = queryAwards = (customerNumber, channels) ->

	try
		prizeList = buildPrizeList(customerNumber, channels)
	catch error
		console.log 'Invalid Account Number, please check again' if error == 'InvalidAccountNumberException'
		prizeList = []

	return prizeList.sort()

buildPrizeList = (customerNumber, channels) ->
	switch eligibilityService.checkEligibility(customerNumber)
		when "CUSTOMER_INELIGIBLE" then prizeList = []
		when "CUSTOMER_ELIGIBLE" then prizeList = getPrizesFor(channels)
	return prizeList

getPrizesFor = (channels) ->
	prizeList = (prizesMap[ch] for ch in channels)
	prizeList.remove 'N/A' while tooManyNAelements(prizeList)
	return prizeList

tooManyNAelements = (list) ->
	return list.contains('N/A') and list.length > 1

Array::remove = (e) -> 
	@[t..t] = [] if (t = @indexOf(e)) > -1
Array::contains = (e) ->
	return (t = @indexOf(e)) > -1
