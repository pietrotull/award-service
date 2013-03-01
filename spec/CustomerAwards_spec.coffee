customerAwards = require '../CustomerAwards'
eligibilityService = require '../EligibilityService'

customerNumber = 12345

describe 'Happy cases give awards', ->
	beforeEach ->
	 	spyOn(eligibilityService, 'checkEligibility').andReturn('CUSTOMER_ELIGIBLE')
	
	it 'SPORTS, MUSIC, MOVIES should give single prizes', ->
		expect(customerAwards.queryAwards(customerNumber, ['SPORTS'])).toEqual(['CHAMPIONS_LEAGUE_FINAL_TICKET'])
		expect(customerAwards.queryAwards(customerNumber, ['MUSIC'])).toEqual(['KARAOKE_PRO_MICROPHONE'])
		expect(customerAwards.queryAwards(customerNumber, ['MOVIES'])).toEqual(['PIRATES_OF_THE_CARIBBEAN_COLLECTION'])

	it 'KIDS & NEWS should give N/A', ->
		expect(customerAwards.queryAwards(customerNumber, ['KIDS'])).toEqual(['N/A'])
		expect(customerAwards.queryAwards(customerNumber, ['NEWS'])).toEqual(['N/A'])

	it 'SPORTS & MUSIC gives 2 prizes and channel order does not matter', ->
		expect(customerAwards.queryAwards(customerNumber, ['SPORTS', 'MUSIC'])).toEqual(['CHAMPIONS_LEAGUE_FINAL_TICKET', 'KARAOKE_PRO_MICROPHONE'])
		expect(customerAwards.queryAwards(customerNumber, ['MUSIC', 'SPORTS'])).toEqual(['CHAMPIONS_LEAGUE_FINAL_TICKET', 'KARAOKE_PRO_MICROPHONE'])
	
	it 'SPORTS & KIDS gives 1 prize', ->
		expect(customerAwards.queryAwards(customerNumber, ['SPORTS', 'KIDS'])).toEqual(['CHAMPIONS_LEAGUE_FINAL_TICKET'])
	
	it 'SPORTS & KIDS & NEWS gives 1 prize', ->
		expect(customerAwards.queryAwards(customerNumber, ['SPORTS', 'NEWS', 'KIDS'])).toEqual(['CHAMPIONS_LEAGUE_FINAL_TICKET'])
	
	afterEach ->
		expect(eligibilityService.checkEligibility).toHaveBeenCalledWith(customerNumber);

describe 'Something goes wrong', ->
	it 'SPORTS gives nothing to ineligible customer', ->
		spyOn(eligibilityService, 'checkEligibility').andReturn('CUSTOMER_INELIGIBLE')
		expect(customerAwards.queryAwards(customerNumber, ['SPORTS'])).toEqual([])

	it 'SPORTS gives nothing in case of technical failure', ->
		spyOn(eligibilityService, 'checkEligibility').andThrow('TechnicalFailureException')
		expect(customerAwards.queryAwards(customerNumber, ['SPORTS'])).toEqual([])

	it 'SPORTS gives nothing in case of technical failure', ->
		spyOn(eligibilityService, 'checkEligibility').andThrow('InvalidAccountNumberException')
		expect(customerAwards.queryAwards(customerNumber, ['SPORTS'])).toEqual([])
