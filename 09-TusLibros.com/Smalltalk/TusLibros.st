!classDefinition: #TusLibrosTest category: #TusLibros!
TestCase subclass: #TusLibrosTest
	instanceVariableNames: 'blockOnDebit currentTestTime'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'asdf 11/2/2017 17:59:35'!
debit: anAmount from: aCard
	^ blockOnDebit value: anAmount value: aCard.! !

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'asdf 11/2/2017 18:13:48'!
test02CartWithOneCopyOfABookHasATotalWithItsPrice
	| aCart aBook aCatalogue |
	aBook := '1111'.
	aCatalogue _ self aCatalogueWith: aBook.
	aCart := Cart withCatalogue: aCatalogue.
	aCart add: 1 copiesOf: aBook.
	
	self assert: 1 equals: (aCart copiesOf: aBook).
	self assert: 10 equals: aCart totalPrice! !

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'asdf 11/2/2017 18:15:37'!
test03CartCantAddBookNotBelongingToItsCatalogue
	| aCartWithEmptyCatalogue aBook |
	aCartWithEmptyCatalogue _ Cart withCatalogue: self anEmptyCatalogue.
	aBook _ '1111'.
	self
		should: [
			aCartWithEmptyCatalogue add: aBook. ]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: anError messageText = aCartWithEmptyCatalogue itemDoesNotBelongToCatalogueMessage.
			self assert: aCartWithEmptyCatalogue isEmpty ].! !

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'BAB 11/6/2017 17:37:10'!
test03CartCantAddNonIntegerQuantityOfABook
	| aCart aBook |
	aBook _ '1111'.
	aCart _ Cart withCatalogue: (self aCatalogueWith: aBook).
	self
		should: [
			aCart add: 1.5 copiesOf: aBook ]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: Cart cannotAddNonIntegerQuantityOfAnItemErrorMessage equals: anError messageText.
			self assert: aCart isEmpty ].! !

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'BAB 11/6/2017 17:37:24'!
test03CartCantAddNonPositiveQuantityOfABook
	| aCart aBook |
	aBook _ '1111'.
	aCart _ Cart withCatalogue: (self aCatalogueWith: aBook).
	self
		should: [
			aCart
				add: -1
				copiesOf: aBook ]
		raise: Error
		withExceptionDo: [ :anError |
			self
				assert: Cart cannotAddNonPositiveQuantityOfAnItemErrorMessage
				equals: anError messageText.
			self assert: aCart isEmpty ].! !

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'BAB 11/6/2017 17:37:40'!
test04CheckOutOfEmptyCartFails
	| anEmptyCart aCard aSalesBookChapter |
	anEmptyCart _ Cart withCatalogue: Set new.
	aCard _ '234534'.
	aSalesBookChapter _ OrderedCollection new.
		
	self
		should: [
			Cashier
				charge: aCard
				withCart: anEmptyCart
				onDate: self todayDate
				withPaymentProcessor: self
				withSalesBookChapter: aSalesBookChapter.]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = Cashier cannotChargeEmptyCartErrorMessage.
			self assert: aSalesBookChapter isEmpty ].! !

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'BAB 11/6/2017 17:26:25'!
test05CheckOutWithOneBook
	| aBook aCart aSalesBookChapter |
	aBook _ '1111'.
	aCart _ Cart withCatalogue: (self aCatalogueWith: aBook).
	aCart add: aBook.
	aSalesBookChapter _ OrderedCollection new.
	Cashier
		charge: self validCard
		withCart: aCart
		onDate: self todayDate
		withPaymentProcessor: self
		withSalesBookChapter: aSalesBookChapter.
	self deny: aSalesBookChapter isEmpty.! !

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'ip 11/6/2017 03:31:52'!
test06ChargeWithExpiredCardFails
	| aCart aCard aCardExpirationDate aSalesBook aBook |
	blockOnDebit _ [ self fail ].
	aBook _ 'a book'.
	aCart _ Cart withCatalogue: (self aCatalogueWith: aBook).
	aCart add: aBook.
	aSalesBook _ OrderedCollection new.
	aCardExpirationDate _ GregorianMonthOfYear
		yearNumber: 2012
		monthNumber: 10.
	aCard _ Card
		withNumber: '01210'
		withExpirationDate: aCardExpirationDate
		withOwner: 'John Smith'.

	self
		should: [
			Cashier
				charge: aCard
				withCart: aCart
				onDate: self todayDate
				withPaymentProcessor: self
				withSalesBookChapter: aSalesBook. ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self
				assert: Cashier chargeWithExpiredCardErrorMessage
				equals: anError messageText.
			self assert: aSalesBook isEmpty ].! !

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'ip 11/6/2017 03:34:16'!
test07ChargeWithStolenCardFails
	| aCart aCard aSalesBook aBook creditCardIsStolenErrorMessage |
	aBook _ 'a book'.
	aCart _ Cart withCatalogue: (self aCatalogueWith: aBook).
	aCart add: aBook.
	aSalesBook _ OrderedCollection new.
	aCard _ self validCard.

	creditCardIsStolenErrorMessage _ 'Merchant Processor: credit card is stolen'.
	blockOnDebit _ [ :anAmount :aCardToDebitFrom |
	aCard = aCardToDebitFrom ifTrue: [ Error signal: creditCardIsStolenErrorMessage ]].
	self
		should: [
			Cashier
				charge: aCard
				withCart: aCart
				onDate: self todayDate
				withPaymentProcessor: self
				withSalesBookChapter: aSalesBook.]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self
				assert: creditCardIsStolenErrorMessage
				equals: anError messageText.
			self assert: aSalesBook isEmpty ].! !

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'ip 11/6/2017 03:34:47'!
test08ChargeWithNoCreditCardFails
	| aCart aCard aSalesBook aBook creditCardIsInRedErrorMessage |
	aBook _ 'a book'.
	aCart _ Cart withCatalogue: (self aCatalogueWith: aBook).
	aCart add: aBook.
	aSalesBook _ OrderedCollection new.
	aCard _ self validCard.

	creditCardIsInRedErrorMessage _ 'Merchant Processor: credit card is in red'.
	blockOnDebit _ [ :anAmount :aCardToDebitFrom |
	aCard = aCardToDebitFrom ifTrue: [ Error signal: creditCardIsInRedErrorMessage ]].
	self
		should: [
			Cashier
				charge: aCard
				withCart: aCart
				onDate: self todayDate
				withPaymentProcessor: self
				withSalesBookChapter: aSalesBook.]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self
				assert: creditCardIsInRedErrorMessage
				equals: anError messageText.
			self assert: aSalesBook isEmpty ].! !

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'BAB 11/6/2017 17:27:01'!
test09ChargeWithValidCreditCardSucceeds
	| aCart aCard aSalesBook aBook aTransactionId |
	aBook _ 'a book'.
	aCart _ Cart withCatalogue: (self aCatalogueWith: aBook).
	aCart add: aBook.
	aSalesBook _ OrderedCollection new.
	aCard _ self validCard.

	aTransactionId _ '1234'.
	blockOnDebit _ [ :anAmount :aCardToDebitFrom |
	aCard = aCardToDebitFrom ifTrue: [ aTransactionId ]].
	self
		assert: aTransactionId
		equals:
			(Cashier
				charge: aCard
				withCart: aCart
				onDate: self todayDate
				withPaymentProcessor: self
				withSalesBookChapter: aSalesBook) transactionId.
	self deny: aSalesBook isEmpty.! !

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'ip 11/4/2017 19:07:32'!
test10FailToCreateCartWithInvalidClient
	| aCartInterface anInvalidClientPassword anInvalidClient |
	aCartInterface _ self aCartInterfaceWithRegisteredClient: 'asdf' andPassword: 'admin1234'.
	anInvalidClient _ 'pepito'.
	anInvalidClientPassword _ '1234'.
	
	self should: [ aCartInterface createCartForClient: anInvalidClient withPassword: anInvalidClientPassword ]
		raise: Error -MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: aCartInterface invalidClientErrorMessage equals: anError messageText
		]! !

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'ip 11/4/2017 19:09:10'!
test11FailToCreateCartWithIncorrectAuthentication
	| aCartInterface anIncorrectClientPassword aClient |
	aClient _ 'pepito'.
	aCartInterface _ self aCartInterfaceWithRegisteredClient: aClient andPassword: 'fome'.
	anIncorrectClientPassword _ 'nomeacuerdocomoera'.
	
	self should: [ aCartInterface createCartForClient: aClient withPassword: anIncorrectClientPassword ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: aCartInterface incorrectAuthenticationErrorMessage equals: anError messageText
		]! !

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'ip 11/4/2017 19:10:02'!
test12CreatedCartWithCorrectlyAuthenticatedClientShouldBeEmpty
	| aCartInterface aClientPassword aClient aCreatedCartId |
	aClient _ 'pepito'.
	aClientPassword _ 'ahorasi'.
	aCartInterface _ self aCartInterfaceWithRegisteredClient: aClient andPassword: aClientPassword.

	aCreatedCartId _ aCartInterface createCartForClient: aClient withPassword: aClientPassword.
	self assert: (aCartInterface listCart: aCreatedCartId) isEmpty.
		! !

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'ip 11/6/2017 03:38:43'!
test13BookAddedToCartShouldAppearListed
	| aCartInterface aClientPassword aClient aCreatedCartId anItemsSummary |
	aClient _ 'pepito'.
	aClientPassword _ 'ahorasi'.
	aCartInterface _ self aCartInterfaceWithRegisteredClient: aClient andPassword: aClientPassword.

	aCreatedCartId _ aCartInterface createCartForClient: aClient withPassword: aClientPassword.
	aCartInterface add: 2 copiesOf: 'aBook' toCartWithId: aCreatedCartId.
	
	anItemsSummary _ aCartInterface listCart: aCreatedCartId.
	self assert: 1 equals: anItemsSummary size.
	self assert: 2 equals: (anItemsSummary quantityOf: 'aBook')! !

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'ip 11/4/2017 19:10:51'!
test14TwoDifferentCartsShouldHaveTheirOwnListing
	| aCartInterface aClient aClientPassword aNonEmptyCartId anEmptyCartId |
	
	aClient _ 'pepito'.
	aClientPassword _ 'ahorasi'.
	aCartInterface _ self aCartInterfaceWithRegisteredClient: aClient andPassword: aClientPassword.
	
	aNonEmptyCartId _ aCartInterface createCartForClient: aClient withPassword: aClientPassword.
	aCartInterface add: 2 copiesOf: 'aBook' toCartWithId: aNonEmptyCartId.
	
	anEmptyCartId _ aCartInterface createCartForClient: aClient withPassword: aClientPassword.

	self assert: (aCartInterface listCart: aNonEmptyCartId) isEmpty not.
	self assert: (aCartInterface listCart: anEmptyCartId) isEmpty.

	! !

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'ip 11/4/2017 19:11:03'!
test15FailToListPurchasesWithInvalidClient
	| aCartInterface anInvalidClientPassword anInvalidClient |
	aCartInterface _ self aCartInterfaceWithRegisteredClient: 'asdf' andPassword: 'admin1234'.
	anInvalidClient _ 'pepito'.
	anInvalidClientPassword _ '1234'.
	
	self should: [ aCartInterface listPurchasesForClient: anInvalidClient withPassword: anInvalidClientPassword ]
		raise: Error -MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: aCartInterface invalidClientErrorMessage equals: anError messageText
		]! !

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'ip 11/4/2017 19:11:37'!
test16FailToListPurchasesWithIncorrectAuthentication
	| aCartInterface anIncorrectClientPassword aClient |
	aClient _ 'pepito'.
	aCartInterface _ self aCartInterfaceWithRegisteredClient: aClient andPassword: 'fome'.

	anIncorrectClientPassword _ 'nomeacuerdocomoera'.
	self
		should: [
			aCartInterface
				listPurchasesForClient: aClient
				withPassword: anIncorrectClientPassword ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self
				assert: aCartInterface incorrectAuthenticationErrorMessage
				equals: anError messageText ].! !

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'ip 11/4/2017 19:18:48'!
test17ListPurchasesBeforeCheckoutShouldBeEmpty
	| aCartInterface aClientPassword aClient aPurchasesList |
	aClient _ 'pepito'.
	aClientPassword _ 'ahorasi'.
	aCartInterface _ self aCartInterfaceWithRegisteredClient: aClient andPassword: aClientPassword.

	aPurchasesList _ aCartInterface listPurchasesForClient: aClient withPassword: aClientPassword.
	self assert: aPurchasesList isEmpty.
		! !

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'ivan 11/4/2017 20:25:28'!
test18ListPurchasesAfterCheckoutOfACartListsItsContents
	| aCartInterface aClientPassword aClient aPurchasesList aCreatedCartId |
	aClient _ 'pepito'.
	aClientPassword _ 'ahorasi'.
	aCartInterface _ self
		aCartInterfaceWithRegisteredClient: aClient
		andPassword: aClientPassword.
	aCreatedCartId _ aCartInterface
		createCartForClient: aClient
		withPassword: aClientPassword.
	aCartInterface
		add: 1
		copiesOf: 'aBook'
		toCartWithId: aCreatedCartId.
	aCartInterface
		checkoutCartWithId: aCreatedCartId
		usingCardNumber: '22222222'
		withExpirationDate:
			(GregorianMonthOfYear
				yearNumber: 2022
				monthNumber: 2)
		withCardOwnerName: 'pepe'
		onDate: self todayDate.
	aPurchasesList _ aCartInterface
		listPurchasesForClient: aClient
		withPassword: aClientPassword.
	self deny: aPurchasesList isEmpty.
	self
		assert: 1
		equals: (aPurchasesList quantityOf: 'aBook').! !

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'ip 11/6/2017 00:57:17'!
test19ListCartShouldFailAfterSessionTimePassed
	| aCartInterface aClientPassword aClient aCreatedCartId |
	aClient _ 'pepito'.
	aClientPassword _ 'ahorasi'.
	aCartInterface _ self
		aCartInterfaceWithRegisteredClient: aClient
		andPassword: aClientPassword.
	aCreatedCartId _ aCartInterface
		createCartForClient: aClient
		withPassword: aClientPassword.
	self advanceTime: RESTInterface cartSessionExpirationTime.
	self
		should: [ aCartInterface listCart: aCreatedCartId ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: Session expiratedSessionErrorMessage = anError messageText ].! !

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'ip 11/6/2017 00:57:17'!
test20AddToCartShouldFailAfterSessionTimePassed
	| aCartInterface aClientPassword aClient aCreatedCartId |
	aClient _ 'pepito'.
	aClientPassword _ 'ahorasi'.
	aCartInterface _ self
		aCartInterfaceWithRegisteredClient: aClient
		andPassword: aClientPassword.
	aCreatedCartId _ aCartInterface
		createCartForClient: aClient
		withPassword: aClientPassword.
	self advanceTime: RESTInterface cartSessionExpirationTime.
	self
		should: [
			aCartInterface
				add: 2
				copiesOf: 'aBook'
				toCartWithId: aCreatedCartId ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: Session expiratedSessionErrorMessage = anError messageText ].! !

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'ip 11/6/2017 00:57:17'!
test21CheckoutCartShouldFailAfterSessionTimePassed
	| aCartInterface aClientPassword aClient aCreatedCartId |
	aClient _ 'pepito'.
	aClientPassword _ 'ahorasi'.
	aCartInterface _ self
		aCartInterfaceWithRegisteredClient: aClient
		andPassword: aClientPassword.
	aCreatedCartId _ aCartInterface
		createCartForClient: aClient
		withPassword: aClientPassword.
	self advanceTime: RESTInterface cartSessionExpirationTime.
	self
		should: [
			aCartInterface
				add: 2
				copiesOf: 'aBook'
				toCartWithId: aCreatedCartId ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: Session expiratedSessionErrorMessage = anError messageText ].! !

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'ip 11/6/2017 03:39:59'!
test22BookAddedToCartAfterTimePassedShouldAppearListed
	| aCartInterface aClientPassword aClient aCreatedCartId anItemsSummary |
	aClient _ 'pepito'.
	aClientPassword _ 'ahorasi'.
	aCartInterface _ self
		aCartInterfaceWithRegisteredClient: aClient
		andPassword: aClientPassword.
	aCreatedCartId _ aCartInterface
		createCartForClient: aClient
		withPassword: aClientPassword.
	self advanceTime: RESTInterface cartSessionExpirationTime / 2.
	aCartInterface
		add: 2
		copiesOf: 'aBook'
		toCartWithId: aCreatedCartId.
	anItemsSummary _ aCartInterface listCart: aCreatedCartId.
	self
		assert: 1
		equals: anItemsSummary size.
	self
		assert: 2
		equals: (anItemsSummary quantityOf: 'aBook').! !

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'ip 11/6/2017 03:40:10'!
test23TotalUseOfCartShouldBeAbleToExceedExpirationTime
	| aCartInterface aClientPassword aClient aCreatedCartId anItemsSummary |
	aClient _ 'pepito'.
	aClientPassword _ 'ahorasi'.
	aCartInterface _ self
		aCartInterfaceWithRegisteredClient: aClient
		andPassword: aClientPassword.
	aCreatedCartId _ aCartInterface
		createCartForClient: aClient
		withPassword: aClientPassword.
	self advanceTime: RESTInterface cartSessionExpirationTime / 2.
	aCartInterface
		add: 2
		copiesOf: 'aBook'
		toCartWithId: aCreatedCartId.
	self advanceTime: RESTInterface cartSessionExpirationTime / 2.
	aCartInterface
		add: 2
		copiesOf: 'aBook'
		toCartWithId: aCreatedCartId.
	self advanceTime: RESTInterface cartSessionExpirationTime / 2.
	anItemsSummary _ aCartInterface listCart: aCreatedCartId.
	self
		assert: 1
		equals: anItemsSummary size.
	self
		assert: 4
		equals: (anItemsSummary quantityOf: 'aBook').! !

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'BAB 11/5/2017 19:38:53'!
test24TwoDifferentClientsShouldHaveTheirOwnPurchases
	| aCartInterface aFirstCartId firstClient firstClientPurchasesList firstPassword secondClient secondPassword secondClientPurchasesList |
	firstClient _ 'pepito'.
	firstPassword _ 'ahorasi'.
	secondClient _ 'pepita'.
	secondPassword _ 	'ahorasi2'.
	aCartInterface _ self aCartInterfaceWithClientsReposity: (Dictionary newFromPairs: {firstClient.firstPassword . secondClient. secondPassword} ).
	aFirstCartId _ aCartInterface
		createCartForClient: firstClient
		withPassword: firstPassword.
	aCartInterface
		add: 1
		copiesOf: 'aBook'
		toCartWithId: aFirstCartId.
	aCartInterface
		checkoutCartWithId: aFirstCartId
		usingCardNumber: '22222222'
		withExpirationDate:
			(GregorianMonthOfYear
				yearNumber: 2022
				monthNumber: 2)
		withCardOwnerName: 'pepe'
		onDate: self todayDate.
	firstClientPurchasesList _ aCartInterface
		listPurchasesForClient: firstClient
		withPassword: firstPassword.
	secondClientPurchasesList _ aCartInterface
		listPurchasesForClient: secondClient
		withPassword: secondPassword.
	self deny: firstClientPurchasesList isEmpty.
	self
		assert: 1
		equals: (firstClientPurchasesList quantityOf: 'aBook').
	self assert: secondClientPurchasesList isEmpty.
	! !

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'BAB 11/6/2017 17:48:18'!
test25DoubleCheckoutCartShouldFail
	| aCartInterface aClientPassword aClient aCreatedCartId |
	aClient _ 'pepito'.
	aClientPassword _ 'ahorasi'.
	aCartInterface _ self
		aCartInterfaceWithRegisteredClient: aClient
		andPassword: aClientPassword.
	aCreatedCartId _ aCartInterface
		createCartForClient: aClient
		withPassword: aClientPassword.
	
	
	aCartInterface
		add: 2
		copiesOf: 'aBook'
		toCartWithId: aCreatedCartId.
	
	aCartInterface
		checkoutCartWithId: aCreatedCartId
		usingCardNumber: '22222222'
		withExpirationDate:
			(GregorianMonthOfYear
				yearNumber: 2022
				monthNumber: 2)
		withCardOwnerName: 'pepe'
		onDate: self todayDate.
	
	blockOnDebit _ [:aCard :anAmount | self fail ].
	
	self
		should: [ 
			aCartInterface
		checkoutCartWithId: aCreatedCartId
		usingCardNumber: '22222222'
		withExpirationDate:
			(GregorianMonthOfYear
				yearNumber: 2022
				monthNumber: 2)
		withCardOwnerName: 'pepe'
		onDate: self todayDate. ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: RESTInterface cartDoesNotExistErrorMessage  equals: anError messageText].! !

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'asdf 10/30/2017 21:24:33'!
todayDate
	^  (FixedGregorianDate yearNumber: 2017 monthNumber: 2 dayNumber: 12).! !


!TusLibrosTest methodsFor: 'accessing' stamp: 'ip 11/6/2017 01:01:24'!
aCartInterfaceWithClientsReposity: aClientsRepository
	^ RESTInterface
		withRegisteredClients: aClientsRepository
		withCatalogue: (Dictionary newFromPairs: {'aBook'. 100})
		withPaymentProcessor: self
		withClock: self
		withSalesBook: Dictionary new.! !

!TusLibrosTest methodsFor: 'accessing' stamp: 'ip 11/6/2017 00:59:15'!
aCartInterfaceWithRegisteredClient: aClient andPassword: aPassword
	^ RESTInterface
		withRegisteredClients:
			(self
				aClientsRepositoryWithUser: aClient
				andPassword: aPassword)
		withCatalogue: (Dictionary newFromPairs: {'aBook'. 100})
		withPaymentProcessor: self
		withClock: self
		withSalesBook: Dictionary new.! !

!TusLibrosTest methodsFor: 'accessing' stamp: 'ip 11/2/2017 13:41:19'!
aCatalogueWith: aString 
	^ Dictionary newFromPairs: { aString . 10 }! !

!TusLibrosTest methodsFor: 'accessing' stamp: 'asdf 11/2/2017 20:12:20'!
aClientsRepositoryWithUser: aClient andPassword: aPassword 
	^ Dictionary newFromPairs: { aClient. aPassword }.! !

!TusLibrosTest methodsFor: 'accessing' stamp: 'asdf 11/2/2017 18:15:19'!
anEmptyCatalogue
	^ Dictionary new! !

!TusLibrosTest methodsFor: 'accessing' stamp: 'BAB 11/5/2017 18:53:51'!
setUp
	blockOnDebit _ [ :anAmount :aCardToDebitFrom | 0 ].
	currentTestTime _ GregorianDateTime theBeginningOfTime .! !

!TusLibrosTest methodsFor: 'accessing' stamp: 'asdf 10/30/2017 21:35:06'!
validCard
	^ Card
		withNumber: '01210'
		withExpirationDate: (GregorianMonthOfYear yearNumber: 2022 monthNumber: 1)
		withOwner: 'John Smith'.! !


!TusLibrosTest methodsFor: 'evaluating' stamp: 'BAB 11/5/2017 18:58:38'!
advanceTime: aDuration
	currentTestTime _ currentTestTime next: aDuration .! !

!TusLibrosTest methodsFor: 'evaluating' stamp: 'BAB 11/5/2017 17:38:09'!
now
	^ currentTestTime.! !


!classDefinition: #Card category: #TusLibros!
Object subclass: #Card
	instanceVariableNames: 'creditCardNumber owner expirationDate'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Card methodsFor: 'as yet unclassified' stamp: 'BAB 10/30/2017 17:01:30'!
expirationDate
	^ expirationDate.! !

!Card methodsFor: 'as yet unclassified' stamp: 'BAB 10/30/2017 16:59:54'!
initializeWithNumber: aCreditCardNumber withExpirationDate: anExpirationDate withOwner: anOwner 
	creditCardNumber := aCreditCardNumber.
	owner := anOwner.
	expirationDate := anExpirationDate.
	! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Card class' category: #TusLibros!
Card class
	instanceVariableNames: ''!

!Card class methodsFor: 'as yet unclassified' stamp: 'BAB 10/28/2017 19:16:30'!
withNumber: aCreditCardNumber withExpirationDate: anExpirationDate withOwner: anOwner 
	^ self new initializeWithNumber: aCreditCardNumber withExpirationDate: anExpirationDate withOwner: anOwner .! !


!classDefinition: #Cart category: #TusLibros!
Object subclass: #Cart
	instanceVariableNames: 'itemsSummary catalogue totalPrice quantities'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cart methodsFor: 'as yet unclassified' stamp: 'BAB 11/6/2017 17:02:24'!
add: anItem
	| originalQuantities |
	(catalogue includesKey: anItem) ifFalse: [ Error signal: self itemDoesNotBelongToCatalogueMessage ].
	totalPrice _ totalPrice + (catalogue at: anItem).
	originalQuantities _ quantities at: anItem ifAbsent: 0.
	quantities at: anItem put: (originalQuantities + 1).! !

!Cart methodsFor: 'as yet unclassified' stamp: 'BAB 11/6/2017 17:31:58'!
add: aQuantityToAdd copiesOf: anItem
	aQuantityToAdd < 1 ifTrue: [ Error signal: self class cannotAddNonPositiveQuantityOfAnItemErrorMessage ].
	aQuantityToAdd isInteger not ifTrue: [ Error signal: self class cannotAddNonIntegerQuantityOfAnItemErrorMessage ].
	aQuantityToAdd timesRepeat: [self add: anItem].! !

!Cart methodsFor: 'as yet unclassified' stamp: 'BAB 11/6/2017 17:02:35'!
copiesOf: anItem
	^ quantities at: anItem.! !

!Cart methodsFor: 'as yet unclassified' stamp: 'BAB 11/6/2017 17:01:07'!
initializeWithCatalogue: aCatalogue
	catalogue _ aCatalogue.
	quantities _ Dictionary new.
	totalPrice _ 0.! !

!Cart methodsFor: 'as yet unclassified' stamp: 'BAB 11/6/2017 17:01:19'!
isEmpty
	^ quantities isEmpty.! !

!Cart methodsFor: 'as yet unclassified' stamp: 'BAB 10/28/2017 18:20:23'!
itemDoesNotBelongToCatalogueMessage
	^ 'Libro no esta en catalogo'.! !

!Cart methodsFor: 'as yet unclassified' stamp: 'BAB 11/6/2017 17:04:39'!
totalPrice
	^ totalPrice copy.! !


!Cart methodsFor: 'accessing' stamp: 'BAB 11/6/2017 17:36:23'!
paymentSummary
	^ PaymentSummary withQuantites: quantities withTotalPrice: totalPrice.! !

!Cart methodsFor: 'accessing' stamp: 'BAB 11/6/2017 17:03:05'!
quantities
	^ quantities copy.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cart class' category: #TusLibros!
Cart class
	instanceVariableNames: ''!

!Cart class methodsFor: 'as yet unclassified' stamp: 'BAB 11/6/2017 17:30:48'!
cannotAddNegativeQuantityOfAnItemErrorMessage
	^ 'Cannot add a non positive amount of items'.! !

!Cart class methodsFor: 'as yet unclassified' stamp: 'BAB 11/6/2017 17:31:12'!
cannotAddNonIntegerQuantityOfAnItemErrorMessage
	^ 'Cannot add non integer quantity of an item'! !

!Cart class methodsFor: 'as yet unclassified' stamp: 'BAB 11/6/2017 17:31:25'!
cannotAddNonPositiveQuantityOfAnItemErrorMessage
	^ 'Cannot add a negative amount of items'.! !

!Cart class methodsFor: 'as yet unclassified' stamp: 'BAB 10/26/2017 20:33:03'!
withCatalogue: aCatalogue
	^ self new initializeWithCatalogue: aCatalogue .! !


!classDefinition: #Cashier category: #TusLibros!
Object subclass: #Cashier
	instanceVariableNames: 'transactionId'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cashier methodsFor: 'private' stamp: 'BAB 11/6/2017 17:35:48'!
initializeCharge: aCard withCart: aCart onDate: aFixedDate WithPaymentProcessor: paymentProcessor withSalesBookChapter: salesBookChapter
	| aReceipt |
	aCart isEmpty ifTrue: [ Error signal: self class cannotChargeEmptyCartErrorMessage ].
	aFixedDate < aCard expirationDate firstDate ifFalse: [ Error signal: self class chargeWithExpiredCardErrorMessage ].
	transactionId _ paymentProcessor
		debit: aCart totalPrice
		from: aCard.
	aReceipt _ aCart paymentSummary.
	salesBookChapter add: aReceipt.! !


!Cashier methodsFor: 'accessing' stamp: 'ip 11/6/2017 03:36:14'!
transactionId
	^transactionId! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cashier class' category: #TusLibros!
Cashier class
	instanceVariableNames: ''!

!Cashier class methodsFor: 'initialization' stamp: 'ip 11/6/2017 03:25:33'!
cannotChargeEmptyCartErrorMessage
	^ 'Cannot charge empty cart'.! !

!Cashier class methodsFor: 'initialization' stamp: 'ip 11/6/2017 03:21:07'!
charge: aCard withCart: aCart onDate: aFixedDate withPaymentProcessor: aPaymentProcessor withSalesBookChapter: aSalesBookChapter
	^ self new initializeCharge: aCard withCart: aCart onDate: aFixedDate WithPaymentProcessor: aPaymentProcessor withSalesBookChapter: aSalesBookChapter.
		! !

!Cashier class methodsFor: 'initialization' stamp: 'ip 11/6/2017 03:32:35'!
chargeWithExpiredCardErrorMessage
	^ 'Credit Card is expired'.! !


!classDefinition: #PaymentSummary category: #TusLibros!
Object subclass: #PaymentSummary
	instanceVariableNames: 'catalogue items totalPrice quantities'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!PaymentSummary methodsFor: 'private' stamp: 'BAB 11/6/2017 16:23:40'!
initializeWithQuantities: someQuantities withTotalPrice: aTotalPrice
	quantities _ someQuantities.
	totalPrice _ aTotalPrice.! !


!PaymentSummary methodsFor: 'evaluating' stamp: 'BAB 11/6/2017 16:23:40'!
isEmpty
	^ quantities isEmpty.! !

!PaymentSummary methodsFor: 'evaluating' stamp: 'BAB 11/6/2017 17:16:12'!
quantitiesDo: aBlockClosure
	^ quantities keysAndValuesDo: aBlockClosure.! !

!PaymentSummary methodsFor: 'evaluating' stamp: 'BAB 11/6/2017 16:24:42'!
size
	^ quantities size.! !

!PaymentSummary methodsFor: 'evaluating' stamp: 'BAB 11/6/2017 16:24:17'!
totalPrice
	^ totalPrice! !


!PaymentSummary methodsFor: 'accessing' stamp: 'BAB 11/6/2017 16:23:49'!
quantityOf: anItem 
	^ quantities at: anItem.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PaymentSummary class' category: #TusLibros!
PaymentSummary class
	instanceVariableNames: ''!

!PaymentSummary class methodsFor: 'initialization' stamp: 'BAB 11/6/2017 17:24:46'!
assertAreValidQuantites: someQuantities 
! !

!PaymentSummary class methodsFor: 'initialization' stamp: 'BAB 11/6/2017 16:26:57'!
withQuantites: someQuantites withTotalPrice: aTotalPrice
	self assertAreValidQuantites: someQuantites.
	^ self new initializeWithQuantities: someQuantites withTotalPrice: aTotalPrice.! !

!PaymentSummary class methodsFor: 'initialization' stamp: 'BAB 11/6/2017 17:22:55'!
withReceipts: someReceipts
	| someQuantities aTotalPrice |
	someQuantities _ Dictionary new.
	aTotalPrice _ 0.
	
	someReceipts do: [:aReceipt | 
		aReceipt quantitiesDo: [:anItem :aQuantity | | originalQuantity |
			originalQuantity _ someQuantities at: anItem ifAbsent: 0.
			someQuantities at: anItem put: originalQuantity + aQuantity.]].
	
	^ self new initializeWithQuantities: someQuantities withTotalPrice: aTotalPrice.
	! !




!classDefinition: #RESTInterface category: #TusLibros!
Object subclass: #RESTInterface
	instanceVariableNames: 'catalogue registeredClients salesBook paymentProcessor clock cartSessionsRepository'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!RESTInterface methodsFor: 'evaluating' stamp: 'ip 11/6/2017 02:29:09'!
add: anAmount copiesOf: aBook toCartWithId: aCartId
	| aCartSession |
	aCartSession _ self cartSessionWithId: aCartId.
	aCartSession
		add: anAmount
		copiesOf: aBook.! !

!RESTInterface methodsFor: 'evaluating' stamp: 'ip 11/4/2017 19:12:57'!
authenticateClient: aClient withPassword: aPassword
	(registeredClients includesKey: aClient) ifFalse: [ Error signal: self invalidClientErrorMessage ].
	(registeredClients at: aClient) = aPassword ifFalse: [ Error signal: self incorrectAuthenticationErrorMessage ].! !

!RESTInterface methodsFor: 'evaluating' stamp: 'BAB 11/6/2017 17:50:36'!
checkoutCartWithId: aCartId usingCardNumber: aCardNumber withExpirationDate: anExpirationDate withCardOwnerName: aCardOwnerName onDate: aDate
	| aCard aCartSession aTransactionId |
	aCard _ Card
		withNumber: aCardNumber
		withExpirationDate: anExpirationDate
		withOwner: aCardOwnerName.
	aCartSession _ self cartSessionWithId: aCartId.

	aTransactionId _ (Cashier
		charge: aCard
		withCart: aCartSession
		onDate: aDate
		withPaymentProcessor: paymentProcessor
		withSalesBookChapter: (self salesBookChapterForClientId: aCartSession client)) transactionId.
	
	self deleteCartSessionWithId: aCartId.
	
	^ aTransactionId.! !

!RESTInterface methodsFor: 'evaluating' stamp: 'ip 11/6/2017 02:28:26'!
createCartForClient: aClient withPassword: aPassword
	| aCreatedCart aCreatedCartId aCartSession |
	self
		authenticateClient: aClient
		withPassword: aPassword.
	aCreatedCart _ Cart withCatalogue: catalogue.
	aCartSession _ Session
		of: aCreatedCart
		withClock: clock
		for: self class cartSessionExpirationTime
		belongingToClient: aClient.
	aCreatedCartId _ aCartSession hash.
	cartSessionsRepository
		at: aCreatedCartId
		put: aCartSession.
	^ aCreatedCartId.! !

!RESTInterface methodsFor: 'evaluating' stamp: 'BAB 11/6/2017 17:36:36'!
listCart: aCartId
	^ (self cartSessionWithId: aCartId) paymentSummary.! !

!RESTInterface methodsFor: 'evaluating' stamp: 'BAB 11/6/2017 17:23:21'!
listPurchasesForClient: aClient withPassword: aPassword 
	self authenticateClient: aClient withPassword: aPassword.
	^ PaymentSummary withReceipts: (self salesBookChapterForClientId: aClient).! !

!RESTInterface methodsFor: 'evaluating' stamp: 'BAB 11/6/2017 17:05:03'!
salesBookChapterForClientId: aClientId 
	^ salesBook at: aClientId ifAbsentPut: [ OrderedCollection new].! !


!RESTInterface methodsFor: 'as yet unclassified' stamp: 'BAB 11/6/2017 17:49:56'!
cartSessionWithId: aCartId
	^ cartSessionsRepository at: aCartId ifAbsent: [Error signal: self class cartDoesNotExistErrorMessage].! !

!RESTInterface methodsFor: 'as yet unclassified' stamp: 'BAB 11/6/2017 17:52:33'!
deleteCartSessionWithId: aCartId 
	cartSessionsRepository removeKey: aCartId.! !

!RESTInterface methodsFor: 'as yet unclassified' stamp: 'asdf 11/2/2017 20:02:18'!
incorrectAuthenticationErrorMessage
	^ 'Failed to authenticate'! !

!RESTInterface methodsFor: 'as yet unclassified' stamp: 'asdf 11/2/2017 19:56:30'!
invalidClientErrorMessage
	^ 'Invalid client'! !


!RESTInterface methodsFor: 'private' stamp: 'ip 11/6/2017 02:28:26'!
initializeWithRegisteredClients: someRegisteredClients withCatalogue: aCatalogue withPaymentProcessor: aPaymentProcessor withClock: aClock withSalesBook: aSalesBook
	registeredClients _ someRegisteredClients.
	catalogue _ aCatalogue.
	paymentProcessor _ aPaymentProcessor.
	clock _ aClock.
	salesBook _ aSalesBook.
	cartSessionsRepository _ Dictionary new.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'RESTInterface class' category: #TusLibros!
RESTInterface class
	instanceVariableNames: ''!

!RESTInterface class methodsFor: 'initialization' stamp: 'BAB 11/5/2017 18:57:23'!
cartSessionExpirationTime
	^ (TimeUnits minute) with: 30.! !

!RESTInterface class methodsFor: 'initialization' stamp: 'ip 11/6/2017 00:58:39'!
withRegisteredClients: someRegisteredClients withCatalogue: aCatalogue withPaymentProcessor: aPaymentProcessor withClock: aClock withSalesBook: aSalesBook
	^ self new initializeWithRegisteredClients:  someRegisteredClients withCatalogue: aCatalogue withPaymentProcessor: aPaymentProcessor withClock: aClock withSalesBook: aSalesBook.! !


!RESTInterface class methodsFor: 'as yet unclassified' stamp: 'BAB 11/6/2017 17:53:14'!
cartDoesNotExistErrorMessage
	'Cart Does Not Exist' .! !


!classDefinition: #Session category: #TusLibros!
Object subclass: #Session
	instanceVariableNames: 'expirable lastTimeUsed clock duration client'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Session methodsFor: 'as yet unclassified' stamp: 'BAB 11/5/2017 20:50:57'!
assertNotExpired
	((lastTimeUsed next: duration) <= (clock now) ) ifTrue: [Error signal: self class expiratedSessionErrorMessage ].! !

!Session methodsFor: 'as yet unclassified' stamp: 'ip 11/6/2017 02:26:27'!
client
	^ client.! !

!Session methodsFor: 'as yet unclassified' stamp: 'BAB 11/5/2017 20:50:57'!
doesNotUnderstand: aMessage 
	self assertNotExpired.
	lastTimeUsed _ clock now.
	^ aMessage sendTo: expirable.
    ! !

!Session methodsFor: 'as yet unclassified' stamp: 'ip 11/6/2017 02:26:13'!
initializeOf: anExpirable withClock: aClock for: aDuration belongingToClient: aClient
	expirable _ anExpirable.
	clock _ aClock.
	duration _ aDuration.
	lastTimeUsed _ clock now.
	client _ aClient.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Session class' category: #TusLibros!
Session class
	instanceVariableNames: ''!

!Session class methodsFor: 'as yet unclassified' stamp: 'BAB 11/5/2017 20:50:57'!
expiratedSessionErrorMessage
	^ 'Session has expired'! !

!Session class methodsFor: 'as yet unclassified' stamp: 'ip 11/6/2017 02:22:39'!
of: anExpirable withClock: aClock for: aDuration belongingToClient: aClient
	^ self new
		initializeOf: anExpirable
		withClock: aClock
		for: aDuration
		belongingToClient: aClient.! !
