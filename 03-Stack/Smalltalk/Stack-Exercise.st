!classDefinition: #OOStackTest category: #'Stack-Exercise'!
TestCase subclass: #OOStackTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!OOStackTest methodsFor: 'test' stamp: 'HernanWilkinson 5/7/2012 11:30'!
test01StackShouldBeEmptyWhenCreated

	| stack |
	
	stack := OOStack new.
	
	self assert: stack isEmpty! !

!OOStackTest methodsFor: 'test' stamp: 'HernanWilkinson 5/7/2012 11:30'!
test02PushAddElementsToTheStack

	| stack |
	
	stack := OOStack new.
	stack push: 'Something'.
	
	self deny: stack isEmpty! !

!OOStackTest methodsFor: 'test' stamp: 'HernanWilkinson 5/7/2012 11:31'!
test03PopRemovesElementsFromTheStack

	| stack |
	
	stack := OOStack new.
	stack push: 'Something'.
	stack pop.
	
	self assert: stack isEmpty! !

!OOStackTest methodsFor: 'test' stamp: 'HernanWilkinson 5/8/2012 08:20'!
test04PopReturnsLastPushedObject

	| stack pushedObject |
	
	stack := OOStack new.
	pushedObject := 'Something'.
	stack push: pushedObject.
	
	self assert: stack pop = pushedObject! !

!OOStackTest methodsFor: 'test' stamp: 'HernanWilkinson 5/7/2012 11:33'!
test05StackBehavesLIFO

	| stack firstPushedObject secondPushedObject |
	
	stack := OOStack new.
	firstPushedObject := 'First'.
	secondPushedObject := 'Second'.
	
	stack push: firstPushedObject.
	stack push: secondPushedObject.
	
	self assert: stack pop = secondPushedObject.
	self assert: stack pop = firstPushedObject.
	self assert: stack isEmpty 
	! !

!OOStackTest methodsFor: 'test' stamp: 'HernanWilkinson 5/7/2012 11:35'!
test06TopReturnsLastPushedObject

	| stack pushedObject |
	
	stack := OOStack new.
	pushedObject := 'Something'.
	
	stack push: pushedObject.
	
	self assert: stack top = pushedObject.
	! !

!OOStackTest methodsFor: 'test' stamp: 'HernanWilkinson 5/7/2012 11:36'!
test07TopDoesNotRemoveObjectFromStack

	| stack pushedObject |
	
	stack := OOStack new.
	pushedObject := 'Something'.
	
	stack push: pushedObject.
	
	self assert: stack size = 1.
	stack top.
	self assert: stack size = 1.
	! !

!OOStackTest methodsFor: 'test' stamp: 'HAW 4/14/2017 22:48:26'!
test08CanNotPopWhenThereAreNoObjectsInTheStack

	| stack  |
	
	stack := OOStack new.
	self
		should: [ stack pop ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: anError messageText = OOStack stackEmptyErrorDescription ]
		
! !

!OOStackTest methodsFor: 'test' stamp: 'HAW 4/14/2017 22:48:36'!
test09CanNotPopWhenThereAreNoObjectsInTheStackAndTheStackHadObjects

	| stack  |
	
	stack := OOStack new.
	stack push: 'Something'.
	stack pop.
	
	self
		should: [ stack pop ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: anError messageText = OOStack stackEmptyErrorDescription ]
		
! !

!OOStackTest methodsFor: 'test' stamp: 'HAW 4/14/2017 22:48:44'!
test10CanNotTopWhenThereAreNoObjectsInTheStack

	| stack  |
	
	stack := OOStack new.
	self
		should: [ stack top ]
		raise: Error - MessageNotUnderstood 
		withExceptionDo: [ :anError |
			self assert: anError messageText = OOStack stackEmptyErrorDescription ]
		
! !


!classDefinition: #ImmutableStack category: #'Stack-Exercise'!
Object subclass: #ImmutableStack
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!ImmutableStack methodsFor: 'as yet unclassified' stamp: 'BAB 9/17/2017 11:24:32'!
bottom
	self subclassResponsibility.! !

!ImmutableStack methodsFor: 'as yet unclassified' stamp: 'BAB 9/16/2017 19:05:08'!
isEmpty
	self subclassResponsibility.! !

!ImmutableStack methodsFor: 'as yet unclassified' stamp: 'BAB 9/18/2017 11:36:20'!
push: anObjectToPush
	^ NonEmptyImmutableStack
		with: anObjectToPush
		onTopOf: self.! !

!ImmutableStack methodsFor: 'as yet unclassified' stamp: 'BAB 9/17/2017 11:19:28'!
size
	self subclassResponsibility.! !

!ImmutableStack methodsFor: 'as yet unclassified' stamp: 'BAB 9/16/2017 19:04:25'!
top
	self subclassResponsibility.! !


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

!EmptyImmutableStack methodsFor: 'as yet unclassified' stamp: 'BAB 9/17/2017 10:59:23'!
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


!classDefinition: #MutableStack category: #'Stack-Exercise'!
Stack subclass: #MutableStack
	instanceVariableNames: 'internalInmutableStack'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

!MutableStack methodsFor: 'as yet unclassified' stamp: 'BAB 9/18/2017 11:35:45'!
initialize
	internalInmutableStack _ EmptyImmutableStack new.! !

!MutableStack methodsFor: 'as yet unclassified' stamp: 'BAB 9/17/2017 10:55:14'!
isEmpty
	^ internalInmutableStack isEmpty.! !

!MutableStack methodsFor: 'as yet unclassified' stamp: 'BAB 9/17/2017 11:24:22'!
pop
	| topObject |
	topObject := internalInmutableStack top.
	internalInmutableStack := internalInmutableStack bottom.
	^ topObject .! !

!MutableStack methodsFor: 'as yet unclassified' stamp: 'BAB 9/17/2017 11:15:55'!
push: anObjectToPush
	internalInmutableStack := internalInmutableStack push: anObjectToPush .! !

!MutableStack methodsFor: 'as yet unclassified' stamp: 'BAB 9/17/2017 11:19:49'!
size
	^ internalInmutableStack size.! !

!MutableStack methodsFor: 'as yet unclassified' stamp: 'BAB 9/17/2017 11:16:09'!
top
	^ internalInmutableStack top.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MutableStack class' category: #'Stack-Exercise'!
MutableStack class
	instanceVariableNames: ''!

!MutableStack class methodsFor: 'error descriptions' stamp: 'BAB 9/17/2017 10:55:14'!
stackEmptyErrorDescription
	
	^ 'Stack is empty'! !


!MutableStack class methodsFor: 'as yet unclassified' stamp: 'BAB 9/17/2017 10:56:32'!
empty
	| emptyStack |
	emptyStack := self new.
	emptyStack initialize.
	^ emptyStack! !


!classDefinition: #OOStack category: #'Stack-Exercise'!
Stack subclass: #OOStack
	instanceVariableNames: 'internalInmutableStack'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Stack-Exercise'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'OOStack class' category: #'Stack-Exercise'!
OOStack class
	instanceVariableNames: ''!

!OOStack class methodsFor: 'error descriptions' stamp: 'HernanWilkinson 5/7/2012 11:51'!
stackEmptyErrorDescription
	
	^ 'Stack is empty'! !


!OOStack class methodsFor: 'as yet unclassified' stamp: 'BAB 9/17/2017 10:57:03'!
new
	| emptyStack |
	emptyStack := MutableStack new.
	emptyStack initialize.
	^ emptyStack! !
