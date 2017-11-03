!classDefinition: #TusLibrosTest category: #TusLibros!
TestCase subclass: #TusLibrosTest
	instanceVariableNames: 'blockOnDebit'
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

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'asdf 11/2/2017 20:20:01'!
test10FailToCreateCartWithInvalidClient
	| aCartInterface anInvalidClientPassword anInvalidClient |
	aCartInterface _ CartInterface withClientsRepository: (self aClientsRepositoryWithUser: 'asdf' andPassword: 'admin123').
	anInvalidClient _ 'pepito'.
	anInvalidClientPassword _ '1234'.
	
	self should: [ aCartInterface createCartForClient: anInvalidClient withPassword: anInvalidClientPassword ]
		raise: Error -MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: aCartInterface invalidClientErrorMessage equals: anError messageText
		]! !

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'asdf 11/2/2017 20:10:30'!
test11FailToCreateCartWithIncorrectAuthentication
	| aCartInterface anIncorrectClientPassword aClient |
	aClient _ 'pepito'.
	aCartInterface _ CartInterface withClientsRepository: (self aClientsRepositoryWithUser: aClient andPassword: 'fome').
	anIncorrectClientPassword _ 'nomeacuerdocomoera'.
	
	self should: [ aCartInterface createCartForClient: aClient withPassword: anIncorrectClientPassword ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: aCartInterface incorrectAuthenticationErrorMessage equals: anError messageText
		]! !

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'asdf 11/2/2017 20:24:15'!
test12CreatedCartWithCorrectlyAuthenticatedClientShouldBeEmpty
	| aCartInterface aClientPassword aClient aCreatedCartId |
	aClient _ 'pepito'.
	aClientPassword _ 'ahorasi'.
	aCartInterface _ CartInterface withClientsRepository:
		(self
			aClientsRepositoryWithUser: aClient
			andPassword: aClientPassword).

	aCreatedCartId _ aCartInterface createCartForClient: aClient withPassword: aClientPassword.
	self assert: (aCartInterface listCart: aCreatedCartId) isEmpty.
		! !

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'asdf 11/2/2017 20:43:40'!
test13BookAddedToCartShouldAppearListed
	| aCartInterface aClientPassword aClient aCreatedCartId anItemsSummary |
	aClient _ 'pepito'.
	aClientPassword _ 'ahorasi'.
	aCartInterface _ CartInterface withClientsRepository:
		(self
			aClientsRepositoryWithUser: aClient
			andPassword: aClientPassword).

	aCreatedCartId _ aCartInterface createCartForClient: aClient withPassword: aClientPassword.
	aCartInterface add: 2 copiesOf: 'aBook' toCartWithId: aCreatedCartId.
	
	anItemsSummary _ aCartInterface listCart: aCreatedCartId.
	self assert: 1 equals: anItemsSummary size.
	self assert: 2 equals: (anItemsSummary at: 'aBook')
		! !

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'asdf 10/30/2017 21:24:33'!
todayDate
	^  (FixedGregorianDate yearNumber: 2017 monthNumber: 2 dayNumber: 12).! !


!TusLibrosTest methodsFor: 'accessing' stamp: 'ip 11/2/2017 13:41:19'!
aCatalogueWith: aString 
	^ Dictionary newFromPairs: { aString . 10 }! !

!TusLibrosTest methodsFor: 'accessing' stamp: 'asdf 11/2/2017 20:12:20'!
aClientsRepositoryWithUser: aClient andPassword: aPassword 
	^ Dictionary newFromPairs: { aClient. aPassword }.! !

!TusLibrosTest methodsFor: 'accessing' stamp: 'asdf 11/2/2017 18:15:19'!
anEmptyCatalogue
	^ Dictionary new! !

!TusLibrosTest methodsFor: 'accessing' stamp: 'asdf 11/2/2017 18:20:59'!
setUp
	blockOnDebit _ [ :anAmount :aCardToDebitFrom | 0 ].! !

!TusLibrosTest methodsFor: 'accessing' stamp: 'asdf 10/30/2017 21:35:06'!
validCard
	^ Card
		withNumber: '01210'
		withExpirationDate: (GregorianMonthOfYear yearNumber: 2022 monthNumber: 1)
		withOwner: 'John Smith'.! !


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
	instanceVariableNames: 'clientsRepository catalogue cart'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!CartInterface methodsFor: 'evaluating' stamp: 'asdf 11/2/2017 20:46:55'!
add: anAmount copiesOf: aBook toCartWithId: aCartId 
	| aCart |
	aCart _ self cartWithId: aCartId.
	aCart add: anAmount copiesOf: aBook. ! !

!CartInterface methodsFor: 'evaluating' stamp: 'asdf 11/2/2017 21:04:57'!
createCartForClient: aClient withPassword: aPassword
	(clientsRepository includesKey: aClient) ifFalse: [ Error signal: self invalidClientErrorMessage ].
	(clientsRepository at: aClient) = aPassword ifFalse: [ Error signal: self incorrectAuthenticationErrorMessage ].
	cart _ Cart withCatalogue: catalogue.
	^ '0'! !

!CartInterface methodsFor: 'evaluating' stamp: 'asdf 11/2/2017 21:00:20'!
listCart: aCartId 
	| anItemsSummary |
	anItemsSummary _ Dictionary new.
	(self cartWithId: aCartId) itemsDo: [ :aBook :aQuantity | anItemsSummary at: aBook put: aQuantity].
	^ anItemsSummary! !


!CartInterface methodsFor: 'as yet unclassified' stamp: 'asdf 11/2/2017 21:04:43'!
cartWithId: aCartId
	^ cart! !

!CartInterface methodsFor: 'as yet unclassified' stamp: 'asdf 11/2/2017 20:02:18'!
incorrectAuthenticationErrorMessage
	^ 'Failed to authenticate'! !

!CartInterface methodsFor: 'as yet unclassified' stamp: 'asdf 11/2/2017 20:50:37'!
initializeWithClientsRepository: aClientsRepository 
	clientsRepository _ aClientsRepository.
	catalogue _ Dictionary newFromPairs: { 'aBook'. 100 }! !

!CartInterface methodsFor: 'as yet unclassified' stamp: 'asdf 11/2/2017 19:56:30'!
invalidClientErrorMessage
	^ 'Invalid client'! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CartInterface class' category: #TusLibros!
CartInterface class
	instanceVariableNames: ''!

!CartInterface class methodsFor: 'initialization' stamp: 'asdf 11/2/2017 20:17:01'!
withClientsRepository: aClientsRepository 
	^ self new initializeWithClientsRepository: aClientsRepository.! !


!classDefinition: #Cashier category: #TusLibros!
Object subclass: #Cashier
	instanceVariableNames: 'paymentProcessor currentDate bookOfSales'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cashier methodsFor: 'evaluating' stamp: 'asdf 11/2/2017 17:51:43'!
charge: aCard withCart: aCart onDate: aFixedDate
	| transactionId |
	aCart isEmpty ifTrue: [ Error signal: self cannotChargeEmptyCartErrorMessage ].
	aFixedDate < aCard expirationDate firstDate ifFalse: [ Error signal: self chargeWithExpiredCardErrorMessage ].
	transactionId _ paymentProcessor
		debit: aCart totalPrice
		from: aCard.
	bookOfSales add: ''.
	^ transactionId! !

!Cashier methodsFor: 'evaluating' stamp: 'asdf 10/30/2017 21:16:10'!
chargeWithExpiredCardErrorMessage
	^ 'Credit Card is expired'.! !

!Cashier methodsFor: 'evaluating' stamp: 'BAB 10/30/2017 17:19:01'!
initializeWithPaymentProcessor: aPaymentProcessor onDate: aCurrentDate
	paymentProcessor :=  aPaymentProcessor.
	currentDate := aCurrentDate.! !


!Cashier methodsFor: 'private' stamp: 'asdf 10/30/2017 19:01:38'!
initializePaymentProcessor: aPaymentProcessor withBookOfSales: anOrderedCollection 
	paymentProcessor _ aPaymentProcessor.
	bookOfSales _ anOrderedCollection.! !


!Cashier methodsFor: 'error handling' stamp: 'asdf 10/30/2017 20:45:05'!
cannotChargeEmptyCartErrorMessage
	^ 'Cannot charge empty cart'.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cashier class' category: #TusLibros!
Cashier class
	instanceVariableNames: ''!


!Cashier class methodsFor: 'initialization' stamp: 'asdf 10/30/2017 19:00:33'!
withPaymentProcessor: aTusLibrosTest withBookOfSales: anOrderedCollection 
	^ self new initializePaymentProcessor: aTusLibrosTest withBookOfSales: anOrderedCollection.! !
