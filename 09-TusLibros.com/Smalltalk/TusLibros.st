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

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'asdf 10/30/2017 21:31:58'!
test04CheckOutOfEmptyCartFails
	| anEmptyCart aCashier aCard aBookOfSales |
	anEmptyCart _ Cart withCatalogue: Set new.
	aCard _ '234534'.
	aBookOfSales _ OrderedCollection new.
	aCashier _ Cashier
		withPaymentProcessor: self
		withBookOfSales: aBookOfSales.
	self
		should: [
			aCashier
				charge: aCard
				withCart: anEmptyCart
				onDate: self todayDate. ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = aCashier cannotChargeEmptyCartErrorMessage.
			self assert: aBookOfSales isEmpty ].! !

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'asdf 11/2/2017 18:18:12'!
test05CheckOutWithOneBook
	|aBook aCart aCashier aBookOfSales|
	aBook := '1111'.
	aCart := Cart withCatalogue: (self aCatalogueWith: aBook). 
	aCart add: aBook.
	aBookOfSales := OrderedCollection new.
	aCashier := Cashier withPaymentProcessor: self withBookOfSales: aBookOfSales.
	aCashier charge: (self validCard) withCart: aCart onDate: self todayDate.
	self deny: aBookOfSales isEmpty.! !

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'asdf 11/2/2017 18:47:37'!
test06ChargeWithExpiredCardFails
	| aCart aCard aCardExpirationDate aCashier aSalesBook aBook |
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
	aCashier _ Cashier withPaymentProcessor: self withBookOfSales: aSalesBook.
	self
		should: [
			aCashier charge: aCard withCart: aCart onDate: self todayDate. ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: aCashier chargeWithExpiredCardErrorMessage equals: anError messageText.
			self assert: aSalesBook isEmpty ].! !

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'asdf 11/2/2017 18:21:43'!
test07ChargeWithStolenCardFails
	| aCart aCard aCashier aSalesBook aBook creditCardIsStolenErrorMessage |
	
	aBook _ 'a book'.
	aCart _ Cart withCatalogue: (self aCatalogueWith: aBook).
	aCart add: aBook.
	aSalesBook _ OrderedCollection new.
	aCard _ self validCard.
	aCashier _ Cashier withPaymentProcessor: self withBookOfSales: aSalesBook.

	creditCardIsStolenErrorMessage _  'Merchant Processor: credit card is stolen'.
	
	blockOnDebit _ [ :anAmount :aCardToDebitFrom | aCard = aCardToDebitFrom ifTrue: [Error signal: creditCardIsStolenErrorMessage ] ].

	self
		should: [
			aCashier charge: aCard withCart: aCart onDate: self todayDate.]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: creditCardIsStolenErrorMessage equals: anError messageText.
			self assert: aSalesBook isEmpty ].! !

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'asdf 11/2/2017 18:22:05'!
test08ChargeWithNoCreditCardFails
	| aCart aCard aCashier aSalesBook aBook creditCardIsInRedErrorMessage |
	
	aBook _ 'a book'.
	aCart _ Cart withCatalogue: (self aCatalogueWith: aBook).
	aCart add: aBook.
	aSalesBook _ OrderedCollection new.
	aCard _ self validCard.
	aCashier _ Cashier withPaymentProcessor: self withBookOfSales: aSalesBook.

	creditCardIsInRedErrorMessage _  'Merchant Processor: credit card is in red'.
	
	blockOnDebit _ [ :anAmount :aCardToDebitFrom | aCard = aCardToDebitFrom ifTrue: [Error signal: creditCardIsInRedErrorMessage ] ].

	self
		should: [
			aCashier charge: aCard withCart: aCart onDate: self todayDate.]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: creditCardIsInRedErrorMessage equals: anError messageText.
			self assert: aSalesBook isEmpty ].! !

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'asdf 11/2/2017 17:55:13'!
test09ChargeWithValidCreditCardSucceeds
	| aCart aCard aCashier aSalesBook aBook aTransactionId |
	
	aBook _ 'a book'.
	aCart _ Cart withCatalogue: (self aCatalogueWith: aBook).
	aCart add: aBook.
	aSalesBook _ OrderedCollection new.
	aCard _ self validCard.
	aCashier _ Cashier withPaymentProcessor: self withBookOfSales: aSalesBook.
	aTransactionId _ '1234'.
	blockOnDebit _ [ :anAmount :aCardToDebitFrom | aCard = aCardToDebitFrom ifTrue: [ aTransactionId ] ].

	self assert: aTransactionId  equals: (aCashier charge: aCard withCart: aCart onDate: self todayDate).
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

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'ip 11/4/2017 19:10:28'!
test13BookAddedToCartShouldAppearListed
	| aCartInterface aClientPassword aClient aCreatedCartId anItemsSummary |
	aClient _ 'pepito'.
	aClientPassword _ 'ahorasi'.
	aCartInterface _ self aCartInterfaceWithRegisteredClient: aClient andPassword: aClientPassword.

	aCreatedCartId _ aCartInterface createCartForClient: aClient withPassword: aClientPassword.
	aCartInterface add: 2 copiesOf: 'aBook' toCartWithId: aCreatedCartId.
	
	anItemsSummary _ aCartInterface listCart: aCreatedCartId.
	self assert: 1 equals: anItemsSummary size.
	self assert: 2 equals: (anItemsSummary at: 'aBook')
		! !

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

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'BAB 11/5/2017 20:51:47'!
test19ListCartShouldFailAfterSessionTimePassed
	| aCartInterface aClientPassword aClient aCreatedCartId |
	aClient _ 'pepito'.
	aClientPassword _ 'ahorasi'.
	aCartInterface _ self aCartInterfaceWithRegisteredClient: aClient andPassword: aClientPassword.

	aCreatedCartId _ aCartInterface createCartForClient: aClient withPassword: aClientPassword.
	
	self advanceTime: CartInterface cartSessionExpirationTime.
	
	self should: [ aCartInterface listCart: aCreatedCartId]
	raise: Error - MessageNotUnderstood 
	withExceptionDo: [:anError |
		self assert: ( (Session expiratedSessionErrorMessage) = (anError messageText)).
	]! !

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'BAB 11/5/2017 20:51:41'!
test20AddToCartShouldFailAfterSessionTimePassed
	| aCartInterface aClientPassword aClient aCreatedCartId |
	aClient _ 'pepito'.
	aClientPassword _ 'ahorasi'.
	aCartInterface _ self aCartInterfaceWithRegisteredClient: aClient andPassword: aClientPassword.

	aCreatedCartId _ aCartInterface createCartForClient: aClient withPassword: aClientPassword.
	
	self advanceTime: CartInterface cartSessionExpirationTime.
	
	self should: [ aCartInterface add: 2 copiesOf: 'aBook' toCartWithId: aCreatedCartId.]
	raise: Error - MessageNotUnderstood 
	withExceptionDo: [:anError |
		self assert: ( (Session expiratedSessionErrorMessage) = (anError messageText)).
	]! !

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'BAB 11/5/2017 20:51:32'!
test21CheckoutCartShouldFailAfterSessionTimePassed
	| aCartInterface aClientPassword aClient aCreatedCartId |
	aClient _ 'pepito'.
	aClientPassword _ 'ahorasi'.
	aCartInterface _ self aCartInterfaceWithRegisteredClient: aClient andPassword: aClientPassword.

	aCreatedCartId _ aCartInterface createCartForClient: aClient withPassword: aClientPassword.
	
	self advanceTime: CartInterface cartSessionExpirationTime.
	
	self should: [ aCartInterface add: 2 copiesOf: 'aBook' toCartWithId: aCreatedCartId.]
	raise: Error - MessageNotUnderstood 
	withExceptionDo: [:anError |
		self assert: ( (Session expiratedSessionErrorMessage) = (anError messageText)).
	]! !

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'BAB 11/5/2017 19:22:37'!
test22BookAddedToCartAfterTimePassedShouldAppearListed
	| aCartInterface aClientPassword aClient aCreatedCartId anItemsSummary |
	aClient _ 'pepito'.
	aClientPassword _ 'ahorasi'.
	aCartInterface _ self aCartInterfaceWithRegisteredClient: aClient andPassword: aClientPassword.

	aCreatedCartId _ aCartInterface createCartForClient: aClient withPassword: aClientPassword.
	
	self advanceTime: CartInterface cartSessionExpirationTime / 2.

	aCartInterface add: 2 copiesOf: 'aBook' toCartWithId: aCreatedCartId.
	
	anItemsSummary _ aCartInterface listCart: aCreatedCartId.
	self assert: 1 equals: anItemsSummary size.
	self assert: 2 equals: (anItemsSummary at: 'aBook')
		! !

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'BAB 11/5/2017 19:24:58'!
test23TotalUseOfCartShouldBeAbleToExceedExpirationTime	
	| aCartInterface aClientPassword aClient aCreatedCartId anItemsSummary |
	aClient _ 'pepito'.
	aClientPassword _ 'ahorasi'.
	aCartInterface _ self aCartInterfaceWithRegisteredClient: aClient andPassword: aClientPassword.

	aCreatedCartId _ aCartInterface createCartForClient: aClient withPassword: aClientPassword.
	
	self advanceTime: CartInterface cartSessionExpirationTime / 2.
	aCartInterface add: 2 copiesOf: 'aBook' toCartWithId: aCreatedCartId.

	self advanceTime: CartInterface cartSessionExpirationTime / 2.
	aCartInterface add: 2 copiesOf: 'aBook' toCartWithId: aCreatedCartId.

	self advanceTime: CartInterface cartSessionExpirationTime / 2.
	
	anItemsSummary _ aCartInterface listCart: aCreatedCartId.
	self assert: 1 equals: anItemsSummary size.
	self assert: 4 equals: (anItemsSummary at: 'aBook')
		! !

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

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'asdf 10/30/2017 21:24:33'!
todayDate
	^  (FixedGregorianDate yearNumber: 2017 monthNumber: 2 dayNumber: 12).! !


!TusLibrosTest methodsFor: 'accessing' stamp: 'BAB 11/5/2017 20:47:10'!
aCartInterfaceWithClientsReposity: aClientsRepository
	^ CartInterface withRegisteredClients: aClientsRepository
		withCatalogue: (Dictionary newFromPairs: {'aBook'. 100})
		withPaymentProcessor: self withSalesBook: (Dictionary new).
		! !

!TusLibrosTest methodsFor: 'accessing' stamp: 'BAB 11/5/2017 20:30:53'!
aCartInterfaceWithRegisteredClient: aClient andPassword: aPassword
	^ CartInterface withRegisteredClients:
		(self
			aClientsRepositoryWithUser: aClient
			andPassword: aPassword)
		withCatalogue: (Dictionary newFromPairs: {'aBook'. 100})
		withPaymentProcessor: self withSalesBook: (Dictionary new).
		! !

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
	instanceVariableNames: 'catalogue items'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cart methodsFor: 'as yet unclassified' stamp: 'ip 11/2/2017 13:37:16'!
add: anItem
	| prevQuantityOfItem |
	(catalogue includesKey: anItem) ifFalse: [ Error signal: self itemDoesNotBelongToCatalogueMessage ].
	prevQuantityOfItem _ items
		at: anItem
		ifAbsent: 0.
	items
		at: anItem
		put: prevQuantityOfItem + 1.! !

!Cart methodsFor: 'as yet unclassified' stamp: 'BAB 10/28/2017 18:15:32'!
add: aQuantityToAdd copiesOf: anItem
	aQuantityToAdd timesRepeat: [self add: anItem]! !

!Cart methodsFor: 'as yet unclassified' stamp: 'BAB 10/28/2017 18:15:48'!
copiesOf: anItem
	^ items at: anItem ifAbsent: [^ 0].! !

!Cart methodsFor: 'as yet unclassified' stamp: 'BAB 10/26/2017 21:07:16'!
initializeWithCatalogue: aCatalogue
	catalogue := aCatalogue.
	items := Dictionary new.! !

!Cart methodsFor: 'as yet unclassified' stamp: 'asdf 10/30/2017 19:16:53'!
isEmpty
	^ items isEmpty.! !

!Cart methodsFor: 'as yet unclassified' stamp: 'BAB 10/28/2017 18:20:23'!
itemDoesNotBelongToCatalogueMessage
	^ 'Libro no esta en catalogo'.! !

!Cart methodsFor: 'as yet unclassified' stamp: 'BAB 10/26/2017 20:37:46'!
itemsCount
	^ items size.! !

!Cart methodsFor: 'as yet unclassified' stamp: 'BAB 11/5/2017 15:56:02'!
itemsSummary
	| anItemsSummary |
	anItemsSummary _ Dictionary new.
	self itemsDo: [ :aBook :aQuantity | anItemsSummary at: aBook put: aQuantity].
	^ anItemsSummary.! !

!Cart methodsFor: 'as yet unclassified' stamp: 'ip 11/2/2017 13:51:42'!
totalPrice
	^ items keys inject: 0 into: [ :subTotal :item | (catalogue at: item) * (items at: item) + subTotal ] ! !


!Cart methodsFor: 'accessing' stamp: 'asdf 11/2/2017 21:02:16'!
itemsDo: aBlock
	items keysAndValuesDo: aBlock! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cart class' category: #TusLibros!
Cart class
	instanceVariableNames: ''!

!Cart class methodsFor: 'as yet unclassified' stamp: 'BAB 10/26/2017 20:33:03'!
withCatalogue: aCatalogue
	^ self new initializeWithCatalogue: aCatalogue .! !


!classDefinition: #CartInterface category: #TusLibros!
Object subclass: #CartInterface
	instanceVariableNames: 'catalogue cartsRepository registeredClients salesBook paymentProcessor'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CartInterface methodsFor: 'evaluating' stamp: 'asdf 11/2/2017 20:46:55'!
add: anAmount copiesOf: aBook toCartWithId: aCartId 
	| aCart |
	aCart _ self cartWithId: aCartId.
	aCart add: anAmount copiesOf: aBook. ! !

!CartInterface methodsFor: 'evaluating' stamp: 'ip 11/4/2017 19:12:57'!
authenticateClient: aClient withPassword: aPassword
	(registeredClients includesKey: aClient) ifFalse: [ Error signal: self invalidClientErrorMessage ].
	(registeredClients at: aClient) = aPassword ifFalse: [ Error signal: self incorrectAuthenticationErrorMessage ].! !

!CartInterface methodsFor: 'evaluating' stamp: 'BAB 11/5/2017 20:09:30'!
checkoutCartWithId: aCartId usingCardNumber: aCardNumber withExpirationDate: anExpirationDate withCardOwnerName: aCardOwnerName onDate: aDate 
	| aCard cashier aCart |
	aCard _ Card withNumber: aCardNumber withExpirationDate: anExpirationDate withOwner: aCardOwnerName .
	aCart _  (self cartWithId: aCartId).
	cashier _  Cashier withPaymentProcessor: paymentProcessor withBookOfSales: (self salesBookChapterForClientId: aCart client ).
	cashier charge: aCard withCart: aCart onDate: aDate.
	! !

!CartInterface methodsFor: 'evaluating' stamp: 'BAB 11/5/2017 20:51:08'!
createCartForClient: aClient withPassword: aPassword
	| aCreatedCart aCreatedCartId aCartSession |

	self authenticateClient: aClient withPassword: aPassword.
	aCreatedCart _ Cart withCatalogue: catalogue .
	aCartSession _ Session of: aCreatedCart withClock: paymentProcessor for: (self class cartSessionExpirationTime) byClient: aClient.
	aCreatedCartId _ aCartSession hash.
	cartsRepository at: aCreatedCartId put: aCartSession.
	^ aCreatedCartId! !

!CartInterface methodsFor: 'evaluating' stamp: 'asdf 11/2/2017 21:00:20'!
listCart: aCartId 
	| anItemsSummary |
	anItemsSummary _ Dictionary new.
	(self cartWithId: aCartId) itemsDo: [ :aBook :aQuantity | anItemsSummary at: aBook put: aQuantity].
	^ anItemsSummary! !

!CartInterface methodsFor: 'evaluating' stamp: 'BAB 11/5/2017 20:32:59'!
listPurchasesForClient: aClient withPassword: aPassword 
	self authenticateClient: aClient withPassword: aPassword.
	^ PurchasesDetail withSales: (self salesBookChapterForClientId: aClient).! !

!CartInterface methodsFor: 'evaluating' stamp: 'BAB 11/5/2017 20:11:20'!
salesBookChapterForClientId: aClientId 
	^ SalesBookClientChapter of: salesBook forClient: aClientId.! !


!CartInterface methodsFor: 'as yet unclassified' stamp: 'ip 11/4/2017 18:34:00'!
cartWithId: aCartId
	^ cartsRepository at: aCartId! !

!CartInterface methodsFor: 'as yet unclassified' stamp: 'asdf 11/2/2017 20:02:18'!
incorrectAuthenticationErrorMessage
	^ 'Failed to authenticate'! !

!CartInterface methodsFor: 'as yet unclassified' stamp: 'BAB 11/5/2017 19:40:49'!
initializeWithRegisteredClients: someRegisteredClients withCatalogue: aCatalogue withPaymentProcessor: aPaymentProcessor withSalesBook: aSalesBook 
	registeredClients _ someRegisteredClients.
	catalogue _ aCatalogue.
	paymentProcessor _ aPaymentProcessor .
	salesBook _ aSalesBook .
	cartsRepository  _ Dictionary new.
! !

!CartInterface methodsFor: 'as yet unclassified' stamp: 'asdf 11/2/2017 19:56:30'!
invalidClientErrorMessage
	^ 'Invalid client'! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CartInterface class' category: #TusLibros!
CartInterface class
	instanceVariableNames: ''!

!CartInterface class methodsFor: 'initialization' stamp: 'BAB 11/5/2017 18:57:23'!
cartSessionExpirationTime
	^ (TimeUnits minute) with: 30.! !

!CartInterface class methodsFor: 'initialization' stamp: 'BAB 11/5/2017 16:55:28'!
withRegisteredClients: someRegisteredClients withCatalogue: aCatalogue withPaymentProcessor: aPaymentProcessor withSalesBook: aSalesBook
	^ self new initializeWithRegisteredClients:  someRegisteredClients withCatalogue: aCatalogue withPaymentProcessor: aPaymentProcessor withSalesBook: aSalesBook.! !


!classDefinition: #Cashier category: #TusLibros!
Object subclass: #Cashier
	instanceVariableNames: 'paymentProcessor bookOfSales'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cashier methodsFor: 'evaluating' stamp: 'BAB 11/5/2017 15:56:20'!
charge: aCard withCart: aCart onDate: aFixedDate
	| transactionId |
	aCart isEmpty ifTrue: [ Error signal: self cannotChargeEmptyCartErrorMessage ].
	aFixedDate < aCard expirationDate firstDate ifFalse: [ Error signal: self chargeWithExpiredCardErrorMessage ].
	transactionId _ paymentProcessor
		debit: aCart totalPrice
		from: aCard.
	bookOfSales add: (Sale of: (aCart itemsSummary) withCard: aCard withTotalAmount: aCart totalPrice).
	^ transactionId! !

!Cashier methodsFor: 'evaluating' stamp: 'asdf 10/30/2017 21:16:10'!
chargeWithExpiredCardErrorMessage
	^ 'Credit Card is expired'.! !

!Cashier methodsFor: 'evaluating' stamp: 'BAB 11/5/2017 14:21:43'!
initializeWithPaymentProcessor: aPaymentProcessor withBookOfSales: aSalesBook
	paymentProcessor _ aPaymentProcessor.
	bookOfSales _ aSalesBook.! !


!Cashier methodsFor: 'error handling' stamp: 'asdf 10/30/2017 20:45:05'!
cannotChargeEmptyCartErrorMessage
	^ 'Cannot charge empty cart'.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cashier class' category: #TusLibros!
Cashier class
	instanceVariableNames: ''!

!Cashier class methodsFor: 'initialization' stamp: 'BAB 11/5/2017 12:00:14'!
withPaymentProcessor: aTusLibrosTest withBookOfSales: anOrderedCollection
	^ self new
		initializeWithPaymentProcessor: aTusLibrosTest
		withBookOfSales: anOrderedCollection.! !


!classDefinition: #PurchasesDetail category: #TusLibros!
Object subclass: #PurchasesDetail
	instanceVariableNames: 'productQuantities itemsSummary totalAmount'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!PurchasesDetail methodsFor: 'as yet unclassified' stamp: 'BAB 11/5/2017 16:54:34'!
initializeWithItemsSummary: anItemsSummary withTotalAmount: aTotalAmount
	itemsSummary _ anItemsSummary.
	totalAmount _ aTotalAmount. 
! !

!PurchasesDetail methodsFor: 'as yet unclassified' stamp: 'BAB 11/5/2017 17:02:38'!
isEmpty
	^ itemsSummary isEmpty.! !

!PurchasesDetail methodsFor: 'as yet unclassified' stamp: 'BAB 11/5/2017 17:02:47'!
quantityOf: aProduct
	^ itemsSummary at: aProduct.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'PurchasesDetail class' category: #TusLibros!
PurchasesDetail class
	instanceVariableNames: 'itemsSummary totalAmount'!

!PurchasesDetail class methodsFor: 'as yet unclassified' stamp: 'BAB 11/5/2017 16:54:47'!
withSales: someSalesToDetail
	| anItemsSummary aTotalAmount |
	anItemsSummary _ Dictionary new.
	someSalesToDetail do: [ :aSale |
		
		aSale itemsSummary keysAndValuesDo: [:aProduct :aQuantity | | prevProductQuantity | 
			prevProductQuantity _ anItemsSummary at: aProduct ifAbsent: 0.
			anItemsSummary at: aProduct put: (aQuantity + prevProductQuantity). 	
		]
	].
	
	aTotalAmount _ 0.
	someSalesToDetail ifNotEmpty: [
		aTotalAmount _ someSalesToDetail sum: [:aSale | aSale totalAmount].
		
	].
	^ self new initializeWithItemsSummary: anItemsSummary withTotalAmount: aTotalAmount! !


!classDefinition: #Sale category: #TusLibros!
Object subclass: #Sale
	instanceVariableNames: 'itemsSummary card totalAmount'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Sale methodsFor: 'as yet unclassified' stamp: 'BAB 11/5/2017 15:58:41'!
initializeWithItemsSummary: anItemsSummary withCard: aCard withTotalAmount: aTotalAmount 
	itemsSummary _ anItemsSummary.
	card _ aCard.
	totalAmount _ aTotalAmount.! !

!Sale methodsFor: 'as yet unclassified' stamp: 'BAB 11/5/2017 17:00:51'!
itemsSummary
	^ itemsSummary.! !

!Sale methodsFor: 'as yet unclassified' stamp: 'BAB 11/5/2017 16:15:19'!
totalAmount
	^ totalAmount.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Sale class' category: #TusLibros!
Sale class
	instanceVariableNames: 'itemsSummary'!

!Sale class methodsFor: 'as yet unclassified' stamp: 'BAB 11/5/2017 17:02:08'!
of: anItemsSummary withCard: aCard withTotalAmount: aTotalAmount
	^ self new initializeWithItemsSummary: anItemsSummary withCard: aCard withTotalAmount: aTotalAmount.! !


!classDefinition: #SalesBookClientChapter category: #TusLibros!
Object subclass: #SalesBookClientChapter
	instanceVariableNames: 'clientId salesBook'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!SalesBookClientChapter methodsFor: 'as yet unclassified' stamp: 'BAB 11/5/2017 20:30:19'!
add: aSale
	self chapterOfClient add: aSale.! !

!SalesBookClientChapter methodsFor: 'as yet unclassified' stamp: 'BAB 11/5/2017 20:30:05'!
chapterOfClient
	| chapter |
	chapter _ salesBook at: clientId ifAbsentPut: [OrderedCollection new].
	^ chapter! !

!SalesBookClientChapter methodsFor: 'as yet unclassified' stamp: 'BAB 11/5/2017 20:34:10'!
do: aBlock
	self chapterOfClient do: aBlock.! !

!SalesBookClientChapter methodsFor: 'as yet unclassified' stamp: 'BAB 11/5/2017 20:34:44'!
ifNotEmpty: aBlock
	self chapterOfClient ifNotEmpty: aBlock! !

!SalesBookClientChapter methodsFor: 'as yet unclassified' stamp: 'BAB 11/5/2017 20:13:03'!
initializeOf: aSalesBook forClient: aClientId 
	clientId _ aClientId.
	salesBook _ aSalesBook.! !

!SalesBookClientChapter methodsFor: 'as yet unclassified' stamp: 'BAB 11/5/2017 20:35:12'!
sum: aBlock
	^ self chapterOfClient sum: aBlock.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'SalesBookClientChapter class' category: #TusLibros!
SalesBookClientChapter class
	instanceVariableNames: ''!

!SalesBookClientChapter class methodsFor: 'as yet unclassified' stamp: 'BAB 11/5/2017 20:12:24'!
of: aSalesBook forClient: aClientId 
	^ self new initializeOf: aSalesBook forClient: aClientId.! !


!classDefinition: #Session category: #TusLibros!
Object subclass: #Session
	instanceVariableNames: 'expirable lastTimeUsed clock duration client'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Session methodsFor: 'as yet unclassified' stamp: 'BAB 11/5/2017 20:50:57'!
assertNotExpired
	((lastTimeUsed next: duration) <= (clock now) ) ifTrue: [Error signal: self class expiratedSessionErrorMessage ].! !

!Session methodsFor: 'as yet unclassified' stamp: 'BAB 11/5/2017 20:50:57'!
client
	^ client.! !

!Session methodsFor: 'as yet unclassified' stamp: 'BAB 11/5/2017 20:50:57'!
doesNotUnderstand: aMessage 
	self assertNotExpired.
	lastTimeUsed _ clock now.
	^ aMessage sendTo: expirable.
    ! !

!Session methodsFor: 'as yet unclassified' stamp: 'BAB 11/5/2017 20:50:57'!
initializeOf: anExpirable withClock: aClock for: aDuration 
	expirable _ anExpirable.
	clock _ aClock.
	duration _ aDuration .
	lastTimeUsed _ clock now .! !

!Session methodsFor: 'as yet unclassified' stamp: 'BAB 11/5/2017 20:50:57'!
initializeOf: anExpirable withClock: aClock for: aDuration byClient: aClient
	expirable _ anExpirable.
	clock _ aClock.
	duration _ aDuration .
	lastTimeUsed _ clock now .
	client _ aClient.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Session class' category: #TusLibros!
Session class
	instanceVariableNames: ''!

!Session class methodsFor: 'as yet unclassified' stamp: 'BAB 11/5/2017 20:50:57'!
expiratedSessionErrorMessage
	^ 'Session has expired'! !

!Session class methodsFor: 'as yet unclassified' stamp: 'BAB 11/5/2017 20:50:57'!
of: anExpirable withClock: aClock for: aDuration 
	^ self new initializeOf: anExpirable withClock: aClock for: aDuration .! !

!Session class methodsFor: 'as yet unclassified' stamp: 'BAB 11/5/2017 20:50:57'!
of: anExpirable withClock: aClock for: aDuration byClient: aClient
	^ self new initializeOf: anExpirable withClock: aClock for: aDuration byClient: aClient.! !
