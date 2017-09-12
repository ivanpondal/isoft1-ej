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

!One class methodsFor: 'as yet unclassified' stamp: 'BAB 9/11/2017 21:13:37'!
* anEntero
	^ ((self prev) * anEntero) + anEntero.! !

!One class methodsFor: 'as yet unclassified' stamp: 'BAB 9/11/2017 17:40:52'!
+ anEntero
	^ (self prev + anEntero) next.! !

!One class methodsFor: 'as yet unclassified' stamp: 'BAB 9/11/2017 21:30:11'!
initializeWith: aPrevEntero
	prev _ aPrevEntero.! !

!One class methodsFor: 'as yet unclassified' stamp: 'BAB 9/11/2017 21:27:00'!
integerValue
	^ self prev integerValue + 1! !

!One class methodsFor: 'as yet unclassified' stamp: 'BAB 9/11/2017 17:41:07'!
isZero
	^ false.! !

!One class methodsFor: 'as yet unclassified' stamp: 'BAB 9/11/2017 21:29:44'!
next
	^ self clone initializeWith: self.! !

!One class methodsFor: 'as yet unclassified' stamp: 'BAB 9/11/2017 17:31:40'!
prev
	^ prev.! !

One instVarNamed: 'prev' put: Zero!

!classDefinition: #Zero category: #Numeros!
DenotativeObject subclass: #Zero
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Numeros'!

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Zero class' category: #Numeros!
Zero class
	instanceVariableNames: ''!

!Zero class methodsFor: 'as yet unclassified' stamp: 'BAB 9/11/2017 21:00:15'!
* anEntero
	^ self.! !

!Zero class methodsFor: 'as yet unclassified' stamp: 'BAB 9/11/2017 20:53:28'!
+ anEntero
	^ anEntero! !

!Zero class methodsFor: 'as yet unclassified' stamp: 'BAB 9/11/2017 21:26:39'!
integerValue
	^ 0! !

!Zero class methodsFor: 'as yet unclassified' stamp: 'BAB 9/11/2017 20:52:42'!
isZero
	^ true.! !

!Zero class methodsFor: 'as yet unclassified' stamp: 'BAB 9/11/2017 20:53:02'!
next
	^ One.! !
