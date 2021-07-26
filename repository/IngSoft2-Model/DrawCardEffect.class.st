Class {
	#name : #DrawCardEffect,
	#superclass : #Effect,
	#category : #'IngSoft2-Model'
}

{ #category : #action }
DrawCardEffect >> applyOn: aBoard activatedBy: aPlayer [
	(aBoard isLockedUp: aPlayer) ifFalse: [ aBoard dealsCardTo: aPlayer ].
]
