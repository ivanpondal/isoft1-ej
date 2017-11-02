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

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'asdf 11/2/2017 18:21:24'!
test06ChargeWithExpiredCardFails
	| aCart aCard aCardExpirationDate aCashier aSalesBook aBook |
	blockOnDebit _ [ Error signal: 'Merchant Processor: credit card is expired' ].
	
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

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'asdf 10/30/2017 21:24:33'!
todayDate
	^  (FixedGregorianDate yearNumber: 2017 monthNumber: 2 dayNumber: 12).! !


!TusLibrosTest methodsFor: 'accessing' stamp: 'ip 11/2/2017 13:41:19'!
aCatalogueWith: aString 
	^ Dictionary newFromPairs: { aString . 10 }! !

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

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cart class' category: #TusLibros!
Cart class
	instanceVariableNames: ''!

!Cart class methodsFor: 'as yet unclassified' stamp: 'BAB 10/26/2017 20:33:03'!
withCatalogue: aCatalogue
	^ self new initializeWithCatalogue: aCatalogue .! !


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
