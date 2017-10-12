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


!classDefinition: #Cabin category: #'Elevator-Ejercicio'!
Object subclass: #Cabin
	instanceVariableNames: 'state door currentFloorNumber'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!Cabin methodsFor: 'as yet unclassified' stamp: 'HW 10/12/2017 00:36:51'!
initialize
	state _ CabinStopped new.
	door _ Door new.
	currentFloorNumber _ 0.! !


!Cabin methodsFor: 'accessing' stamp: 'HW 10/12/2017 00:37:12'!
floorNumber
	^ currentFloorNumber ! !

!Cabin methodsFor: 'accessing' stamp: 'asdf 10/11/2017 21:00:44'!
isDoorClosed
	^ door isClosed.! !

!Cabin methodsFor: 'accessing' stamp: 'asdf 10/11/2017 20:59:48'!
isDoorClosing
	^ door isClosing.! !

!Cabin methodsFor: 'accessing' stamp: 'asdf 10/11/2017 20:12:30'!
isDoorOpen
	^ door isOpen! !

!Cabin methodsFor: 'accessing' stamp: 'asdf 10/11/2017 20:59:18'!
isDoorOpening
	^ door isOpening.! !

!Cabin methodsFor: 'accessing' stamp: 'HW 10/12/2017 00:33:01'!
isMoving
	^ state isMoving! !

!Cabin methodsFor: 'accessing' stamp: 'HW 10/12/2017 00:32:55'!
isStopped
	^ state isStopped! !

!Cabin methodsFor: 'accessing' stamp: 'BAB 10/12/2017 12:28:02'!
isWaitingForPeople
	^ state isWaitingForPeople.! !


!Cabin methodsFor: 'evaluating' stamp: 'HW 10/12/2017 01:06:05'!
changeStateTo: aCabinState
	state _ aCabinState.! !

!Cabin methodsFor: 'evaluating' stamp: 'HW 10/12/2017 00:43:11'!
closeDoor
	state closeDoorFor: self with: door.! !

!Cabin methodsFor: 'evaluating' stamp: 'HW 10/12/2017 00:52:46'!
goUp
	state goUpFor: self with: door.! !

!Cabin methodsFor: 'evaluating' stamp: 'HW 10/12/2017 01:12:38'!
openDoor
	state openFor: self with: door.! !

!Cabin methodsFor: 'evaluating' stamp: 'BAB 10/12/2017 13:17:57'!
reachedFloor: aFloorNumber
	(aFloorNumber = (currentFloorNumber + 1)) ifFalse: [ElevatorEmergency signal: 'Sensor de cabina desincronizado'].
	currentFloorNumber _ aFloorNumber.! !

!Cabin methodsFor: 'evaluating' stamp: 'HW 10/12/2017 01:11:57'!
stop
	state stopFor: self with: door.! !

!Cabin methodsFor: 'evaluating' stamp: 'HW 10/12/2017 01:36:29'!
waitForPeople
	state waitForPeopleFor: self with: door. ! !


!classDefinition: #CabinState category: #'Elevator-Ejercicio'!
Object subclass: #CabinState
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!CabinState methodsFor: 'accessing' stamp: 'HW 10/12/2017 00:45:47'!
isMoving
	self subclassResponsibility ! !

!CabinState methodsFor: 'accessing' stamp: 'HW 10/12/2017 00:35:53'!
isStopped
	self subclassResponsibility ! !

!CabinState methodsFor: 'accessing' stamp: 'BAB 10/12/2017 12:28:21'!
isWaitingForPeople
	self subclassResponsibility ! !


!CabinState methodsFor: 'evaluating' stamp: 'BAB 10/12/2017 12:44:49'!
closeDoorFor: aCabin with: aDoor 
	self subclassResponsibility.! !

!CabinState methodsFor: 'evaluating' stamp: 'HW 10/12/2017 00:53:02'!
goUpFor: aCabin with: aDoor 
	self subclassResponsibility ! !

!CabinState methodsFor: 'evaluating' stamp: 'HW 10/12/2017 01:13:52'!
openFor: aCabin with: aDoor 
	self subclassResponsibility ! !

!CabinState methodsFor: 'evaluating' stamp: 'HW 10/12/2017 01:13:08'!
stopFor: aCabin with: aDoor 
	self subclassResponsibility ! !

!CabinState methodsFor: 'evaluating' stamp: 'HW 10/12/2017 01:36:49'!
waitForPeopleFor: aCabin with: aDoor 
	self subclassResponsibility ! !


!classDefinition: #CabinMoving category: #'Elevator-Ejercicio'!
CabinState subclass: #CabinMoving
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!CabinMoving methodsFor: 'accessing' stamp: 'HW 10/12/2017 01:07:08'!
isMoving
	^ true! !

!CabinMoving methodsFor: 'accessing' stamp: 'HW 10/12/2017 01:06:57'!
isStopped
	^ false! !


!CabinMoving methodsFor: 'evaluating' stamp: 'BAB 10/12/2017 12:57:08'!
closeDoorFor: aCabin with: aDoor 
	! !

!CabinMoving methodsFor: 'evaluating' stamp: 'BAB 10/12/2017 13:29:24'!
goUpFor: aCabin with: aDoor 
	aDoor closed.! !

!CabinMoving methodsFor: 'evaluating' stamp: 'HW 10/12/2017 01:13:39'!
stopFor: aCabin with: aDoor 
	aCabin changeStateTo: CabinStopped new.! !


!classDefinition: #CabinStopped category: #'Elevator-Ejercicio'!
CabinState subclass: #CabinStopped
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!CabinStopped methodsFor: 'accessing' stamp: 'HW 10/12/2017 00:46:00'!
isMoving
	^ false! !

!CabinStopped methodsFor: 'accessing' stamp: 'HW 10/12/2017 00:36:08'!
isStopped
	^ true! !


!CabinStopped methodsFor: 'evaluating' stamp: 'HW 10/12/2017 00:44:07'!
closeDoorFor: aCabin with: aDoor 
	aDoor closing.! !

!CabinStopped methodsFor: 'evaluating' stamp: 'HW 10/12/2017 00:53:40'!
goUpFor: aCabin with: aDoor 
	aDoor closed.
	aCabin changeStateTo: CabinMoving new.! !

!CabinStopped methodsFor: 'evaluating' stamp: 'HW 10/12/2017 01:14:14'!
openFor: aCabin with: aDoor 
	aDoor opening! !

!CabinStopped methodsFor: 'evaluating' stamp: 'HW 10/12/2017 01:37:34'!
waitForPeopleFor: aCabin with: aDoor 
	aDoor open.
	aCabin changeStateTo: CabinWaitingForPeople new.! !


!classDefinition: #CabinWaitingForPeople category: #'Elevator-Ejercicio'!
CabinState subclass: #CabinWaitingForPeople
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!CabinWaitingForPeople methodsFor: 'accessing' stamp: 'HW 10/12/2017 01:39:05'!
isMoving
	^ false! !

!CabinWaitingForPeople methodsFor: 'accessing' stamp: 'HW 10/12/2017 01:38:52'!
isStopped
	^ true! !


!CabinWaitingForPeople methodsFor: 'evaluating' stamp: 'BAB 10/12/2017 12:51:52'!
closeDoorFor: aCabin with: aDoor 
	aDoor closing.! !

!CabinWaitingForPeople methodsFor: 'evaluating' stamp: 'BAB 10/12/2017 13:36:43'!
goUpFor: aCabin with: aDoor 
	aDoor closed.
	aCabin changeStateTo: CabinMoving new..! !

!CabinWaitingForPeople methodsFor: 'evaluating' stamp: 'BAB 10/12/2017 12:33:00'!
isWaitingForPeople
	^ true.! !


!classDefinition: #Door category: #'Elevator-Ejercicio'!
Object subclass: #Door
	instanceVariableNames: 'state'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!Door methodsFor: 'accessing' stamp: 'asdf 10/11/2017 21:00:58'!
isClosed
	^ state isClosed! !

!Door methodsFor: 'accessing' stamp: 'asdf 10/11/2017 21:00:09'!
isClosing
	^ state isClosing! !

!Door methodsFor: 'accessing' stamp: 'asdf 10/11/2017 20:12:50'!
isOpen
	^ state isOpen.! !

!Door methodsFor: 'accessing' stamp: 'asdf 10/11/2017 20:58:18'!
isOpening
	^ state isOpening.! !


!Door methodsFor: 'as yet unclassified' stamp: 'HW 10/12/2017 00:57:01'!
initialize
	state _ DoorOpen new.! !


!Door methodsFor: 'evaluating' stamp: 'HW 10/12/2017 01:00:20'!
changeStateTo: aDoorState
	state _ aDoorState! !

!Door methodsFor: 'evaluating' stamp: 'HW 10/12/2017 01:00:56'!
close
	state closeFor: self! !

!Door methodsFor: 'evaluating' stamp: 'HW 10/12/2017 01:01:04'!
closed
	state closedFor: self! !

!Door methodsFor: 'evaluating' stamp: 'HW 10/12/2017 01:01:16'!
closing
	state closingFor: self.! !

!Door methodsFor: 'evaluating' stamp: 'HW 10/12/2017 01:01:23'!
open
	state openFor: self.! !

!Door methodsFor: 'evaluating' stamp: 'HW 10/12/2017 01:01:29'!
opening
	state openingFor: self.! !


!classDefinition: #DoorState category: #'Elevator-Ejercicio'!
Object subclass: #DoorState
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!DoorState methodsFor: 'accessing' stamp: 'asdf 10/11/2017 21:32:46'!
isClosed
	self subclassResponsibility ! !

!DoorState methodsFor: 'accessing' stamp: 'HW 10/12/2017 00:58:37'!
isClosing
	self subclassResponsibility ! !

!DoorState methodsFor: 'accessing' stamp: 'asdf 10/11/2017 21:21:45'!
isOpen
	self subclassResponsibility ! !

!DoorState methodsFor: 'accessing' stamp: 'asdf 10/11/2017 21:22:42'!
isOpening
	self subclassResponsibility ! !


!DoorState methodsFor: 'evaluating' stamp: 'HW 10/12/2017 01:04:11'!
closedFor: aDoor 
	self subclassResponsibility ! !

!DoorState methodsFor: 'evaluating' stamp: 'HW 10/12/2017 01:03:17'!
closingFor: aDoor 
	self subclassResponsibility! !

!DoorState methodsFor: 'evaluating' stamp: 'HW 10/12/2017 01:45:18'!
openFor: aDoor 
	self subclassResponsibility ! !

!DoorState methodsFor: 'evaluating' stamp: 'HW 10/12/2017 01:45:08'!
openingFor: aDoor 
	self subclassResponsibility! !


!classDefinition: #DoorClosed category: #'Elevator-Ejercicio'!
DoorState subclass: #DoorClosed
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!DoorClosed methodsFor: 'accessing' stamp: 'asdf 10/11/2017 21:23:21'!
isClosed
	^ true! !

!DoorClosed methodsFor: 'accessing' stamp: 'HW 10/12/2017 01:07:25'!
isClosing
	^ false! !

!DoorClosed methodsFor: 'accessing' stamp: 'asdf 10/11/2017 21:22:28'!
isOpen
	^ false.! !

!DoorClosed methodsFor: 'accessing' stamp: 'asdf 10/11/2017 21:22:54'!
isOpening
	^ false! !


!DoorClosed methodsFor: 'evaluating' stamp: 'BAB 10/12/2017 13:29:51'!
closedFor: aDoor 
	ElevatorEmergency signal: 'Sensor de puerta desincronizado'.! !

!DoorClosed methodsFor: 'evaluating' stamp: 'BAB 10/12/2017 17:09:25'!
closingFor: aDoor! !

!DoorClosed methodsFor: 'evaluating' stamp: 'BAB 10/12/2017 17:25:30'!
openFor: aDoor 
	ElevatorEmergency signal: 'Sensor de puerta desincronizado'! !

!DoorClosed methodsFor: 'evaluating' stamp: 'HW 10/12/2017 01:46:06'!
openingFor: aDoor 
	aDoor changeStateTo: DoorOpening new.! !


!classDefinition: #DoorClosing category: #'Elevator-Ejercicio'!
DoorState subclass: #DoorClosing
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!DoorClosing methodsFor: 'accessing' stamp: 'asdf 10/11/2017 21:00:18'!
isClosing
	^ true! !

!DoorClosing methodsFor: 'accessing' stamp: 'asdf 10/11/2017 20:57:34'!
isOpen
	^ false! !

!DoorClosing methodsFor: 'accessing' stamp: 'asdf 10/11/2017 20:58:38'!
isOpening
	^ false! !


!DoorClosing methodsFor: 'as yet unclassified' stamp: 'asdf 10/11/2017 21:01:19'!
isClosed
	^ false! !


!DoorClosing methodsFor: 'evaluating' stamp: 'HW 10/12/2017 01:04:42'!
closedFor: aDoor 
	aDoor changeStateTo: DoorClosed new.! !

!DoorClosing methodsFor: 'evaluating' stamp: 'BAB 10/12/2017 17:05:46'!
closingFor: aDoor! !

!DoorClosing methodsFor: 'evaluating' stamp: 'BAB 10/12/2017 17:32:57'!
openFor: aDoor 
	ElevatorEmergency signal: 'Sensor de puerta desincronizado'! !

!DoorClosing methodsFor: 'evaluating' stamp: 'HW 10/12/2017 01:49:46'!
openingFor: aDoor 
	aDoor changeStateTo: DoorOpening new.! !


!classDefinition: #DoorOpen category: #'Elevator-Ejercicio'!
DoorState subclass: #DoorOpen
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!DoorOpen methodsFor: 'evaluating' stamp: 'BAB 10/12/2017 13:27:31'!
closedFor: aDoor 
	ElevatorEmergency signal: 'Sensor de puerta desincronizado'.! !

!DoorOpen methodsFor: 'evaluating' stamp: 'HW 10/12/2017 01:03:48'!
closingFor: aDoor 
	aDoor changeStateTo: DoorClosing new.! !

!DoorOpen methodsFor: 'evaluating' stamp: 'BAB 10/12/2017 17:03:52'!
openFor: aDoor 
! !

!DoorOpen methodsFor: 'evaluating' stamp: 'HW 10/12/2017 01:46:51'!
openingFor: aDoor 
! !


!DoorOpen methodsFor: 'accessing' stamp: 'HW 10/11/2017 23:45:03'!
isClosed
	^ false! !

!DoorOpen methodsFor: 'accessing' stamp: 'HW 10/12/2017 01:39:20'!
isClosing
	^ false! !

!DoorOpen methodsFor: 'accessing' stamp: 'asdf 10/11/2017 20:57:14'!
isOpen
	^ true! !

!DoorOpen methodsFor: 'accessing' stamp: 'HW 10/11/2017 23:44:45'!
isOpening
	^ false! !


!classDefinition: #DoorOpening category: #'Elevator-Ejercicio'!
DoorState subclass: #DoorOpening
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!DoorOpening methodsFor: 'accessing' stamp: 'asdf 10/11/2017 21:32:57'!
isClosed
	^ false! !

!DoorOpening methodsFor: 'accessing' stamp: 'HW 10/12/2017 01:19:18'!
isClosing
	^ false! !

!DoorOpening methodsFor: 'accessing' stamp: 'asdf 10/11/2017 21:32:22'!
isOpen
	^ false! !

!DoorOpening methodsFor: 'accessing' stamp: 'asdf 10/11/2017 21:32:33'!
isOpening
	^ true! !


!DoorOpening methodsFor: 'evaluating' stamp: 'BAB 10/12/2017 13:30:57'!
closedFor: aDoor 
	ElevatorEmergency signal: 'Sensor de puerta desincronizado'.! !

!DoorOpening methodsFor: 'evaluating' stamp: 'BAB 10/12/2017 13:01:25'!
closingFor: aDoor 
! !

!DoorOpening methodsFor: 'evaluating' stamp: 'HW 10/12/2017 01:46:34'!
openFor: aDoor 
	aDoor changeStateTo: DoorOpen new.! !

!DoorOpening methodsFor: 'evaluating' stamp: 'HW 10/12/2017 01:52:00'!
openingFor: aDoor! !


!classDefinition: #ElevatorController category: #'Elevator-Ejercicio'!
Object subclass: #ElevatorController
	instanceVariableNames: 'floorsToGo cabin state'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!ElevatorController methodsFor: 'accessing' stamp: 'HW 10/12/2017 00:36:31'!
cabinFloorNumber
	^ cabin floorNumber! !

!ElevatorController methodsFor: 'accessing' stamp: 'asdf 10/11/2017 20:09:06'!
isCabinDoorClosed
	^ cabin isDoorClosed! !

!ElevatorController methodsFor: 'accessing' stamp: 'asdf 10/11/2017 20:09:16'!
isCabinDoorClosing
	^ cabin isDoorClosing! !

!ElevatorController methodsFor: 'accessing' stamp: 'asdf 10/11/2017 20:09:28'!
isCabinDoorOpened
	^ cabin isDoorOpen! !

!ElevatorController methodsFor: 'accessing' stamp: 'asdf 10/11/2017 20:09:40'!
isCabinDoorOpening
	^ cabin isDoorOpening! !

!ElevatorController methodsFor: 'accessing' stamp: 'asdf 10/11/2017 20:09:48'!
isCabinMoving
	^ cabin isMoving! !

!ElevatorController methodsFor: 'accessing' stamp: 'asdf 10/11/2017 20:09:56'!
isCabinStopped
	^ cabin isStopped! !

!ElevatorController methodsFor: 'accessing' stamp: 'HW 10/12/2017 00:23:15'!
isCabinWaitingForPeople
	^ cabin isWaitingForPeople! !

!ElevatorController methodsFor: 'accessing' stamp: 'HW 10/12/2017 00:29:03'!
isIdle
	^ state isIdle.! !

!ElevatorController methodsFor: 'accessing' stamp: 'HW 10/12/2017 00:29:20'!
isWorking
	^ state isWorking! !


!ElevatorController methodsFor: 'evaluating' stamp: 'BAB 10/12/2017 12:17:41'!
cabinDoorClosed
	state cabinDoorClosedFor: self with: cabin with: floorsToGo.
! !

!ElevatorController methodsFor: 'evaluating' stamp: 'BAB 10/12/2017 11:44:13'!
cabinDoorOpened
	state cabinDoorOpenedFor: self with: cabin with: floorsToGo.! !

!ElevatorController methodsFor: 'evaluating' stamp: 'BAB 10/12/2017 13:04:52'!
cabinOnFloor: aFloorNumber
	state cabinOnFloor: aFloorNumber for: self with: cabin with: floorsToGo.
	floorsToGo remove: aFloorNumber ifAbsent: [].! !

!ElevatorController methodsFor: 'evaluating' stamp: 'HW 10/12/2017 00:44:36'!
changeStateTo: anElevatorState 
	state _ anElevatorState ! !

!ElevatorController methodsFor: 'evaluating' stamp: 'BAB 10/12/2017 12:53:50'!
closeCabinDoor
	state closeCabinDoorFor: self with: cabin with: floorsToGo.! !

!ElevatorController methodsFor: 'evaluating' stamp: 'BAB 10/12/2017 12:18:21'!
goUpPushedFromFloor: aFloorNumber
	state goUpPushedFromFloor: aFloorNumber for: self with: cabin with: floorsToGo.
	floorsToGo add: aFloorNumber.
! !

!ElevatorController methodsFor: 'evaluating' stamp: 'BAB 10/12/2017 16:58:06'!
openCabinDoor
	state openCabinDoorFor: self with: cabin with: floorsToGo.! !

!ElevatorController methodsFor: 'evaluating' stamp: 'BAB 10/12/2017 12:34:15'!
waitForPeopleTimedOut
	state waitForPeopleTimedOutFor: self with: cabin with: floorsToGo..! !


!ElevatorController methodsFor: 'initialization' stamp: 'BAB 10/12/2017 17:36:20'!
initialize
	cabin _ Cabin new.
	state _ IdleElevator new.
	floorsToGo _ OrderedCollection new.! !


!classDefinition: #ElevatorState category: #'Elevator-Ejercicio'!
Object subclass: #ElevatorState
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!ElevatorState methodsFor: 'evaluating' stamp: 'BAB 10/12/2017 17:36:33'!
cabinDoorClosedFor: anElevatorController with: aCabin with: someFloorsToGo
	aCabin goUp.
	anElevatorController changeStateTo: LiftingElevator new.! !

!ElevatorState methodsFor: 'evaluating' stamp: 'BAB 10/12/2017 11:41:14'!
cabinDoorOpenedFor: anElevatorController with: aCabin with: someFloorsToGo
	self subclassResponsibility ! !

!ElevatorState methodsFor: 'evaluating' stamp: 'BAB 10/12/2017 11:41:00'!
cabinOnFloor: aSmallInteger for: anElevatorController with: aCabin with: someFloorsToGo
	self subclassResponsibility ! !

!ElevatorState methodsFor: 'evaluating' stamp: 'BAB 10/12/2017 12:56:47'!
closeCabinDoorFor: anElevatorController with: aCabin with: someFloorsToGo
	aCabin closeDoor .! !

!ElevatorState methodsFor: 'evaluating' stamp: 'BAB 10/12/2017 11:40:36'!
goUpPushedFromFloor: aFloor for: anElevatorController with: aCabin with: someFloorsToGo
	self subclassResponsibility .! !

!ElevatorState methodsFor: 'evaluating' stamp: 'BAB 10/12/2017 16:59:32'!
openCabinDoorFor: anElevatorController with: aCabin with: someFloorsToGo
	self subclassResponsibility ! !

!ElevatorState methodsFor: 'evaluating' stamp: 'BAB 10/12/2017 12:35:18'!
waitForPeopleTimedOutFor: anElevator with: aCabin with: someFloorsToGo
	self subclassResponsibility .! !


!ElevatorState methodsFor: 'accessing' stamp: 'BAB 10/11/2017 12:53:41'!
isIdle
	self subclassResponsibility.! !

!ElevatorState methodsFor: 'accessing' stamp: 'HW 10/12/2017 00:45:14'!
isWorking
	self subclassResponsibility ! !


!classDefinition: #CalledElevator category: #'Elevator-Ejercicio'!
ElevatorState subclass: #CalledElevator
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!CalledElevator methodsFor: 'accessing' stamp: 'HW 10/12/2017 00:44:57'!
isIdle
	^ false! !

!CalledElevator methodsFor: 'accessing' stamp: 'HW 10/12/2017 00:45:29'!
isWorking
	^ true! !


!CalledElevator methodsFor: 'evaluating' stamp: 'BAB 10/12/2017 17:36:33'!
cabinDoorClosedFor: anElevatorController with: aCabin with: someFloorsToGo
	aCabin goUp.
	anElevatorController changeStateTo: LiftingElevator new.! !

!CalledElevator methodsFor: 'evaluating' stamp: 'BAB 10/12/2017 17:36:44'!
openCabinDoorFor: anElevatorController with: aCabin with: someFloorsToGo
	aCabin openDoor.
	anElevatorController changeStateTo: ReachedFloorElevator new.! !


!classDefinition: #IdleElevator category: #'Elevator-Ejercicio'!
ElevatorState subclass: #IdleElevator
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!IdleElevator methodsFor: 'evaluating' stamp: 'BAB 10/12/2017 12:56:17'!
closeCabinDoorFor: anElevatorController with: aCabin with: anOrderedCollection 
	! !

!IdleElevator methodsFor: 'evaluating' stamp: 'BAB 10/12/2017 17:36:54'!
goUpPushedFromFloor: aSmallInteger for: anElevatorController with: aCabin with: someFloorsToGo
	aCabin closeDoor.
	anElevatorController changeStateTo: CalledElevator new.! !

!IdleElevator methodsFor: 'evaluating' stamp: 'BAB 10/12/2017 12:20:30'!
openCabinDoorFor: anElevatorController with: aCabin with: someFloorsToGo
	aCabin openDoor.! !


!IdleElevator methodsFor: 'accessing' stamp: 'HW 10/12/2017 01:43:50'!
isIdle
	^ true! !

!IdleElevator methodsFor: 'accessing' stamp: 'HW 10/12/2017 01:38:39'!
isWorking
	^ false! !


!classDefinition: #LiftingElevator category: #'Elevator-Ejercicio'!
ElevatorState subclass: #LiftingElevator
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!LiftingElevator methodsFor: 'accessing' stamp: 'HW 10/12/2017 01:06:23'!
isIdle
	^ false! !

!LiftingElevator methodsFor: 'accessing' stamp: 'HW 10/12/2017 01:06:34'!
isWorking
	^ true! !


!LiftingElevator methodsFor: 'evaluating' stamp: 'BAB 10/12/2017 17:22:34'!
cabinDoorOpenedFor: anElevatorController with: aCabin with: someFloorsToGo
	aCabin doorOpen.! !

!LiftingElevator methodsFor: 'evaluating' stamp: 'BAB 10/12/2017 17:36:44'!
cabinOnFloor: aFloorNumber for: anElevatorController with: aCabin with: someFloorsToGo
	aCabin reachedFloor: aFloorNumber.
	aCabin stop.
	aCabin openDoor.
	anElevatorController changeStateTo: ReachedFloorElevator new.! !

!LiftingElevator methodsFor: 'evaluating' stamp: 'BAB 10/12/2017 13:35:24'!
goUpPushedFromFloor: aSmallInteger for: anElevatorController with: aCabin with: anOrderedCollection 
! !

!LiftingElevator methodsFor: 'evaluating' stamp: 'BAB 10/12/2017 12:20:00'!
openCabinDoorFor: anElevatorController with: aCabin with: someFloorsToGo
! !


!classDefinition: #ReachedFloorElevator category: #'Elevator-Ejercicio'!
ElevatorState subclass: #ReachedFloorElevator
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Elevator-Ejercicio'!

!ReachedFloorElevator methodsFor: 'accessing' stamp: 'BAB 10/11/2017 12:53:33'!
isIdle
	^ false	! !

!ReachedFloorElevator methodsFor: 'accessing' stamp: 'HW 10/12/2017 01:19:03'!
isWorking
	^ true! !


!ReachedFloorElevator methodsFor: 'evaluating' stamp: 'BAB 10/12/2017 17:36:20'!
cabinDoorOpenedFor: anElevatorController with: aCabin with: someFloorsToGo
	aCabin waitForPeople.
	someFloorsToGo
		ifEmpty: [ anElevatorController changeStateTo: IdleElevator new ]
		ifNotEmpty: [ ].! !

!ReachedFloorElevator methodsFor: 'evaluating' stamp: 'BAB 10/12/2017 13:03:25'!
cabinOnFloor: aSmallInteger for: anElevatorController with: aCabin with: anOrderedCollection 
	ElevatorEmergency signal: 'Sensor de cabina desincronizado'.! !

!ReachedFloorElevator methodsFor: 'evaluating' stamp: 'BAB 10/12/2017 12:55:37'!
closeCabinDoorFor: anElevatorController with: aCabin with: anOrderedCollection 
	aCabin closeDoor.! !

!ReachedFloorElevator methodsFor: 'evaluating' stamp: 'BAB 10/12/2017 12:19:31'!
openCabinDoorFor: anElevatorController with: aCabin with: someFloorsToGo
	aCabin openDoor.! !

!ReachedFloorElevator methodsFor: 'evaluating' stamp: 'BAB 10/12/2017 17:36:54'!
waitForPeopleTimedOutFor: anElevatorController with: aCabin with: someFloorsToGo
	aCabin closeDoor.
	anElevatorController changeStateTo: CalledElevator new.! !


!ReachedFloorElevator methodsFor: 'as yet unclassified' stamp: 'BAB 10/12/2017 12:19:24'!
goUpPushedFromFloor: aFloor for: anElevatorController with: aCabin with: someFloorsToGo! !
