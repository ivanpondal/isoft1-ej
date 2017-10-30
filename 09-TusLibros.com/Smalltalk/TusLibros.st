!classDefinition: #TusLibrosTest category: #TusLibros!
TestCase subclass: #TusLibrosTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'BAB 10/28/2017 19:31:17'!
debit: anAmounto to: aCard! !

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'BAB 10/26/2017 20:26:43'!
test01
	| aCart |
	aCart := Cart new.
	self assert: aCart isEmpty.! !

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'BAB 10/28/2017 18:16:54'!
test02
	| aCart aBook |
	aBook := '1111'.
	aCart := Cart withCatalogue: (Set with: aBook  ).
	aCart add: 1 copiesOf: aBook.
	
	self assert: (aCart copiesOf: aBook) = 1.! !

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'BAB 10/28/2017 18:21:10'!
test03
	| aCartWithEmptyCatalogue aBook |
	aCartWithEmptyCatalogue _ Cart withCatalogue: Set new.
	aBook _ '1111'.
	self
		should: [
			aCartWithEmptyCatalogue add: aBook.
			self fail ]
		raise: Error
		withExceptionDo: [ :anError |
			self assert: anError messageText = aCartWithEmptyCatalogue itemDoesNotBelongToCatalogueMessage.
			self assert: aCartWithEmptyCatalogue isEmpty ].! !

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'BAB 10/30/2017 16:53:22'!
test04
	|aBook aCart aCard aCardExpirationDate aCashier aCurrentDate|
	aBook := '1111'.
	aCart := Cart withCatalogue: (Set with: aBook). 
	aCardExpirationDate := GregorianMonthOfYear yearNumber: 2023 monthNumber: 10.
	aCurrentDate := FixedGregorianDate  yearNumber: 2017 monthNumber: 10 dayNumber: 30.
	aCard := Card withNumber: '01210' withExpirationDate: aCardExpirationDate withOwner: 'John Smith'.
	aCashier := Cashier withPaymentProcessor: self onDate: aCurrentDate .
	aCashier charge: aCard withCart: aCart.! !

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'BAB 10/30/2017 16:59:04'!
test05
	|aBook aCart aCard aCardExpirationDate aCashier aCurrentDate|
	aBook := '1111'.
	aCart := Cart withCatalogue: (Set with: aBook). 
	aCardExpirationDate := GregorianMonthOfYear yearNumber: 2012 monthNumber: 10.
	aCurrentDate := FixedGregorianDate  yearNumber: 2017 monthNumber: 10 dayNumber: 30.
	aCard := Card withNumber: '01210' withExpirationDate: aCardExpirationDate withOwner: 'John Smith'.
	aCashier := Cashier withPaymentProcessor: self onDate: aCurrentDate .
	self 
		should: [
			aCashier charge: aCard withCart: aCart.
			self fail] 
		raise: Error
		withExceptionDo: [:anError |
			anError messageText = aCashier chargeWithExpiredCardMessage.
		].! !


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

!Cart methodsFor: 'as yet unclassified' stamp: 'BAB 10/28/2017 18:20:23'!
add: anItem
	| prevQuantityOfItem |
	(catalogue includes: anItem) ifFalse: [ Error signal: self itemDoesNotBelongToCatalogueMessage ].
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

!Cart methodsFor: 'as yet unclassified' stamp: 'BAB 10/26/2017 20:19:38'!
isEmpty
	^ true.! !

!Cart methodsFor: 'as yet unclassified' stamp: 'BAB 10/28/2017 18:20:23'!
itemDoesNotBelongToCatalogueMessage
	^ 'Libro no esta en catalogo'.! !

!Cart methodsFor: 'as yet unclassified' stamp: 'BAB 10/26/2017 20:37:46'!
itemsCount
	^ items size.! !

!Cart methodsFor: 'as yet unclassified' stamp: 'BAB 10/30/2017 16:48:54'!
totalPrice
	^ 0.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cart class' category: #TusLibros!
Cart class
	instanceVariableNames: ''!

!Cart class methodsFor: 'as yet unclassified' stamp: 'BAB 10/26/2017 20:33:03'!
withCatalogue: aCatalogue
	^ self new initializeWithCatalogue: aCatalogue .! !


!classDefinition: #Cashier category: #TusLibros!
Object subclass: #Cashier
	instanceVariableNames: 'paymentProcessor currentDate'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cashier methodsFor: 'evaluating' stamp: 'BAB 10/30/2017 17:29:04'!
charge: aCard withCart: aCart 
	(currentDate < aCard expirationDate firstDate) ifFalse: [Error signal: self chargeWithExpiredCardMessage].
	paymentProcessor debit: aCart totalPrice to: aCard.! !

!Cashier methodsFor: 'evaluating' stamp: 'BAB 10/30/2017 17:29:56'!
chargeWithExpiredCardMessage
	'Credit Card is expired'.! !

!Cashier methodsFor: 'evaluating' stamp: 'BAB 10/30/2017 17:19:01'!
initializeWithPaymentProcessor: aPaymentProcessor onDate: aCurrentDate
	paymentProcessor :=  aPaymentProcessor.
	currentDate := aCurrentDate.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cashier class' category: #TusLibros!
Cashier class
	instanceVariableNames: ''!

!Cashier class methodsFor: 'evaluating' stamp: 'BAB 10/30/2017 17:19:21'!
withPaymentProcessor: aPaymentProcessor onDate: aCurrentDate
	^ self new initializeWithPaymentProcessor: aPaymentProcessor onDate: aCurrentDate.! !
