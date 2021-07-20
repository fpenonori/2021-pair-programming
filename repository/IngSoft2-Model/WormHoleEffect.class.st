Class {
	#name : #WormHoleEffect,
	#superclass : #Effect,
	#category : #'IngSoft2-Model'
}

{ #category : #action }
WormHoleEffect >> applyOn: aBoard activatedBy: aPlayer [
	(aBoard isLockedUp: aPlayer) ifFalse: [ aBoard move: aPlayer by: (-4) ].
]
