Class {
	#name : #SpeedUpEffect,
	#superclass : #Effect,
	#category : #'IngSoft2-Model'
}

{ #category : #action }
SpeedUpEffect >> applyOn: aBoard activatedBy: aPlayer [
	(aBoard isLockedUp: aPlayer) ifFalse: [ aBoard move: aPlayer by: 4 ].
]
