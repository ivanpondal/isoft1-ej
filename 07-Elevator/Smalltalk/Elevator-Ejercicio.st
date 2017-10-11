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

!CabinDoorState methodsFor: 'as yet unclassified' stamp: 'BAB 10/11/2017 11:53:30'!
openCabinDoorWithCabinStoppedForController: aController
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

!ClosedCabinDoorState methodsFor: 'as yet unclassified' stamp: 'BAB 10/11/2017 12:01:28'!
openCabinDoorWithCabinStoppedForController: aController
	aController changeCabinDoorStateFor: OpeningCabinDoorState new..! !


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

!ClosingCabinDoorState methodsFor: 'as yet unclassified' stamp: 'BAB 10/11/2017 12:01:17'!
openCabinDoorWithCabinStoppedForController: aController
	aController changeCabinDoorStateFor: OpeningCabinDoorState new.! !


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

!OpenCabinDoorState methodsFor: 'as yet unclassified' stamp: 'BAB 10/11/2017 12:01:07'!
openCabinDoorWithCabinStoppedForController: aController
	! !


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

!OpeningCabinDoorState methodsFor: 'as yet unclassified' stamp: 'BAB 10/11/2017 12:00:33'!
openCabinDoorWithCabinStoppedForController: aController
	'is already opening' ! !


!classDefinition: #CabinState category: #'Elevator-Ejercicio'!
Object subclass: #CabinState
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!CabinState methodsFor: 'as yet unclassified' stamp: 'BAB 10/11/2017 12:46:45'!
closeCabinDoorForController: aController
	self subclassResponsibility.! !

!CabinState methodsFor: 'as yet unclassified' stamp: 'BAB 10/11/2017 12:05:03'!
isCabinMoving
	self subclassResponsibility.! !

!CabinState methodsFor: 'as yet unclassified' stamp: 'BAB 10/11/2017 12:05:09'!
isCabinStopped
	self subclassResponsibility.! !

!CabinState methodsFor: 'as yet unclassified' stamp: 'BAB 10/11/2017 11:52:37'!
openCabinDoorForController: aController
	self subclassResponsibility.! !


!classDefinition: #MovingCabinState category: #'Elevator-Ejercicio'!
CabinState subclass: #MovingCabinState
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!MovingCabinState methodsFor: 'as yet unclassified' stamp: 'BAB 10/11/2017 12:46:12'!
closeCabinDoorForController: aController
	! !

!MovingCabinState methodsFor: 'as yet unclassified' stamp: 'BAB 10/11/2017 12:08:10'!
isCabinMoving
	^ true! !

!MovingCabinState methodsFor: 'as yet unclassified' stamp: 'BAB 10/11/2017 12:08:21'!
isCabinStopped
	^ false! !

!MovingCabinState methodsFor: 'as yet unclassified' stamp: 'BAB 10/11/2017 12:07:59'!
openCabinDoorForController: aController
	! !


!classDefinition: #StoppedCabinState category: #'Elevator-Ejercicio'!
CabinState subclass: #StoppedCabinState
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!StoppedCabinState methodsFor: 'as yet unclassified' stamp: 'BAB 10/11/2017 12:47:15'!
closeCabinDoorForController: aController
	aController closeCabinDoorWithCabinNotMoving.
! !

!StoppedCabinState methodsFor: 'as yet unclassified' stamp: 'BAB 10/11/2017 12:08:32'!
isCabinMoving
	^ false.! !

!StoppedCabinState methodsFor: 'as yet unclassified' stamp: 'BAB 10/11/2017 12:08:40'!
isCabinStopped
	^ true.! !

!StoppedCabinState methodsFor: 'as yet unclassified' stamp: 'BAB 10/11/2017 11:47:57'!
openCabinDoorForController: aController
	aController openCabinDoorWithCabinStopped.! !


!classDefinition: #ElevatorController category: #'Elevator-Ejercicio'!
Object subclass: #ElevatorController
	instanceVariableNames: 'cabinState cabinDoorState cabinFloorNumber floorsToGo destination elevatorState'
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

!ElevatorController methodsFor: 'accessing' stamp: 'BAB 10/11/2017 12:09:47'!
isCabinMoving
	^ cabinState  isCabinMoving! !

!ElevatorController methodsFor: 'accessing' stamp: 'BAB 10/11/2017 12:04:12'!
isCabinStopped
	^ cabinState isCabinStopped! !

!ElevatorController methodsFor: 'accessing' stamp: 'asdf 10/2/2017 20:24:20'!
isCabinWaitingForPeople
	^ true! !

!ElevatorController methodsFor: 'accessing' stamp: 'BAB 10/11/2017 12:56:45'!
isIdle
	^ elevatorState isIdle.! !

!ElevatorController methodsFor: 'accessing' stamp: 'BAB 10/11/2017 12:27:37'!
isWorking
	^ (self isIdle) not! !


!ElevatorController methodsFor: 'evaluating' stamp: 'BAB 10/11/2017 12:56:45'!
cabinDoorClosed
	cabinDoorState cabinDoorClosedForController: self.
	elevatorState cabinDoorClosedForController: self.! !

!ElevatorController methodsFor: 'evaluating' stamp: 'BAB 10/11/2017 12:56:45'!
cabinDoorOpened
	cabinFloorNumber = destination ifTrue: [ elevatorState cabinDoorOpenedOnDestinationForController: self ].
	cabinDoorState _ OpenCabinDoorState new.! !

!ElevatorController methodsFor: 'evaluating' stamp: 'BAB 10/11/2017 12:56:45'!
cabinOnFloor: aFloorNumber
	cabinFloorNumber + 1 = aFloorNumber ifFalse: [ ElevatorEmergency signal: 'Sensor de cabina desincronizado' ].
	elevatorState _ ReachedFloorElevatorState new.
	cabinDoorState _ OpeningCabinDoorState new.
	cabinState _ StoppedCabinState new.
	cabinFloorNumber _ aFloorNumber.! !

!ElevatorController methodsFor: 'evaluating' stamp: 'BAB 10/10/2017 23:33:16'!
changeCabinDoorStateFor: aCabinDoorState
	cabinDoorState _ aCabinDoorState.! !

!ElevatorController methodsFor: 'evaluating' stamp: 'BAB 10/11/2017 12:14:37'!
changeCabinStateFor: aCabinState
	cabinState _ aCabinState.! !

!ElevatorController methodsFor: 'evaluating' stamp: 'BAB 10/11/2017 12:56:45'!
changeElevatorStateFor: anElevatorState
	elevatorState _ anElevatorState.! !

!ElevatorController methodsFor: 'evaluating' stamp: 'BAB 10/11/2017 12:38:06'!
closeCabinDoor
	cabinState closeCabinDoorForController: self.! !

!ElevatorController methodsFor: 'evaluating' stamp: 'BAB 10/11/2017 12:56:45'!
closeCabinDoorWithCabinNotMoving
	elevatorState closeCabinDoorWithCabinNotMovingForController: self.! !

!ElevatorController methodsFor: 'evaluating' stamp: 'BAB 10/11/2017 12:56:45'!
goUpPushedFromFloor: aFloorNumber
	cabinDoorState _ ClosingCabinDoorState new.
	elevatorState _ FloorPressedElevatorState new.
	destination _ destination max: aFloorNumber.! !

!ElevatorController methodsFor: 'evaluating' stamp: 'BAB 10/11/2017 11:46:40'!
openCabinDoor
	cabinState openCabinDoorForController: self.! !

!ElevatorController methodsFor: 'evaluating' stamp: 'BAB 10/11/2017 11:59:11'!
openCabinDoorWithCabinStopped
	cabinDoorState openCabinDoorWithCabinStoppedForController: self.! !

!ElevatorController methodsFor: 'evaluating' stamp: 'BAB 10/10/2017 23:42:39'!
waitForPeopleTimedOut
	cabinDoorState := ClosingCabinDoorState new.! !


!ElevatorController methodsFor: 'initialization' stamp: 'BAB 10/11/2017 12:56:45'!
initialize
	cabinFloorNumber _ 0.
	elevatorState _ IdleElevatorState new.
	cabinState _ StoppedCabinState new.
	cabinDoorState _ OpenCabinDoorState new.
	destination _ 0.! !


!classDefinition: #ElevatorState category: #'Elevator-Ejercicio'!
Object subclass: #ElevatorState
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!ElevatorState methodsFor: 'as yet unclassified' stamp: 'BAB 10/11/2017 12:15:53'!
cabinDoorClosedForController: aController
	self subclassResponsibility.! !

!ElevatorState methodsFor: 'as yet unclassified' stamp: 'BAB 10/11/2017 12:18:23'!
cabinDoorOpenedOnDestinationForController: aController
	self subclassResponsibility.! !

!ElevatorState methodsFor: 'as yet unclassified' stamp: 'BAB 10/11/2017 12:47:52'!
closeCabinDoorWithCabinNotMovingForController: aController
	self subclassResponsibility.! !

!ElevatorState methodsFor: 'as yet unclassified' stamp: 'BAB 10/11/2017 12:53:41'!
isIdle
	self subclassResponsibility.! !


!classDefinition: #FloorPressedElevatorState category: #'Elevator-Ejercicio'!
ElevatorState subclass: #FloorPressedElevatorState
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!FloorPressedElevatorState methodsFor: 'as yet unclassified' stamp: 'BAB 10/11/2017 13:05:03'!
cabinDoorClosedForController: aController
	aController changeCabinStateFor: MovingCabinState new.! !

!FloorPressedElevatorState methodsFor: 'as yet unclassified' stamp: 'BAB 10/11/2017 12:52:07'!
cabinDoorOpenedOnDestinationForController: aController
! !

!FloorPressedElevatorState methodsFor: 'as yet unclassified' stamp: 'BAB 10/11/2017 12:49:13'!
closeCabinDoorWithCabinNotMovingForController: aController
	aController changeCabinDoorStateFor: ClosingCabinDoorState new.
	! !

!FloorPressedElevatorState methodsFor: 'as yet unclassified' stamp: 'BAB 10/11/2017 12:53:06'!
isIdle
	^ false	! !


!classDefinition: #IdleElevatorState category: #'Elevator-Ejercicio'!
ElevatorState subclass: #IdleElevatorState
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!IdleElevatorState methodsFor: 'as yet unclassified' stamp: 'BAB 10/11/2017 12:51:02'!
cabinDoorClosedForController: aController
		! !

!IdleElevatorState methodsFor: 'as yet unclassified' stamp: 'BAB 10/11/2017 12:51:24'!
cabinDoorOpenedOnDestinationForController: aController		! !

!IdleElevatorState methodsFor: 'as yet unclassified' stamp: 'BAB 10/11/2017 12:49:50'!
closeCabinDoorWithCabinNotMovingForController: aController
	! !

!IdleElevatorState methodsFor: 'as yet unclassified' stamp: 'BAB 10/11/2017 12:53:24'!
isIdle
	^ true	! !


!classDefinition: #ReachedFloorElevatorState category: #'Elevator-Ejercicio'!
ElevatorState subclass: #ReachedFloorElevatorState
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!ReachedFloorElevatorState methodsFor: 'as yet unclassified' stamp: 'BAB 10/11/2017 12:15:39'!
cabinDoorClosedForController: aController
	aController changeCabinStateFor: MovingCabinState new.! !

!ReachedFloorElevatorState methodsFor: 'as yet unclassified' stamp: 'BAB 10/11/2017 12:18:48'!
cabinDoorOpenedOnDestinationForController: aController
	aController changeElevatorStateFor: IdleElevatorState new.! !

!ReachedFloorElevatorState methodsFor: 'as yet unclassified' stamp: 'BAB 10/11/2017 12:50:07'!
closeCabinDoorWithCabinNotMovingForController: aController
	! !

!ReachedFloorElevatorState methodsFor: 'as yet unclassified' stamp: 'BAB 10/11/2017 12:53:33'!
isIdle
	^ false	! !
