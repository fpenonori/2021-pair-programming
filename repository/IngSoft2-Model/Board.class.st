Class {
	#name : #Board,
	#superclass : #Object,
	#instVars : [
		'squares',
		'size',
		'players',
		'turn',
		'positionTracker',
		'laps',
		'lastAppliedEffect',
		'cardHandler',
		'diceCup'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'instance creation' }
Board class >> having: squares requiring: aNumberOfLaps playingWith: aDeck usedBy: aGroupOfPlayers throwing: aDiceCup [
	self validateMoreThanEightSquares: squares.
	self validatesItDoesntHavePlayersWithSameName: aGroupOfPlayers.
	self validatesNamesMustHaveAtLeastOneLetter: aGroupOfPlayers.
	self validatesItMustHaveAtLeastOnePlayer: aGroupOfPlayers.
	self validatesItNeedsAtLeastOneLap: aNumberOfLaps.  
	^self new initializeHaving: squares requiring: aNumberOfLaps containing: aDeck usedBy: aGroupOfPlayers throwing: aDiceCup. 
]

{ #category : #validation }
Board class >> validateMoreThanEightSquares: squares [
	(squares size) < 8
		ifTrue: [ Error signal: 'A board must contain at least 8 square boards to satisfy the effects distribution.' ]
]

{ #category : #validation }
Board class >> validatesItDoesntHavePlayersWithSameName: players [

	| playerNames |
	
	playerNames := players asSet.
	(players size) > (playerNames size) ifTrue: [ Error signal: 'A board cannot be created having players with repeated names.' ]
]

{ #category : #validation }
Board class >> validatesItMustHaveAtLeastOnePlayer: aPlayer [
	aPlayer size < 1
		ifTrue: [ Error signal: 'A board must have at least 1 player in order to be created.' ]
]

{ #category : #'instance creation' }
Board class >> validatesItNeedsAtLeastOneLap: amountOfLaps [
	amountOfLaps < 1
		ifTrue: [ Error signal: 'A board requires at least one lap to be created.' ]
]

{ #category : #validation }
Board class >> validatesNamesMustHaveAtLeastOneLetter: players [ 

	players detect: [ :playerName | playerName size < 1] ifFound: [ Error signal: 'Player name must have at least one letter' ].
]

{ #category : #accessing }
Board >> absoluteSize [
	^ size * laps
]

{ #category : #accessing }
Board >> accumulatedCardEffectValues [

	| currentPlayer activePlays applicablePlays valueOfEffects sumOfValues |
	
	activePlays := cardHandler activePlays.
	currentPlayer := self currentPlayerThrowing.
	applicablePlays := activePlays select: [ :play | (play target) includes: currentPlayer ].
	valueOfEffects := applicablePlays collect: [ :play | (play card) applyTo: self directedTo: currentPlayer ]. 
	sumOfValues := valueOfEffects inject: 0 into: [:sum :each | sum + each ].
	^ sumOfValues.
]

{ #category : #accessing }
Board >> activeCards [
	^ cardHandler activeCards
]

{ #category : #accessing }
Board >> amountOfLaps [
	^ laps
]

{ #category : #accessing }
Board >> amountOfPlayers [
	^ players size
]

{ #category : #action }
Board >> applyCancellationCardTo: aPlay [ 
	cardHandler removeFromActivePlays: aPlay
]

{ #category : #action }
Board >> applyRedoCardTo: aTarget by: invokingPlayer [
	
	| reversedPlayHistory redoCard lastPlayApplied newPlay |
	
	reversedPlayHistory := cardHandler playHistory reverse.
	redoCard := reversedPlayHistory first card.
	lastPlayApplied := reversedPlayHistory detect: [ :play | play card ~= redoCard ] 
	ifNone: [Error signal: 'A Redo card can not be played if no previous cards were played'].
	newPlay := lastPlayApplied card asPlayAffecting: aTarget by: invokingPlayer .  
	cardHandler deal: lastPlayApplied card to: invokingPlayer.
	self resolvePlayabilityOf: newPlay
	
]

{ #category : #action }
Board >> applyRepeatCardTo: aTarget [ 
	
	| targetedPlayer |
	
	targetedPlayer := aTarget first.
	self disableEffectsDuring: [ lastAppliedEffect applyOn: self activatedBy: targetedPlayer ]
]

{ #category : #accessing }
Board >> currentPlayerThrowing [
	^ players at: turn
]

{ #category : #action }
Board >> dealsCardTo: aPlayer [
	cardHandler dealsCardTo: aPlayer
]

{ #category : #action }
Board >> decideUnlockingOf: player with: resultOfThrow [
	((self isLockedUp: player) and: diceCup maxThrow = resultOfThrow)
		ifTrue: [ self unlock: player ]
]

{ #category : #action }
Board >> disableEffectsDuring: anAction [
	self notifySquaresToNotApplyEffect.
	anAction value.
	self notifySquaresToApplyEffect
]

{ #category : #accessing }
Board >> handOf: aPlayer [
	^ cardHandler handOf: aPlayer
]

{ #category : #action }
Board >> handleInstantaeousCardFrom: newPlay [
	cardHandler removeFromPlayerHandCardOf: newPlay.
	newPlay card applyTo: self directedTo: newPlay
]

{ #category : #action }
Board >> handlePermanentCardFrom: newPlay [
	self currentPlayerThrowing ~= newPlay invokingPlayer
		ifTrue: [ Error signal: 'A permanent card can only played in the turn of the invoking player' ]
		ifFalse: [ cardHandler activate: newPlay ]
]

{ #category : #action }
Board >> handleUnlockWith: aPlay [
	(self isLockedUp: aPlay target)
		ifTrue: [ self unlock: aPlay target ]
		ifFalse: [
			cardHandler deal: (aPlay card) to: (aPlay invokingPlayer).
			Error signal: 'Only jailed players can be targeted by the jailbreak card' ]
]

{ #category : #action }
Board >> incrementTurn [
	turn := (turn rem: players size) + 1
]

{ #category : #initialization }
Board >> initializeHaving: boardSquares requiring: aNumberOfLaps containing: aDeck usedBy: aGroupOfPlayers throwing: aDiceCup [  
	
	players := aGroupOfPlayers.
	size := boardSquares size.
	turn := 1.
	squares := boardSquares.
	laps := aNumberOfLaps.
	diceCup := aDiceCup.
	positionTracker := PositionsTracker of: aGroupOfPlayers inBoardOf: size.
	cardHandler := CardHandler using: aDeck dealsTo: aGroupOfPlayers.
	lastAppliedEffect := NoEffect new
]

{ #category : #accessing }
Board >> isLockedUp: aPlayer [

	^ positionTracker isLockedUp: aPlayer.
]

{ #category : #action }
Board >> lockUp: aPlayer [
	positionTracker lockUp: aPlayer.
]

{ #category : #action }
Board >> makes: aPlay in: aGame [
	self verifyIsInGame: (aPlay invokingPlayer).
	self resolvePlayabilityOf: aPlay.
	self verifyThereIsAWinner ifTrue: [ aGame isNotifiedItHasFinished ]
]

{ #category : #action }
Board >> move: player by: amountPlaces [

	| playerPosition calculatedPlayerPosition |
	
	playerPosition := positionTracker absolutePositionOf: player.
	calculatedPlayerPosition := playerPosition + amountPlaces.
	calculatedPlayerPosition <= 0	ifTrue: [ calculatedPlayerPosition := 1 ].
	positionTracker update: player withNew: calculatedPlayerPosition.
	(squares at: (self positionOf: player)) place: player on: self 
	
]

{ #category : #action }
Board >> moveAllPlayersToFirstSquareOfTheirLap [

	| relativePositions relativePlayerPosition affectedPlayers |
	
	relativePositions := positionTracker boardPositions.
	affectedPlayers := players reject: [ :player | self isLockedUp: player ].
	affectedPlayers do: [ :playerName |
		relativePlayerPosition := relativePositions at: playerName.
		self move: playerName by: ((relativePlayerPosition - 1) * (-1)). ]
]

{ #category : #action }
Board >> movePlayersBack: aNumberOfSpaces except: aPlayer [
	
	| affectedPlayers |
	
	affectedPlayers := players reject: [ :player | (player = aPlayer or: (self isLockedUp: player))].
	affectedPlayers do: [ :player | self move: player by: (-1) * aNumberOfSpaces ]
]

{ #category : #action }
Board >> nextPlayerThrowsIn: aGame [
	| player resultOfThrow |
	player := players at: turn.
	resultOfThrow := diceCup throw.
	self decideUnlockingOf: player with: resultOfThrow.
	(self isLockedUp: player) ifFalse: [ self move: player by: resultOfThrow + self accumulatedCardEffectValues ].
	self verifyThereIsAWinner ifTrue: [ aGame isNotifiedItHasFinished ] ifFalse: [ self incrementTurn ]
]

{ #category : #notification }
Board >> notifySquaresToApplyEffect [
	squares do: [ :square | square applyEffect ]
]

{ #category : #notification }
Board >> notifySquaresToNotApplyEffect [
	squares do: [ :square | square doNotApplyEffect ]
]

{ #category : #testing }
Board >> playerLaps [
	^ positionTracker playerLaps
]

{ #category : #accessing }
Board >> playerPositions [
	^ positionTracker boardPositions
]

{ #category : #testing }
Board >> playerRanking [
	^ positionTracker playerRanking
]

{ #category : #accessing }
Board >> players [
	^ players copy.
]

{ #category : #accessing }
Board >> positionOf: aPlayer [
	^ positionTracker boardPositionOf: aPlayer
]

{ #category : #action }
Board >> resolvePlayabilityOf: newPlay [
	(newPlay card) handle: self for: newPlay
]

{ #category : #accessing }
Board >> size [
	^ size
]

{ #category : #action }
Board >> unlock: aPlayer [
	positionTracker unlock: aPlayer.
]

{ #category : #action }
Board >> updateLastApplied: effect [
	lastAppliedEffect := effect
]

{ #category : #verification }
Board >> verifyIsInGame: aName [
		(players includes: aName) ifFalse: [ Error signal: 'The invoking player must be a participant of the game' ].
]

{ #category : #verification }
Board >> verifyThereIsAWinner [
	^ players anySatisfy: [ :player | (positionTracker absolutePositionOf: player) > self absoluteSize ]
]
