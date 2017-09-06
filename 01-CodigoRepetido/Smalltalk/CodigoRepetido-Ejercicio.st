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

!IdiomTest methodsFor: 'testing' stamp: 'bi 9/5/2017 18:55:06'!
after: setupBlock test: blockToTest runsInLessThan: milliseconds
	|millisecondsBeforeRunning millisecondsAfterRunning|
	setupBlock value.
	millisecondsBeforeRunning _ Time millisecondClockValue milliSeconds.
	blockToTest value.
	millisecondsAfterRunning _ Time millisecondClockValue milliSeconds.
	self assert: millisecondsAfterRunning - millisecondsBeforeRunning < milliseconds.! !

!IdiomTest methodsFor: 'testing' stamp: 'bi 9/5/2017 19:19:45'!
createNewCustomerBookAndAfter: setUpBlock test: failingBlock shouldFailOn: expectedException andDo: finishBlock
| customerBook |
	customerBook := CustomerBook  new.
	setUpBlock value: customerBook.
	[failingBlock value: customerBook.
	self fail.] on: expectedException do: [:anError | finishBlock value: anError value: customerBook].
	
	
! !

!IdiomTest methodsFor: 'testing' stamp: 'bi 9/6/2017 00:06:08'!
createNewCustomerBookAndTest: failingBlock shouldFailOn: expectedException andDo: finishBlock
	self createNewCustomerBookAndAfter:  [:customerBook | ] 
		test: failingBlock  
		shouldFailOn: expectedException andDo: finishBlock.
! !

!IdiomTest methodsFor: 'testing' stamp: 'bi 9/5/2017 18:44:41'!
test01AddingCustomerShouldNotTakeMoreThan50Milliseconds
	|customerBook|
	customerBook := CustomerBook new.
	self test: [customerBook addCustomerNamed: 'John Lennon'] runsInLessThan: 50 milliSeconds.! !

!IdiomTest methodsFor: 'testing' stamp: 'bi 9/5/2017 18:48:53'!
test02RemovingCustomerShouldNotTakeMoreThan100Milliseconds
	|customerBook paulMcCartney| 
	customerBook := CustomerBook new.
	paulMcCartney _ 'Paul McCartney'.
	self after: [customerBook addCustomerNamed: paulMcCartney] test: [customerBook removeCustomerNamed: paulMcCartney ]  runsInLessThan: 100 milliSeconds.
! !

!IdiomTest methodsFor: 'testing' stamp: 'bi 9/6/2017 00:06:34'!
test03CanNotAddACustomerWithEmptyName 

	self createNewCustomerBookAndTest: [:customerBook | customerBook addCustomerNamed: ''] shouldFailOn: Error andDo: [ :anError :customerBook| 
			self assert: anError messageText = CustomerBook customerCanNotBeEmptyErrorMessage.
			self assert: customerBook isEmpty.]! !

!IdiomTest methodsFor: 'testing' stamp: 'bi 9/6/2017 00:07:06'!
test04CanNotRemoveAndInvalidCustomer
	| johnLennon |
	johnLennon := 'John Lennon'.
	
	self createNewCustomerBookAndAfter:  [:customerBook | 	
		customerBook addCustomerNamed: johnLennon.] 
		test: [:customerBook | customerBook removeCustomerNamed: 'Paul McCartney']  
		shouldFailOn: NotFound andDo: [ :anError :customerBook | 
			self assert: customerBook numberOfCustomers = 1.
			self assert: (customerBook includesCustomerNamed: johnLennon) ].! !

!IdiomTest methodsFor: 'testing' stamp: 'bi 9/5/2017 18:46:55'!
test: blockToTest runsInLessThan: milliseconds
	self after: [] test: blockToTest runsInLessThan: milliseconds.! !

!IdiomTest methodsFor: 'testing' stamp: 'BAB 9/3/2017 16:45:18'!
testBlockOnNewCustomerBook: blockToTest after: setUpBlock takes: millisecondsToWait
	| customerBook millisecondsBeforeRunning millisecondsAfterRunning |
	customerBook _ CustomerBook new.
	setUpBlock value: customerBook.
	millisecondsBeforeRunning _ Time millisecondClockValue.
	blockToTest value: customerBook.
	millisecondsAfterRunning _ Time millisecondClockValue.
	self assert: millisecondsAfterRunning - millisecondsBeforeRunning < millisecondsToWait.! !

!IdiomTest methodsFor: 'testing' stamp: 'BAB 9/3/2017 16:45:44'!
testBlockOnNewCustomerBook: blockToTest takes: millisecondsToWait
	self testBlockOnNewCustomerBook: blockToTest after: [:customerBook | ] takes: millisecondsToWait.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'IdiomTest class' category: #'CodigoRepetido-Ejercicio'!
IdiomTest class
	instanceVariableNames: ''!

!IdiomTest class methodsFor: 'testing' stamp: 'bi 9/5/2017 18:32:01'!
test: aBlockClosure runsInLessThan: aDuration 
	self shouldBeImplemented.! !


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
