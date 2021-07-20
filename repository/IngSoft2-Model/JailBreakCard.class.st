Class {
	#name : #JailBreakCard,
	#superclass : #Card,
	#category : #'IngSoft2-Model'
}

{ #category : #action }
JailBreakCard >> applyTo: aBoard directedTo: aTarget [
	aBoard handleUnlockWith: aTarget.
]

{ #category : #action }
JailBreakCard >> handle: aBoard for: aPlay [
	aBoard handleInstantaeousCardFrom: aPlay.
]
