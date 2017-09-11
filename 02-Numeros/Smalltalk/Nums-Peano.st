!classDefinition: #One category: #Numeros!
DenotativeObject subclass: #One
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Numeros'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'One class' category: #Numeros!
One class
	instanceVariableNames: 'prev'!

!One class methodsFor: 'as yet unclassified' stamp: 'BAB 9/11/2017 17:40:52'!
+ anEntero
	^ (self prev + anEntero) next.! !

!One class methodsFor: 'as yet unclassified' stamp: 'BAB 9/11/2017 17:41:07'!
isZero
	^ false.! !

!One class methodsFor: 'as yet unclassified' stamp: 'BAB 9/11/2017 17:26:29'!
next
	^ (self clone prev: self).! !

!One class methodsFor: 'as yet unclassified' stamp: 'BAB 9/11/2017 17:31:40'!
prev
	^ prev.! !

!One class methodsFor: 'as yet unclassified' stamp: 'BAB 9/11/2017 17:29:45'!
prev: anEntero
	prev := anEntero.! !

One instVarNamed: 'prev' put: Zero!