Class {
	#name : #BaselineOfExercicesInria,
	#superclass : #BaselineOf,
	#category : #BaselineOfExercicesInria
}

{ #category : #baselines }
BaselineOfExercicesInria >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ "Packages"
			spec
				package: 'EIChain';
				package: 'EIDocumentation' ]
]
