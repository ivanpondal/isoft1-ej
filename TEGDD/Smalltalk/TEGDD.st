!classDefinition: #AttackTurnTest category: #TEGDD!
TestCase subclass: #AttackTurnTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TEGDD'!

!AttackTurnTest methodsFor: 'as yet unclassified' stamp: 'ip 10/25/2017 23:54:13'!
test01OneVsOneAttackerLosesIfDefenderHasHigherOrEqualRoll
	| attackTurn attackResult |
	attackTurn _ AttackTurn
		withAttackerDice: (MockedDice withRolls: (OrderedCollection with: 1))
		withDefenderDice: (MockedDice withRolls: (OrderedCollection with: 2)).
	attackResult _ attackTurn
		resultAfterAttackingArmyOfSize: 1
		andDefendingArmyOfSize: 1.
	self
		assert: 1
		equals: attackResult attackerLosses.
	self
		assert: 0
		equals: attackResult defenderLosses.! !

!AttackTurnTest methodsFor: 'as yet unclassified' stamp: 'ip 10/25/2017 23:50:45'!
test02OneVsOneAttackerLosesIfThereIsATie
	| attackTurn attackResult |
	attackTurn _ AttackTurn
		withAttackerDice: (MockedDice withRolls: (OrderedCollection with: 1))
		withDefenderDice: (MockedDice withRolls: (OrderedCollection with: 1)).
	attackResult _ attackTurn
		resultAfterAttackingArmyOfSize: 1
		andDefendingArmyOfSize: 1.
	self
		assert: 1
		equals: attackResult attackerLosses.
	self
		assert: 0
		equals: attackResult defenderLosses.! !

!AttackTurnTest methodsFor: 'as yet unclassified' stamp: 'ip 10/25/2017 23:51:08'!
test03OneVsOneAttackerWinsIfDefenderHasLowerRoll
	| attackTurn attackResult |
	attackTurn _ AttackTurn
		withAttackerDice: (MockedDice withRolls: (OrderedCollection with: 2))
		withDefenderDice: (MockedDice withRolls: (OrderedCollection with: 1)).
	attackResult _ attackTurn
		resultAfterAttackingArmyOfSize: 1
		andDefendingArmyOfSize: 1.
	self
		assert: 0
		equals: attackResult attackerLosses.
	self
		assert: 1
		equals: attackResult defenderLosses.! !

!AttackTurnTest methodsFor: 'as yet unclassified' stamp: 'ip 10/25/2017 23:55:41'!
test04OneVsTwoAttackerLosesIfDefenderHasAtLeastOneHigherOrEqualRoll
	| attackTurn attackResult |
	attackTurn _ AttackTurn
		withAttackerDice: (MockedDice withRolls: (OrderedCollection with: 2))
		withDefenderDice: (MockedDice withRolls: (OrderedCollection with: 1 with: 2)).
	attackResult _ attackTurn
		resultAfterAttackingArmyOfSize: 1
		andDefendingArmyOfSize: 2.
	self
		assert: 1
		equals: attackResult attackerLosses.
	self
		assert: 0
		equals: attackResult defenderLosses.! !


!classDefinition: #AttackResult category: #TEGDD!
Object subclass: #AttackResult
	instanceVariableNames: 'attackerLosses defenderLosses'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TEGDD'!

!AttackResult methodsFor: 'private' stamp: 'ip 10/25/2017 23:36:43'!
initializeWithAttackerLosing: aSmallInteger withDefenderLosing: aSmallInteger2 
	attackerLosses _ aSmallInteger.
	defenderLosses _ aSmallInteger2.! !


!AttackResult methodsFor: 'accessing' stamp: 'ip 10/25/2017 23:36:56'!
attackerLosses
	^attackerLosses! !

!AttackResult methodsFor: 'accessing' stamp: 'ip 10/25/2017 23:37:05'!
defenderLosses
	^defenderLosses! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'AttackResult class' category: #TEGDD!
AttackResult class
	instanceVariableNames: ''!

!AttackResult class methodsFor: 'initialization' stamp: 'ip 10/25/2017 23:39:21'!
withAttackerLosing: aSmallInteger withDefenderLosing: aSmallInteger2
	^ self new
		initializeWithAttackerLosing: aSmallInteger
		withDefenderLosing: aSmallInteger2.! !


!classDefinition: #AttackTurn category: #TEGDD!
Object subclass: #AttackTurn
	instanceVariableNames: 'attackerDice defenderDice'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TEGDD'!

!AttackTurn methodsFor: 'private' stamp: 'ip 10/25/2017 23:30:55'!
initializeWithAttackerDice: anAttackerDice withDefenderDice: aDefenderDice
	attackerDice _ anAttackerDice.
	defenderDice _ aDefenderDice.! !

!AttackTurn methodsFor: 'private' stamp: 'ip 10/26/2017 00:32:51'!
resultAfterAttackingArmyOfSize: attackingArmyCount andDefendingArmyOfSize: defendingArmyCount
	| attackerRolls defenderRolls attackerLosses defenderLosses attacks |
	attackerRolls _ OrderedCollection new.
	defenderRolls _ OrderedCollection new.
	attackerLosses _ 0.
	defenderLosses _ 0.

	attackingArmyCount timesRepeat: [ attackerRolls add: attackerDice roll].
	defendingArmyCount timesRepeat: [ defenderRolls add: defenderDice roll].

	attackerRolls _ attackerRolls sort reversed.
	defenderRolls _ defenderRolls sort reversed.

	(attackingArmyCount <= defendingArmyCount) ifTrue: [ attacks _ attackingArmyCount ] ifFalse: [ attacks _ defendingArmyCount ].
	
	1 to: attacks do: [ :attack |
		((attackerRolls at: attack) <= (defenderRolls at: attack)) ifTrue: [ attackerLosses _ attackerLosses + 1] ifFalse: [ defenderLosses _ defenderLosses + 1 ].
		attacks _ attacks - 1].

	^ AttackResult withAttackerLosing: attackerLosses withDefenderLosing: defenderLosses.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'AttackTurn class' category: #TEGDD!
AttackTurn class
	instanceVariableNames: ''!

!AttackTurn class methodsFor: 'initialization' stamp: 'ip 10/25/2017 23:47:21'!
withAttackerDice: anAttackerDice withDefenderDice: aDefenferDice
	^ self new initializeWithAttackerDice: anAttackerDice withDefenderDice: aDefenferDice ! !



!classDefinition: #MockedDice category: #TEGDD!
Object subclass: #MockedDice
	instanceVariableNames: 'rolls rollIndex'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'TEGDD'!

!MockedDice methodsFor: 'private' stamp: 'ip 10/26/2017 00:36:41'!
initializeWithRolls: anOrderedCollection 
	rolls _ anOrderedCollection.
	rollIndex _ 0.! !


!MockedDice methodsFor: 'evaluating' stamp: 'ip 10/26/2017 00:39:05'!
roll
	rollIndex _ (rollIndex mod: rolls size) + 1.
	^ rolls at: rollIndex.! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'MockedDice class' category: #TEGDD!
MockedDice class
	instanceVariableNames: ''!

!MockedDice class methodsFor: 'initialization' stamp: 'ip 10/25/2017 23:28:10'!
withRolls: anOrderedCollection 
	^ self new initializeWithRolls: anOrderedCollection ! !
