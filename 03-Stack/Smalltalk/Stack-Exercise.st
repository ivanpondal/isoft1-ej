!classDefinition: #OOStackTest category: #'Stack-Exercise'!
TestCase subclass: #OOStackTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!OOStackTest methodsFor: 'test' stamp: 'BAB 9/22/2017 14:48:50'!
test01StackShouldBeEmptyWhenCreated
	| stack |
	stack _ OOStack new.
	self assert: stack isEmpty.! !

!OOStackTest methodsFor: 'test' stamp: 'BAB 9/22/2017 14:48:50'!
test02PushAddElementsToTheStack
	| stack |
	stack _ OOStack new.
	stack push: 'Something'.
	self deny: stack isEmpty.! !

!OOStackTest methodsFor: 'test' stamp: 'BAB 9/22/2017 14:48:50'!
test03PopRemovesElementsFromTheStack
	| stack |
	stack _ OOStack new.
	stack push: 'Something'.
	stack pop.
	self assert: stack isEmpty.! !

!OOStackTest methodsFor: 'test' stamp: 'BAB 9/22/2017 14:48:50'!
test04PopReturnsLastPushedObject
	| stack pushedObject |
	stack _ OOStack new.
	pushedObject _ 'Something'.
	stack push: pushedObject.
	self assert: stack pop = pushedObject.! !

!OOStackTest methodsFor: 'test' stamp: 'BAB 9/22/2017 14:48:50'!
test05StackBehavesLIFO
	| stack firstPushedObject secondPushedObject |
	stack _ OOStack new.
	firstPushedObject _ 'First'.
	secondPushedObject _ 'Second'.
	stack push: firstPushedObject.
	stack push: secondPushedObject.
	self assert: stack pop = secondPushedObject.
	self assert: stack pop = firstPushedObject.
	self assert: stack isEmpty.! !

!OOStackTest methodsFor: 'test' stamp: 'BAB 9/22/2017 14:48:50'!
test06TopReturnsLastPushedObject
	| stack pushedObject |
	stack _ OOStack new.
	pushedObject _ 'Something'.
	stack push: pushedObject.
	self assert: stack top = pushedObject.! !

!OOStackTest methodsFor: 'test' stamp: 'BAB 9/22/2017 14:48:50'!
test07TopDoesNotRemoveObjectFromStack
	| stack pushedObject |
	stack _ OOStack new.
	pushedObject _ 'Something'.
	stack push: pushedObject.
	self assert: stack size = 1.
	stack top.
	self assert: stack size = 1.! !

!OOStackTest methodsFor: 'test' stamp: 'BAB 9/22/2017 14:48:50'!
test08CanNotPopWhenThereAreNoObjectsInTheStack
	| stack |
	stack _ OOStack new.
	self
		should: [ stack pop ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = OOStack stackEmptyErrorDescription ].! !

!OOStackTest methodsFor: 'test' stamp: 'BAB 9/22/2017 14:48:50'!
test09CanNotPopWhenThereAreNoObjectsInTheStackAndTheStackHadObjects
	| stack |
	stack _ OOStack new.
	stack push: 'Something'.
	stack pop.
	self
		should: [ stack pop ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = OOStack stackEmptyErrorDescription ].! !

!OOStackTest methodsFor: 'test' stamp: 'BAB 9/22/2017 14:48:50'!
test10CanNotTopWhenThereAreNoObjectsInTheStack
	| stack |
	stack _ OOStack new.
	self
		should: [ stack top ]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError |
			self assert: anError messageText = OOStack stackEmptyErrorDescription ].! !


!classDefinition: #Stack category: #'Stack-Exercise'!
Object subclass: #Stack
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!Stack methodsFor: 'as yet unclassified' stamp: 'BAB 9/18/2017 11:31:19'!
isEmpty
	self subclassResponsibility! !

!Stack methodsFor: 'as yet unclassified' stamp: 'BAB 9/18/2017 11:31:11'!
pop
	self subclassResponsibility! !

!Stack methodsFor: 'as yet unclassified' stamp: 'BAB 9/18/2017 11:31:02'!
push: anObjectToPush
	self subclassResponsibility! !

!Stack methodsFor: 'as yet unclassified' stamp: 'BAB 9/18/2017 11:31:14'!
size
	self subclassResponsibility! !

!Stack methodsFor: 'as yet unclassified' stamp: 'BAB 9/18/2017 11:31:08'!
top
	self subclassResponsibility! !


!classDefinition: #ImmutableStack category: #'Stack-Exercise'!
Stack subclass: #ImmutableStack
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!ImmutableStack methodsFor: 'as yet unclassified' stamp: 'BAB 9/18/2017 11:36:20'!
push: anObjectToPush
	^ NonEmptyImmutableStack
		with: anObjectToPush
		onTopOf: self.! !


!classDefinition: #EmptyImmutableStack category: #'Stack-Exercise'!
ImmutableStack subclass: #EmptyImmutableStack
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!EmptyImmutableStack methodsFor: 'as yet unclassified' stamp: 'BAB 9/17/2017 11:24:46'!
bottom
	^ self signalEmptyStackError.! !

!EmptyImmutableStack methodsFor: 'as yet unclassified' stamp: 'BAB 9/16/2017 19:05:28'!
isEmpty
	^ true.! !

!EmptyImmutableStack methodsFor: 'as yet unclassified' stamp: 'BAB 9/22/2017 14:48:50'!
signalEmptyStackError
	^ self error: OOStack stackEmptyErrorDescription.! !

!EmptyImmutableStack methodsFor: 'as yet unclassified' stamp: 'BAB 9/17/2017 11:19:04'!
size
	^ 0.! !

!EmptyImmutableStack methodsFor: 'as yet unclassified' stamp: 'BAB 9/17/2017 10:58:04'!
top
	^ self signalEmptyStackError.! !


!classDefinition: #NonEmptyImmutableStack category: #'Stack-Exercise'!
ImmutableStack subclass: #NonEmptyImmutableStack
	instanceVariableNames: 'topObject bottomStack'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!NonEmptyImmutableStack methodsFor: 'as yet unclassified' stamp: 'BAB 9/17/2017 11:24:01'!
bottom
	^ bottomStack.! !

!NonEmptyImmutableStack methodsFor: 'as yet unclassified' stamp: 'BAB 9/17/2017 11:03:18'!
initializeWith: aTopObject onTopOf: aBottomStack
	topObject := aTopObject.
	bottomStack := aBottomStack.! !

!NonEmptyImmutableStack methodsFor: 'as yet unclassified' stamp: 'BAB 9/17/2017 10:59:38'!
isEmpty
	^ false.! !

!NonEmptyImmutableStack methodsFor: 'as yet unclassified' stamp: 'BAB 9/17/2017 11:20:13'!
size
	^ bottomStack size + 1.! !

!NonEmptyImmutableStack methodsFor: 'as yet unclassified' stamp: 'BAB 9/17/2017 10:59:45'!
top
	^ topObject.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'NonEmptyImmutableStack class' category: #'Stack-Exercise'!
NonEmptyImmutableStack class
	instanceVariableNames: ''!

!NonEmptyImmutableStack class methodsFor: 'as yet unclassified' stamp: 'BAB 9/17/2017 11:03:12'!
with: aTopObject onTopOf: aBottomStack
	| newStack |
	newStack := self new.
	newStack initializeWith: aTopObject onTopOf: aBottomStack.
	^ newStack.! !


!classDefinition: #OOStack category: #'Stack-Exercise'!
Stack subclass: #OOStack
	instanceVariableNames: 'internalInmutableStack'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!OOStack methodsFor: 'as yet unclassified' stamp: 'BAB 9/18/2017 11:35:45'!
initialize
	internalInmutableStack _ EmptyImmutableStack new.! !

!OOStack methodsFor: 'as yet unclassified' stamp: 'BAB 9/17/2017 10:55:14'!
isEmpty
	^ internalInmutableStack isEmpty.! !

!OOStack methodsFor: 'as yet unclassified' stamp: 'BAB 9/17/2017 11:24:22'!
pop
	| topObject |
	topObject := internalInmutableStack top.
	internalInmutableStack := internalInmutableStack bottom.
	^ topObject .! !

!OOStack methodsFor: 'as yet unclassified' stamp: 'BAB 9/17/2017 11:15:55'!
push: anObjectToPush
	internalInmutableStack := internalInmutableStack push: anObjectToPush .! !

!OOStack methodsFor: 'as yet unclassified' stamp: 'BAB 9/17/2017 11:19:49'!
size
	^ internalInmutableStack size.! !

!OOStack methodsFor: 'as yet unclassified' stamp: 'BAB 9/17/2017 11:16:09'!
top
	^ internalInmutableStack top.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OOStack class' category: #'Stack-Exercise'!
OOStack class
	instanceVariableNames: ''!

!OOStack class methodsFor: 'error descriptions' stamp: 'BAB 9/17/2017 10:55:14'!
stackEmptyErrorDescription
	
	^ 'Stack is empty'! !


!OOStack class methodsFor: 'as yet unclassified' stamp: 'BAB 9/22/2017 14:48:18'!
new
	| emptyStack |
	emptyStack := super new.
	emptyStack initialize.
	^ emptyStack! !
