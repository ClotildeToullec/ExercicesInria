"
I am a link in a double linked chain.

I strore an element and know my predecessor and follower in the chain.
"
Class {
	#name : #EIChain,
	#superclass : #Object,
	#instVars : [
		'element',
		'previous',
		'next'
	],
	#category : #EIChain
}

{ #category : #'instance creation' }
EIChain class >> newForElement: anElement [
	^ self new element: anElement.
]

{ #category : #'instance creation' }
EIChain class >> newFrom: aCollection [
	| newList current |
	newList := self newForElement: nil.
	aCollection ifEmpty: [ ^ nil ].
	current := newList.
	aCollection
		do: [ :el | 
			current addAfter: el.
			current := current next ].
	newList := newList next.
	newList removePrevious.
	^ newList
]

{ #category : #comparing }
EIChain >> = anObject [
	"Returns true only if anObject is a CTChain and if both chains have the same length and store the same elements in the same order"

	| currentTested currentSelf |
	anObject == self
		ifTrue: [ ^ true ].
	anObject class == self class
		ifFalse: [ ^ false ].
	currentTested := anObject first.
	currentSelf := self first.
	[ currentTested next isNotNil and: [ currentSelf next isNotNil ] ]
		whileTrue: [ currentTested element = currentSelf element
				ifFalse: [ ^ false ].
			currentSelf := currentSelf next.
			currentTested := currentTested next ].
	^ currentTested next isNil and: [ currentSelf next isNil ]
]

{ #category : #adding }
EIChain >> addAfter: anElement [
	"Inserts a new link in the chain before this link, which value element is anElement"

	| newList |
	newList := self class newForElement: anElement.
	next ifNotNil: [ next previous: newList ].
	newList next: next.
	self next: newList.
	newList previous: self
]

{ #category : #adding }
EIChain >> addBefore: anElement [
	"Inserts a new link in the chain after this link, which value element is anElement"

	| newList |
	newList := self class newForElement: anElement.
	previous
		ifNotNil: [ previous next: newList.
			newList previous: previous ].
	self previous: newList.
	newList next: self
]

{ #category : #transforming }
EIChain >> apply: aBlock [
	"Returns the first link of a new chain containing this one's elements transformed by aBlock."

	| newList current |
	newList := self first.
	current := newList.
	[ current next isNotNil ]
		whileTrue: [ current element: (aBlock value: current element).
			current := current next ].
	^ newList
]

{ #category : #accessing }
EIChain >> element [
	^ element
]

{ #category : #accessing }
EIChain >> element: anObject [
	element := anObject
]

{ #category : #accessing }
EIChain >> first [
	"Returns the first link of this chain"

	| first |
	first := self.
	[ first previous isNotNil ] whileTrue: [ first := first previous ].
	^ first
]

{ #category : #accessing }
EIChain >> last [
	"Returns the last link of this chain"

	| last |
	last := self.
	[ last next isNotNil ] whileTrue: [ last := last next ].
	^ last
]

{ #category : #accessing }
EIChain >> next [
	^ next
]

{ #category : #accessing }
EIChain >> next: aCTList [
	next := aCTList
]

{ #category : #accessing }
EIChain >> previous [
	^ previous
]

{ #category : #accessing }
EIChain >> previous: aCTList [
	previous := aCTList
]

{ #category : #printing }
EIChain >> printElementOfList: current On: aStream [
	current == self
		ifFalse: [ aStream
				<< ' . ';
				<< current element printString ]
		ifTrue: [ aStream
				<< ' . <';
				<< element printString;
				<< '>' ]
]

{ #category : #printing }
EIChain >> printFirstElementOfList: current On: aStream [
	current == self
		ifFalse: [ aStream
				<< current element printString ]
		ifTrue: [ aStream
				<< '<';
				<< element printString;
				<< '>' ]
]

{ #category : #printing }
EIChain >> printOn: aStream [
	| current |
	super printOn: aStream.
	aStream << ' : ('.
	current := previous ifNotNil: [ previous ] ifNil: [ self ].
	[ current previous isNotNil ]
		whileTrue: [ current := current previous ].
	self printFirstElementOfList: current On: aStream .
	[ current next isNotNil ]
		whileTrue: [ current := current next.
			self printElementOfList: current On: aStream ].
	aStream << ')' 
]

{ #category : #update }
EIChain >> putAfter: anElement [
	"Updates the element of the next link. Returns its previous element"

	next
		ifNotNil: [ | oldElement |
			oldElement := next element.
			next element: anElement.
			^ oldElement ]
		ifNil: [ self addAfter: anElement.
			^ nil ]
]

{ #category : #update }
EIChain >> putBefore: anElement [
	"Updates the element of the previous link. Returns its previous element"

	previous
		ifNotNil: [ | oldElement |
			oldElement := previous element.
			previous element: anElement.
			^ oldElement ]
		ifNil: [ self addBefore: anElement.
			^ nil ]
]

{ #category : #removing }
EIChain >> removeNext [
	"Removes the link following this one and returns its element"

	| oldElement |
	next ifNil: [ ^ nil ].
	oldElement := next element.
	self next: next next.
	next ifNotNil: [ next previous: self ].
	^ oldElement
]

{ #category : #removing }
EIChain >> removePrevious [
	"Removes the link preceding this one and returns its element"

	| oldElement |
	previous ifNil: [ ^ nil ].
	oldElement := previous element.
	self previous: previous previous.
	previous ifNotNil: [ previous next: self ].
	^ oldElement
]

{ #category : #transforming }
EIChain >> reverse [
	"Returns the first link a new chain containing this one's element in reverse order"

	| newList current |
	current := self last.
	newList := self class newForElement: current element.
	[ current previous isNotNil ]
		whileTrue: [ current := current previous.
			newList addAfter: current element.
			newList := newList next ].
	^ newList first
]
