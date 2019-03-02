Class {
	#name : #EIChainTest,
	#superclass : #TestCase,
	#instVars : [
		'list',
		'longList',
		'longListLast'
	],
	#category : #EIList
}

{ #category : #running }
EIChainTest >> setUp [
	super setUp.
	list := EIChain newForElement: $l.
	longList := EIChain newFrom: 'Hello'.
	longListLast := longList next next next next.
]

{ #category : #adding }
EIChainTest >> testAddAfter [
	list addAfter: $m.
	self
		assert: list next class equals: EIChain;
		assert: list next element equals: $m;
		assert: list next next isNil
]

{ #category : #adding }
EIChainTest >> testAddAfterLong [
	longList addAfter: $a.
	self
		assert: longList next class equals: EIChain;
		assert: longList next element equals: $a;
		assert: longList next next element equals: $e
]

{ #category : #adding }
EIChainTest >> testAddBefore [
	list addBefore: $k.
	self
		assert: list previous class equals: EIChain;
		assert: list previous element equals: $k;
		assert: list previous previous isNil
]

{ #category : #adding }
EIChainTest >> testAddBeforeLong [
	| current |
	current := longList next.
	current addBefore: $a.
	self
		assert: current previous class equals: EIChain;
		assert: current previous element equals: $a;
		assert: current previous previous element equals: $H
]

{ #category : #transforming }
EIChainTest >> testApply [
	| initialList transformedList |
	initialList := EIChain newFrom: #(1 2 3 4 5).
	transformedList := initialList apply: [ :i | i + 1 ].
	self assert: transformedList equals: (EIChain newFrom: #(2 3 4 5 6))
]

{ #category : #testing }
EIChainTest >> testEquals [
	| idemList otherList |
	idemList := EIChain newFrom: 'Hello'.
	otherList := EIChain newFrom: #(1 2 3 4 5).
	self
		assert: idemList equals: longList;
		assert: otherList ~= longList.
	idemList := idemList next.
	self assert: idemList equals: longList
]

{ #category : #accessing }
EIChainTest >> testFirst [
	| current |
	current := EIChain newFrom: 'This is a test !'.
	current := current next next next next.
	self
		assert: current first element equals: $T;
		assert: current first next element equals: $h;
		assert: current first previous isNil
]

{ #category : #accessing }
EIChainTest >> testLast [
	| current |
	current := EIChain newFrom: 'This is a test !'.
	self
		assert: current last element equals: $!;
		assert: current last previous element equals: Character space;
		assert: current last next isNil
]

{ #category : #'instance creation' }
EIChainTest >> testNewForElement [
	| newList |
	newList := EIChain newForElement: Color red.
	self
		assert: newList element equals: Color red;
		assert: newList previous isNil;
		assert: newList next isNil
]

{ #category : #'instance creation' }
EIChainTest >> testNewFrom [
	| newList |
	newList := EIChain
		newFrom:
			{Color red.
			1.
			'Hello'}.
	self
		assert: newList element equals: Color red;
		assert: newList next class equals: EIChain;
		assert: newList next element equals: 1;
		assert: newList next next class equals: EIChain;
		assert: newList next next element equals: 'Hello';
		assert: newList next next next isNil;
		assert: newList previous isNil;
		assert: newList next previous == newList
]

{ #category : #printing }
EIChainTest >> testPrintOn [
	self
		assert: list printString equals: 'an EIChain : (<$l>)';
		assert: longList printString
			equals: 'an EIChain : (<$H> . $e . $l . $l . $o)'
]

{ #category : #update }
EIChainTest >> testPutAfter [
	| current |
	current := longList.
	current putAfter: 1.
	self assert: current next element equals: 1
]

{ #category : #update }
EIChainTest >> testPutAfterNil [
	| current |
	current := longList last.
	self
		assert: (current putAfter: 1) isNil;
		assert: current next element equals: 1
]

{ #category : #update }
EIChainTest >> testPutAfterReturn [
	| current |
	current := longList.
	self assert: (current putAfter: 1) equals: $e
]

{ #category : #update }
EIChainTest >> testPutBefore [
	| current |
	current := longList next.
	current putBefore: 1.
	self assert: current previous element equals: 1
]

{ #category : #update }
EIChainTest >> testPutBeforeNil [
	| current |
	current := longList.
	self
		assert: (current putBefore: 1) isNil;
		assert: current previous element equals: 1
]

{ #category : #update }
EIChainTest >> testPutBeforeReturn [
	| current |
	current := longList next.
	self assert: (current putBefore: 1) equals: $H
]

{ #category : #removing }
EIChainTest >> testRemoveNext [
	|current|
	current := longList.
	current removeNext.
	self assert: current next element equals: $l.
]

{ #category : #removing }
EIChainTest >> testRemoveNextNil [
	|current|
	current := longListLast.
	current removeNext.
	self assert: current next isNil.
]

{ #category : #removing }
EIChainTest >> testRemoveNextReturn [
	|current|
	current := longList.
	self assert: current removeNext equals: $e.
	current := current last.
	self assert: current removeNext isNil
]

{ #category : #removing }
EIChainTest >> testRemovePrevious [
	|current|
	current := longList next.
	current removePrevious.
	self assert: current previous isNil.
]

{ #category : #removing }
EIChainTest >> testRemovePreviousNil [
	|current|
	current := longList.
	current removePrevious.
	self assert: current previous isNil.
]

{ #category : #removing }
EIChainTest >> testRemovePreviousReturn [
	|current|
	current := longList.
	self assert: current removePrevious isNil.
	current := current last.
	self assert: current removePrevious equals: $l
]

{ #category : #transforming }
EIChainTest >> testReverse [
	self assert: longList reverse equals: (EIChain newFrom: 'olleH')
]
