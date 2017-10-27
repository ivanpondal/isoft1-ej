!classDefinition: #TusLibrosTest category: #TusLibros!
TestCase subclass: #TusLibrosTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'BAB 10/26/2017 20:26:43'!
test01
	| aCart |
	aCart := Cart new.
	self assert: aCart isEmpty.! !

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'BAB 10/26/2017 21:02:26'!
test02
	| aCart aBook |
	
	aBook := Book new.
	aCart := Cart withCatalogue: (Set with: aBook  ).
	aCart add: 1 copiesOf: aBook.
	
	self assert: (aCart copiesOf: aBook) = 1.! !

!TusLibrosTest methodsFor: 'as yet unclassified' stamp: 'BAB 10/26/2017 21:48:01'!
test03
	| aCart aBook |
	aCart := Cart withCatalogue: Set new.
	aBook := Book new.
	self should: [
		aCart add: aBook.
		self fail.]  raise: Error withExceptionDo: [:anError | 
		self assert: (anError messageText = (aCart bookDoesNotBelongToCatalogueMessage)) ] .
	! !


!classDefinition: #Book category: #TusLibros!
Object subclass: #Book
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!


!classDefinition: #Cajerx category: #TusLibros!
Object subclass: #Cajerx
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!


!classDefinition: #Cart category: #TusLibros!
Object subclass: #Cart
	instanceVariableNames: 'catalogue items'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TusLibros'!

!Cart methodsFor: 'as yet unclassified' stamp: 'BAB 10/26/2017 21:42:10'!
add: aQuantityToAdd copiesOf: aBook
	| prevQuantityOfBooks |
	(catalogue includes: aBook) ifFalse: [Error signal: self bookDoesNotBelongToCatalogueMessage ].
	prevQuantityOfBooks := items at: aBook ifAbsent: 0.
	items at: aBook put: prevQuantityOfBooks + aQuantityToAdd . 
! !

!Cart methodsFor: 'as yet unclassified' stamp: 'BAB 10/26/2017 21:47:33'!
bookDoesNotBelongToCatalogueMessage
	^ 'Libro no esta en catalogo'.! !

!Cart methodsFor: 'as yet unclassified' stamp: 'BAB 10/26/2017 21:12:31'!
copiesOf: aBook
	^ items at: aBook ifAbsent: [^ 0].! !

!Cart methodsFor: 'as yet unclassified' stamp: 'BAB 10/26/2017 21:07:16'!
initializeWithCatalogue: aCatalogue
	catalogue := aCatalogue.
	items := Dictionary new.! !

!Cart methodsFor: 'as yet unclassified' stamp: 'BAB 10/26/2017 20:19:38'!
isEmpty
	^ true.! !

!Cart methodsFor: 'as yet unclassified' stamp: 'BAB 10/26/2017 20:37:46'!
itemsCount
	^ items size.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Cart class' category: #TusLibros!
Cart class
	instanceVariableNames: ''!

!Cart class methodsFor: 'as yet unclassified' stamp: 'BAB 10/26/2017 20:33:03'!
withCatalogue: aCatalogue
	^ self new initializeWithCatalogue: aCatalogue .! !
