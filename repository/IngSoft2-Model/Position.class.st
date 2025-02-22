Class {
	#name : #Position,
	#superclass : #Object,
	#instVars : [
		'name',
		'square',
		'laps',
		'locked'
	],
	#category : #'IngSoft2-Model'
}

{ #category : #'instance creation' }
Position class >> of: playerName at: squareNumber in: lapNumber [
	^ self new initializeOf: playerName at: squareNumber in: lapNumber
]

{ #category : #comparing }
Position >> > aPosition [
	^ (square) > (aPosition currentPosition)
]

{ #category : #accessing }
Position >> currentLap [
	^ laps
]

{ #category : #accessing }
Position >> currentPlayer [
	^ name
]

{ #category : #accessing }
Position >> currentPosition [
	^ square
]

{ #category : #initialization }
Position >> initializeOf: playerName at: squareNumber in: lapNumber [

	name := playerName.
	square := squareNumber.
	laps := lapNumber.
	locked := false.

]

{ #category : #accessing }
Position >> isLockedUp [ 
	^ locked.
]

{ #category : #action }
Position >> lockUp [
	locked := true.
]

{ #category : #accessing }
Position >> player [
	^ name.
]

{ #category : #action }
Position >> unlock [
	locked := false.
]
