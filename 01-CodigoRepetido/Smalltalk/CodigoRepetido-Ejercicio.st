!classDefinition: #NotFound category: #'CodigoRepetido-Ejercicio'!
Error subclass: #NotFound
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CodigoRepetido-Ejercicio'!


!classDefinition: #IdiomTest category: #'CodigoRepetido-Ejercicio'!
TestCase subclass: #IdiomTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CodigoRepetido-Ejercicio'!

!IdiomTest methodsFor: 'testing' stamp: 'ivan 9/6/2017 21:26:07'!
assert: aBlock runsInLessThan: milliseconds
	| timeInMillisecondsBeforeRunning timeInMillisecondsAfterRunning |
	timeInMillisecondsBeforeRunning _ Time millisecondClockValue milliSeconds.
	aBlock value.
	timeInMillisecondsAfterRunning _ Time millisecondClockValue milliSeconds.
	self assert: timeInMillisecondsAfterRunning - timeInMillisecondsBeforeRunning < milliseconds.! !

!IdiomTest methodsFor: 'testing' stamp: 'BAB 9/7/2017 12:41:19'!
should: aBlock raise: anException withExceptionDo: handlerAction
	[ aBlock value.
		self fail] on: anException do: handlerAction.! !

!IdiomTest methodsFor: 'testing' stamp: 'ivan 9/6/2017 21:25:11'!
test01AddingCustomerShouldNotTakeMoreThan50Milliseconds
	| customerBook |
	customerBook := CustomerBook new.
	self assert: [customerBook addCustomerNamed: 'John Lennon'] runsInLessThan: 50 milliSeconds.! !

!IdiomTest methodsFor: 'testing' stamp: 'ivan 9/6/2017 21:25:03'!
test02RemovingCustomerShouldNotTakeMoreThan100Milliseconds
	| customerBook paulMcCartney |
	customerBook := CustomerBook new.
	paulMcCartney _ 'Paul McCartney'.
	customerBook addCustomerNamed: paulMcCartney.
	self assert: [customerBook removeCustomerNamed: paulMcCartney ]  runsInLessThan: 100 milliSeconds.
! !

!IdiomTest methodsFor: 'testing' stamp: 'BAB 9/7/2017 12:15:57'!
test03CanNotAddACustomerWithEmptyName 
	| customerBook |
	customerBook := CustomerBook new.
	self should: [customerBook addCustomerNamed: ''] raise: Error withExceptionDo:  
	[ :anError | 
		self assert: anError messageText = CustomerBook customerCanNotBeEmptyErrorMessage.
		self assert: customerBook isEmpty].! !

!IdiomTest methodsFor: 'testing' stamp: 'BAB 9/7/2017 12:15:23'!
test04CanNotRemoveAndInvalidCustomer
	| customerBook johnLennon |
	johnLennon := 'John Lennon'.
	customerBook := CustomerBook new.
	customerBook addCustomerNamed: johnLennon.
	self should:  [customerBook removeCustomerNamed: 'Paul McCartney' ] raise: NotFound withExceptionDo:
	[ :anError | 
		self assert: customerBook numberOfCustomers = 1.
		self assert: (customerBook includesCustomerNamed: johnLennon) ].! !


!classDefinition: #CustomerBook category: #'CodigoRepetido-Ejercicio'!
Object subclass: #CustomerBook
	instanceVariableNames: 'customers'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'CodigoRepetido-Ejercicio'!

!CustomerBook methodsFor: 'testing' stamp: 'HernanWilkinson 7/6/2011 17:56'!
includesCustomerNamed: aName

	^customers includes: aName ! !

!CustomerBook methodsFor: 'testing' stamp: 'HernanWilkinson 7/6/2011 17:48'!
isEmpty
	
	^customers isEmpty  ! !


!CustomerBook methodsFor: 'initialization' stamp: 'HernanWilkinson 7/6/2011 17:42'!
initialize

	super initialize.
	customers := OrderedCollection new! !


!CustomerBook methodsFor: 'customer management' stamp: 'HernanWilkinson 7/6/2011 17:42'!
addCustomerNamed: aName

	aName isEmpty ifTrue: [ self signalCustomerNameCannotBeEmpty ].
	(customers includes: aName) ifTrue: [ self signalCustomerAlreadyExists ].
	
	customers add: aName ! !

!CustomerBook methodsFor: 'customer management' stamp: 'HernanWilkinson 7/6/2011 17:56'!
numberOfCustomers
	
	^customers size! !

!CustomerBook methodsFor: 'customer management' stamp: 'HAW 4/14/2017 16:55:43'!
removeCustomerNamed: aName
 
	customers remove: aName ifAbsent: [ NotFound signal ]! !

!CustomerBook methodsFor: 'customer management' stamp: 'HernanWilkinson 7/6/2011 17:52'!
signalCustomerAlreadyExists 

	self error: self class customerAlreadyExistsErrorMessage! !

!CustomerBook methodsFor: 'customer management' stamp: 'HernanWilkinson 7/6/2011 17:51'!
signalCustomerNameCannotBeEmpty 

	self error: self class customerCanNotBeEmptyErrorMessage ! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'CustomerBook class' category: #'CodigoRepetido-Ejercicio'!
CustomerBook class
	instanceVariableNames: ''!

!CustomerBook class methodsFor: 'error messages' stamp: 'HernanWilkinson 7/6/2011 17:57'!
customerAlreadyExistsErrorMessage

	^'Customer already exists'! !

!CustomerBook class methodsFor: 'error messages' stamp: 'HernanWilkinson 7/6/2011 17:53'!
customerCanNotBeEmptyErrorMessage

	^'Customer name cannot be empty'! !
