!classDefinition: #ElevatorEmergency category: #'Elevator-Ejercicio'!
Error subclass: #ElevatorEmergency
	instanceVariableNames: 'message'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!


!classDefinition: #ElevatorTest category: #'Elevator-Ejercicio'!
TestCase subclass: #ElevatorTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!ElevatorTest methodsFor: 'tests 3' stamp: 'HernanWilkinson 7/10/2011 17:38'!
test09RequestToGoUpAreEnqueueWhenRequestedWhenCabinIsMoving

	| elevatorController |
	elevatorController := ElevatorController new.
	
	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinDoorClosed.
	elevatorController cabinOnFloor:1.
	elevatorController goUpPushedFromFloor:2.
	elevatorController cabinDoorOpened.

	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinWaitingForPeople.
	self assert: elevatorController isCabinDoorOpened.! !

!ElevatorTest methodsFor: 'tests 3' stamp: 'HernanWilkinson 7/10/2011 17:39'!
test10CabinDoorStartClosingAfterWaitingForPeople

	| elevatorController |
	elevatorController := ElevatorController new.
	
	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinDoorClosed.
	elevatorController cabinOnFloor:1.
	elevatorController goUpPushedFromFloor:2.
	elevatorController cabinDoorOpened.
	elevatorController waitForPeopleTimedOut.

	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorClosing.! !

!ElevatorTest methodsFor: 'tests 3' stamp: 'HernanWilkinson 7/10/2011 17:39'!
test11StopsWaitingForPeopleIfCloseDoorIsPressed

	| elevatorController |
	elevatorController := ElevatorController new.
	
	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinDoorClosed.
	elevatorController cabinOnFloor:1.
	elevatorController goUpPushedFromFloor:2.
	elevatorController cabinDoorOpened.

	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinWaitingForPeople.
	self assert: elevatorController isCabinDoorOpened.

	elevatorController closeCabinDoor.

	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorClosing.
! !

!ElevatorTest methodsFor: 'tests 3' stamp: 'HernanWilkinson 7/10/2011 17:39'!
test12CloseDoorDoesNothingIfIdle

	| elevatorController |
	elevatorController := ElevatorController new.
	
	elevatorController closeCabinDoor.

	self assert: elevatorController isIdle.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorOpened.! !

!ElevatorTest methodsFor: 'tests 3' stamp: 'HernanWilkinson 7/10/2011 17:40'!
test13CloseDoorDoesNothingWhenCabinIsMoving

	| elevatorController |
	elevatorController := ElevatorController new.
	
	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinDoorClosed.

	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinMoving.
	self assert: elevatorController isCabinDoorClosed.

	elevatorController closeCabinDoor.

	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinMoving.
	self assert: elevatorController isCabinDoorClosed.! !

!ElevatorTest methodsFor: 'tests 3' stamp: 'HernanWilkinson 7/10/2011 17:40'!
test14CloseDoorDoesNothingWhenOpeningTheDoorToWaitForPeople

	| elevatorController |
	elevatorController := ElevatorController new.
		
	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinDoorClosed.
	elevatorController cabinOnFloor:1.
	
	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorOpening.

	elevatorController closeCabinDoor.

	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorOpening.! !


!ElevatorTest methodsFor: 'tests 4' stamp: 'HernanWilkinson 7/10/2011 17:42'!
test15ElevatorHasToEnterEmergencyIfStoppedAndOtherFloorSensorTurnsOn

	| elevatorController |
	elevatorController := ElevatorController new.
	
	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinDoorClosed.
	elevatorController cabinOnFloor:1.
	self 
		should: [ elevatorController cabinOnFloor:0 ]
		raise: ElevatorEmergency 
		withExceptionDo: [ :elevatorEmergency | self assert: elevatorEmergency messageText = 'Sensor de cabina desincronizado' ]! !

!ElevatorTest methodsFor: 'tests 4' stamp: 'HernanWilkinson 7/10/2011 17:47'!
test16ElevatorHasToEnterEmergencyIfFalling

	| elevatorController |
	elevatorController := ElevatorController new.
	
	elevatorController goUpPushedFromFloor:2.
	elevatorController cabinDoorClosed.
	elevatorController cabinOnFloor:1.
	self 
		should: [ elevatorController cabinOnFloor:0 ]
		raise: ElevatorEmergency 
		withExceptionDo: [ :elevatorEmergency | self assert: elevatorEmergency messageText = 'Sensor de cabina desincronizado'. ]! !

!ElevatorTest methodsFor: 'tests 4' stamp: 'HernanWilkinson 7/10/2011 17:47'!
test17ElevatorHasToEnterEmergencyIfJumpsFloors

	| elevatorController |
	elevatorController := ElevatorController new.
	
	elevatorController goUpPushedFromFloor:3.
	elevatorController cabinDoorClosed.
	self 
		should: [ elevatorController cabinOnFloor: 3 ]
		raise: ElevatorEmergency 
		withExceptionDo: [ :elevatorEmergency | self assert: elevatorEmergency messageText = 'Sensor de cabina desincronizado'. ]! !

!ElevatorTest methodsFor: 'tests 4' stamp: 'HernanWilkinson 7/10/2011 17:48'!
test18ElevatorHasToEnterEmergencyIfDoorClosesAutomatically
	| elevatorController |
	elevatorController := ElevatorController new.
	
	self 
		should: [ elevatorController cabinDoorClosed.]
		raise: ElevatorEmergency 
		withExceptionDo: [ :elevatorEmergency | self assert: elevatorEmergency messageText = 'Sensor de puerta desincronizado' ]! !

!ElevatorTest methodsFor: 'tests 4' stamp: 'HernanWilkinson 7/10/2011 17:48'!
test19ElevatorHasToEnterEmergencyIfDoorClosedSensorTurnsOnWhenClosed

	| elevatorController |
	elevatorController := ElevatorController new.
	
	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinDoorClosed.
	self 
		should: [elevatorController cabinDoorClosed.]
		raise: ElevatorEmergency 
		withExceptionDo: [ :elevatorEmergency | self assert: elevatorEmergency messageText = 'Sensor de puerta desincronizado'. ]! !

!ElevatorTest methodsFor: 'tests 4' stamp: 'HernanWilkinson 7/10/2011 17:49'!
test20ElevatorHasToEnterEmergencyIfDoorClosesWhenOpening
	| elevatorController |
	elevatorController := ElevatorController new.
		
	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinDoorClosed.
	elevatorController cabinOnFloor:1.
	self 
		should: [elevatorController cabinDoorClosed.]
		raise: ElevatorEmergency 
		withExceptionDo: [ :elevatorEmergency | self assert: elevatorEmergency messageText = 'Sensor de puerta desincronizado'.]! !


!ElevatorTest methodsFor: 'tests 2' stamp: 'HernanWilkinson 7/10/2011 17:35'!
test06DoorKeepsOpenedWhenOpeningIsRequested

	| elevatorController |
	elevatorController := ElevatorController new.
	
	self assert: elevatorController isCabinDoorOpened.
	
	elevatorController openCabinDoor.

	self assert: elevatorController isCabinDoorOpened.! !

!ElevatorTest methodsFor: 'tests 2' stamp: 'HernanWilkinson 6/16/2014 13:24'!
test07DoorMustBeOpenedWhenCabinIsStoppedAndClosingDoors

	| elevatorController |
	elevatorController := ElevatorController new.

	elevatorController goUpPushedFromFloor:1.
		
	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorClosing.
		
	elevatorController openCabinDoor.
	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorOpening.
! !

!ElevatorTest methodsFor: 'tests 2' stamp: 'HernanWilkinson 7/10/2011 17:36'!
test08CanNotOpenDoorWhenCabinIsMoving

	| elevatorController |
	elevatorController := ElevatorController new.

	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinDoorClosed.
	
	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinMoving.
	self assert: elevatorController isCabinDoorClosed.

	elevatorController openCabinDoor.
	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinMoving.
	self assert: elevatorController isCabinDoorClosed.! !

!ElevatorTest methodsFor: 'tests 2' stamp: 'HernanWilkinson 7/10/2011 17:51'!
test09DoorKeepsOpeneingWhenItIsOpeneing

	| elevatorController |
	elevatorController := ElevatorController new.

	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinDoorClosed.
	elevatorController cabinOnFloor:1.

	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorOpening.

	elevatorController openCabinDoor.
	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorOpening.! !


!ElevatorTest methodsFor: 'tests 5' stamp: 'HernanWilkinson 7/10/2011 17:50'!
test21CabinHasToStopOnTheFloorsOnItsWay
	| elevatorController |
	elevatorController := ElevatorController new.
	
	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinDoorClosed.
	elevatorController goUpPushedFromFloor:2.
	elevatorController cabinOnFloor:1.

	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorOpening.! !

!ElevatorTest methodsFor: 'tests 5' stamp: 'HernanWilkinson 7/10/2011 17:50'!
test22ElevatorCompletesAllTheRequests
	| elevatorController |
	elevatorController := ElevatorController new.
	
	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinDoorClosed.
	elevatorController goUpPushedFromFloor:2.
	elevatorController cabinOnFloor:1.
	elevatorController cabinDoorOpened.
	elevatorController waitForPeopleTimedOut.
	elevatorController cabinDoorClosed.
	elevatorController cabinOnFloor:2.
	
	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorOpening.! !

!ElevatorTest methodsFor: 'tests 5' stamp: 'HernanWilkinson 7/10/2011 17:50'!
test23CabinHasToStopOnFloorsOnItsWayNoMatterHowTheyWellCalled

	| elevatorController |
	elevatorController := ElevatorController new.
		
	elevatorController goUpPushedFromFloor:2.
	elevatorController cabinDoorClosed.
	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinOnFloor:1.
		
	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorOpening.! !

!ElevatorTest methodsFor: 'tests 5' stamp: 'HernanWilkinson 7/10/2011 17:51'!
test24CabinHasToStopAndWaitForPeopleOnFloorsOnItsWayNoMatterHowTheyWellCalled

	| elevatorController |
	elevatorController := ElevatorController new.
	
	elevatorController goUpPushedFromFloor:2.
	elevatorController cabinDoorClosed.
	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinOnFloor:1.
	elevatorController cabinDoorOpened.
	elevatorController waitForPeopleTimedOut.
	
	self assert: elevatorController isWorking.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorClosing.! !


!ElevatorTest methodsFor: 'tests 1' stamp: 'HernanWilkinson 7/10/2011 17:33'!
test01ElevatorStartsIdleWithDoorOpenOnFloorZero

	| elevatorController |
		
	elevatorController := ElevatorController new.
		
	self assert: elevatorController isIdle.
	self assert: elevatorController isCabinStopped.
	self assert: elevatorController isCabinDoorOpened.
	self assert: elevatorController cabinFloorNumber = 0
! !

!ElevatorTest methodsFor: 'tests 1' stamp: 'HernanWilkinson 7/15/2011 17:53'!
test02CabinDoorStartsClosingWhenElevatorGetsCalled

	| elevatorController |
	elevatorController := ElevatorController new.

	elevatorController goUpPushedFromFloor: 1.
	
	self deny: elevatorController isIdle.
	self assert: elevatorController isWorking.
	
	self assert: elevatorController isCabinStopped.
	self deny: elevatorController isCabinMoving.
	
	self deny: elevatorController isCabinDoorOpened.
	self deny: elevatorController isCabinDoorOpening.
	self assert: elevatorController isCabinDoorClosing.
	self deny: elevatorController isCabinDoorClosed.! !

!ElevatorTest methodsFor: 'tests 1' stamp: 'HernanWilkinson 7/15/2011 17:57'!
test03CabinStartsMovingWhenDoorGetsClosed

	| elevatorController |
	elevatorController := ElevatorController new.

	elevatorController goUpPushedFromFloor:1.
	elevatorController cabinDoorClosed.
	
	self deny: elevatorController isIdle.
	self assert: elevatorController isWorking.

	self deny: elevatorController isCabinStopped.
	self assert: elevatorController isCabinMoving.
	
	self deny: elevatorController isCabinDoorOpened.
	self deny: elevatorController isCabinDoorOpening.
	self deny: elevatorController isCabinDoorClosing.
	self assert: elevatorController isCabinDoorClosed.! !

!ElevatorTest methodsFor: 'tests 1' stamp: 'HernanWilkinson 7/15/2011 18:00'!
test04CabinStopsAndStartsOpeningDoorWhenGetsToDestination

	| elevatorController |
	elevatorController := ElevatorController new.

	elevatorController goUpPushedFromFloor: 1.
	elevatorController cabinDoorClosed.
	elevatorController cabinOnFloor: 1.

	self deny: elevatorController isIdle.
	self assert: elevatorController isWorking.
	
	self assert: elevatorController isCabinStopped.
	self deny: elevatorController isCabinMoving.
			
	self deny: elevatorController isCabinDoorOpened.
	self assert: elevatorController isCabinDoorOpening.
	self deny: elevatorController isCabinDoorClosing.
	self deny: elevatorController isCabinDoorClosed.

	self assert: elevatorController cabinFloorNumber = 1
! !

!ElevatorTest methodsFor: 'tests 1' stamp: 'HernanWilkinson 7/15/2011 18:00'!
test05ElevatorGetsIdleWhenDoorGetOpened

	| elevatorController |
	elevatorController := ElevatorController new.
	
	elevatorController goUpPushedFromFloor: 1.
	elevatorController cabinDoorClosed.
	elevatorController cabinOnFloor: 1.
	elevatorController cabinDoorOpened.
		
	self assert: elevatorController isIdle.
	self deny: elevatorController isWorking.
		
	self assert: elevatorController isCabinStopped.
	self deny: elevatorController isCabinMoving.

	self assert: elevatorController isCabinDoorOpened.
	self deny: elevatorController isCabinDoorOpening.
	self deny: elevatorController isCabinDoorClosing.
	self deny: elevatorController isCabinDoorClosed.
		
	self assert: elevatorController cabinFloorNumber = 1! !


!classDefinition: #CabinDoorState category: #'Elevator-Ejercicio'!
Object subclass: #CabinDoorState
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!CabinDoorState methodsFor: 'as yet unclassified' stamp: 'BAB 10/10/2017 23:24:36'!
cabinDoorClosedForController: aController
	self subclassResponsibility.! !

!CabinDoorState methodsFor: 'as yet unclassified' stamp: 'BAB 10/10/2017 23:44:04'!
isCabinDoorClosed
	self subclassResponsibility.! !

!CabinDoorState methodsFor: 'as yet unclassified' stamp: 'BAB 10/10/2017 23:44:34'!
isCabinDoorClosing
	self subclassResponsibility.! !

!CabinDoorState methodsFor: 'as yet unclassified' stamp: 'BAB 10/10/2017 23:48:01'!
isCabinDoorOpen
	self subclassResponsibility.! !

!CabinDoorState methodsFor: 'as yet unclassified' stamp: 'BAB 10/10/2017 23:44:17'!
isCabinDoorOpening
	self subclassResponsibility.! !


!classDefinition: #ClosedCabinDoorState category: #'Elevator-Ejercicio'!
CabinDoorState subclass: #ClosedCabinDoorState
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!ClosedCabinDoorState methodsFor: 'as yet unclassified' stamp: 'BAB 10/10/2017 23:27:27'!
cabinDoorClosedForController: aController
	ElevatorEmergency signal: 'Sensor de puerta desincronizado'.! !

!ClosedCabinDoorState methodsFor: 'as yet unclassified' stamp: 'BAB 10/10/2017 23:48:32'!
isCabinDoorClosed
	^ true.! !

!ClosedCabinDoorState methodsFor: 'as yet unclassified' stamp: 'BAB 10/10/2017 23:48:46'!
isCabinDoorClosing
	^ false.! !

!ClosedCabinDoorState methodsFor: 'as yet unclassified' stamp: 'BAB 10/10/2017 23:48:40'!
isCabinDoorOpen
	^ false.! !

!ClosedCabinDoorState methodsFor: 'as yet unclassified' stamp: 'BAB 10/10/2017 23:48:43'!
isCabinDoorOpening
	^ false.! !


!classDefinition: #ClosingCabinDoorState category: #'Elevator-Ejercicio'!
CabinDoorState subclass: #ClosingCabinDoorState
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!ClosingCabinDoorState methodsFor: 'as yet unclassified' stamp: 'BAB 10/10/2017 23:33:16'!
cabinDoorClosedForController: aController
	aController changeCabinDoorStateFor: ClosedCabinDoorState new.! !

!ClosingCabinDoorState methodsFor: 'as yet unclassified' stamp: 'BAB 10/10/2017 23:48:55'!
isCabinDoorClosed
	^ false! !

!ClosingCabinDoorState methodsFor: 'as yet unclassified' stamp: 'BAB 10/10/2017 23:49:05'!
isCabinDoorClosing
	^ true! !

!ClosingCabinDoorState methodsFor: 'as yet unclassified' stamp: 'BAB 10/10/2017 23:49:13'!
isCabinDoorOpen
	^ false! !

!ClosingCabinDoorState methodsFor: 'as yet unclassified' stamp: 'BAB 10/10/2017 23:49:17'!
isCabinDoorOpening
	^ false! !


!classDefinition: #OpenCabinDoorState category: #'Elevator-Ejercicio'!
CabinDoorState subclass: #OpenCabinDoorState
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!OpenCabinDoorState methodsFor: 'as yet unclassified' stamp: 'BAB 10/10/2017 23:44:51'!
cabinDoorClosedForController: aController
	ElevatorEmergency signal: 'Sensor de puerta desincronizado'.! !

!OpenCabinDoorState methodsFor: 'as yet unclassified' stamp: 'BAB 10/10/2017 23:45:55'!
isCabinDoorClosed
	^ false.! !

!OpenCabinDoorState methodsFor: 'as yet unclassified' stamp: 'BAB 10/10/2017 23:45:59'!
isCabinDoorClosing
	^ false.! !

!OpenCabinDoorState methodsFor: 'as yet unclassified' stamp: 'BAB 10/10/2017 23:49:38'!
isCabinDoorOpen
	^ true.! !

!OpenCabinDoorState methodsFor: 'as yet unclassified' stamp: 'BAB 10/10/2017 23:46:03'!
isCabinDoorOpening
	^ false.! !


!classDefinition: #OpeningCabinDoorState category: #'Elevator-Ejercicio'!
CabinDoorState subclass: #OpeningCabinDoorState
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!OpeningCabinDoorState methodsFor: 'as yet unclassified' stamp: 'BAB 10/10/2017 23:44:46'!
cabinDoorClosedForController: aController
	ElevatorEmergency signal: 'Sensor de puerta desincronizado'.! !

!OpeningCabinDoorState methodsFor: 'as yet unclassified' stamp: 'BAB 10/10/2017 23:45:38'!
isCabinDoorClosed
	^ false.! !

!OpeningCabinDoorState methodsFor: 'as yet unclassified' stamp: 'BAB 10/10/2017 23:45:40'!
isCabinDoorClosing
	^ false.! !

!OpeningCabinDoorState methodsFor: 'as yet unclassified' stamp: 'BAB 10/10/2017 23:48:01'!
isCabinDoorOpen
	^ false.! !

!OpeningCabinDoorState methodsFor: 'as yet unclassified' stamp: 'BAB 10/10/2017 23:45:20'!
isCabinDoorOpening
	^ true.! !


!classDefinition: #ElevatorController category: #'Elevator-Ejercicio'!
Object subclass: #ElevatorController
	instanceVariableNames: 'state cabinState cabinDoorState cabinFloorNumber floorsToGo destination'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!ElevatorController methodsFor: 'accessing' stamp: 'asdf 10/2/2017 18:41:20'!
cabinFloorNumber
	^cabinFloorNumber! !

!ElevatorController methodsFor: 'accessing' stamp: 'BAB 10/10/2017 23:43:46'!
isCabinDoorClosed
	^ cabinDoorState isCabinDoorClosed! !

!ElevatorController methodsFor: 'accessing' stamp: 'BAB 10/10/2017 23:50:03'!
isCabinDoorClosing
	^ cabinDoorState isCabinDoorClosing! !

!ElevatorController methodsFor: 'accessing' stamp: 'BAB 10/10/2017 23:50:12'!
isCabinDoorOpened
	^ cabinDoorState isCabinDoorOpen! !

!ElevatorController methodsFor: 'accessing' stamp: 'BAB 10/10/2017 23:50:21'!
isCabinDoorOpening
	^ cabinDoorState isCabinDoorOpening! !

!ElevatorController methodsFor: 'accessing' stamp: 'asdf 10/2/2017 20:16:59'!
isCabinMoving
	^ cabinState = 'moving'! !

!ElevatorController methodsFor: 'accessing' stamp: 'asdf 10/2/2017 19:51:52'!
isCabinStopped
	^ cabinState = 'stopped'! !

!ElevatorController methodsFor: 'accessing' stamp: 'asdf 10/2/2017 20:24:20'!
isCabinWaitingForPeople
	^ true! !

!ElevatorController methodsFor: 'accessing' stamp: 'asdf 10/2/2017 19:47:19'!
isIdle
	^ state = 'idle'! !

!ElevatorController methodsFor: 'accessing' stamp: 'asdf 10/2/2017 20:03:33'!
isWorking
	^ (state = 'idle') not! !


!ElevatorController methodsFor: 'evaluating' stamp: 'BAB 10/10/2017 23:27:59'!
cabinDoorClosed
	cabinDoorState cabinDoorClosedForController: self.
	state = 'floorPressed' ifTrue: [cabinState := 'moving'].
	! !

!ElevatorController methodsFor: 'evaluating' stamp: 'BAB 10/10/2017 23:38:27'!
cabinDoorOpened
	(state = 'reachedFloor' and: [cabinFloorNumber = destination]) ifTrue: [ state := 'idle' ].
	cabinDoorState := OpenCabinDoorState new.! !

!ElevatorController methodsFor: 'evaluating' stamp: 'BAB 10/10/2017 23:37:47'!
cabinOnFloor: aFloorNumber
	((cabinFloorNumber + 1) = aFloorNumber  ) ifFalse: [ElevatorEmergency signal: 'Sensor de cabina desincronizado'].
	state := 'reachedFloor'.
	cabinDoorState := OpeningCabinDoorState new.
	cabinState := 'stopped'.
	cabinFloorNumber := aFloorNumber! !

!ElevatorController methodsFor: 'evaluating' stamp: 'BAB 10/10/2017 23:33:16'!
changeCabinDoorStateFor: aCabinDoorState
	cabinDoorState _ aCabinDoorState.! !

!ElevatorController methodsFor: 'evaluating' stamp: 'BAB 10/10/2017 23:36:48'!
closeCabinDoor
	(state = 'idle' or: state = 'reachedFloor' or: cabinState = 'moving') not ifTrue: [ cabinDoorState := ClosingCabinDoorState new]! !

!ElevatorController methodsFor: 'evaluating' stamp: 'BAB 10/10/2017 23:38:57'!
goUpPushedFromFloor: aFloorNumber 
	cabinDoorState := ClosingCabinDoorState new.
	state := 'floorPressed'.
	destination := destination max: aFloorNumber.! !

!ElevatorController methodsFor: 'evaluating' stamp: 'BAB 10/10/2017 23:51:11'!
openCabinDoor
	(cabinState = 'stopped' and: (cabinDoorState isCabinDoorOpen) not) ifTrue: [cabinDoorState := OpeningCabinDoorState new]! !

!ElevatorController methodsFor: 'evaluating' stamp: 'BAB 10/10/2017 23:42:39'!
waitForPeopleTimedOut
	cabinDoorState := ClosingCabinDoorState new.! !


!ElevatorController methodsFor: 'initialization' stamp: 'BAB 10/10/2017 23:39:20'!
initialize
	cabinFloorNumber := 0.
	state := 'idle'.
	cabinState := 'stopped'.
	cabinDoorState  := OpenCabinDoorState new.
	destination := 0.! !
