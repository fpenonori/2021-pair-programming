Class {
	#name : #GameTest,
	#superclass : #TestCase,
	#category : #'IngSoft2-Tests'
}

{ #category : #asserting }
GameTest >> should: errorBlock raise: exceptionClass withMessage: expectedErrorMessage [

	self
		should: errorBlock
		raise: exceptionClass
		withExceptionDo:
			[ :error | self assert: error messageText equals: expectedErrorMessage ]
]

{ #category : #tests }
GameTest >> test01ADieWithTwentyFacesRollsANumberBetweenOneAndTwenty [
	
	| aDie |
	
	aDie := Die with: 20.
	self assert: (aDie throw between: 1 and: 20)
]

{ #category : #tests }
GameTest >> test02ADieCannotHaveLessThanFourFaces [

	self
		should: [ Die with: 3 ]
		raise: Error
		withMessage: 'Die faces cannot be less than 4'
]

{ #category : #tests }
GameTest >> test03DiceCupsContainsANumberOfDice [
	
	| aDie aSecondDie dice aDiceCup |
	
	aDie := Die with: 5.
	aSecondDie := Die with: 14.
	dice := {aDie . aSecondDie}.
	aDiceCup := DiceCup contains: dice.
	self assert: aDiceCup amountOfDice equals: 2.
]

{ #category : #tests }
GameTest >> test04DiceCupWithATwentyFaceDieaAndASixFaceDieRollsANumberBetweenTwoAndTwentySix [
	
	| aDie aSecondDie dice aDiceCup |
	
	aDie := Die with: 6.
	aSecondDie := Die with: 20.
	dice := {aDie . aSecondDie}.
	aDiceCup := DiceCup contains: dice.
	self assert: (aDiceCup throw between: 2 and: 26).
]

{ #category : #tests }
GameTest >> test04_1DiceCupWithASingleSixFacedDieRollsANumberBetween1and6 [
	
	| aDie   aDiceCup |
	
	aDie := Die with: 6.
	aDiceCup := DiceCup containsSingle: aDie.
	self assert: (aDiceCup throw between: 1 and: 6).
]

{ #category : #tests }
GameTest >> test05DiceCupsMustContainAtLeastOneDie [
	
	| dice |
	
	dice := { }.
	
	self
		should: [ DiceCup contains: dice ]
		raise: Error
		withMessage: 'Dice cups must contain at least a die'.
		
]

{ #category : #tests }
GameTest >> test06ABoardSquareHasAValidPositionAssigned [
	
	| aBoardSquare |
	
	aBoardSquare := BoardSquare numbered: 1.
	self assert:(aBoardSquare squareNumber) equals: 1.
]

{ #category : #tests }
GameTest >> test07ABoardSquareMustBeAssignedAValueGreaterThanZero [
	
	self
		should: [ BoardSquare numbered: 0 ]
		raise: Error
		withMessage: 'A board square must be assigned a value greater than zero'.
]

{ #category : #tests }
GameTest >> test08ABoardCreatedWithTwentySquareBoardsHasTwentySquareBoards [
	
	| aBoard |
	
	aBoard := Board containing: 20.
	self assert: (aBoard boardSquares) equals: 20.
]

{ #category : #tests }
GameTest >> test09ABoardMustContainAtLeast1SquareBoard [
	
	self
		should: [ Board containing: 0 ]
		raise: Error
		withMessage: 'A board must contain at least 1 square board'.
]

{ #category : #tests }
GameTest >> test10AGameWithOnePlayerThatActuallyHasOnePlayer [
	| aPlayer aGame |
	aPlayer := Player number: 1.
	aGame := Game withPlayers: {aPlayer}.
	self assert: aGame withAmountOfPlayers equals: 1
]

{ #category : #tests }
GameTest >> test11PlayerNumberShouldBeGreaterThanZero [
	

	self
		should: [ Player number: 0]
		raise: Error
		withMessage: 'Player numbers must be at least 1'.
]

{ #category : #tests }
GameTest >> test12AGameShouldContainAtLeastOnePayer [
	

	self
		should: [ Game withPlayers: {}]
		raise: Error
		withMessage: 'A game must contain at least 1 player'.
]

{ #category : #tests }
GameTest >> test13ANFacedDeterministicDieAlwaysLandsOnNOver2IfTheFacesNumIsEvenOrNMinus1Over2IfFaceNumIsOdd [

| aDetDie aSecondDetDie aThirdDetDie |
aDetDie := DeterministicDie with: 6.
aSecondDetDie:= DeterministicDie with: 12.
aThirdDetDie := DeterministicDie with: 5.

self assert: aDetDie throw equals: 3.
self assert: aSecondDetDie throw equals: 6.
self assert: aThirdDetDie throw equals: 2.


]

{ #category : #tests }
GameTest >> test14ADeterministicDieCannotHaveLessThanFourFaces [

	self
		should: [ DeterministicDie  with: 3 ]
		raise: Error
		withMessage: 'A Deterministic Die  cannot have less than 4 faces'
]

{ #category : #tests }
GameTest >> test15APlayerThrowsADeterministicDieCupWithTwoSixFacedDiceAndTheResultIsSix [
	| player aDetDie aSecondDetDie aDiceCup |
	player := Player number: 1.
	aDetDie := DeterministicDie with: 6.
	aSecondDetDie := DeterministicDie with: 6.
	aDiceCup := DiceCup contains: {aDetDie.aSecondDetDie}.
	self assert: (player rollsWith: aDiceCup) equals: 6
]