Class {
	#name : #EIPackageDocGenerator,
	#superclass : #Object,
	#instVars : [
		'package',
		'directory',
		'homepage'
	],
	#category : #EIDocumentation
}

{ #category : #'instance creation' }
EIPackageDocGenerator class >> newForPackage: packageName [
	^ self basicNew
		package: packageName;
		initialize
]

{ #category : #initialization }
EIPackageDocGenerator >> checkPackageExistence [
	(SystemNavigation default allClassesInPackageNamed: package)
		ifEmpty: [ self error: 'This package is empty or does not exist.' ]
]

{ #category : #'class pages' }
EIPackageDocGenerator >> commentOfClass: aClass In: html [
	aClass hasComment
		ifTrue: [ html
				tag: #h3 with: 'Class comment :';
				tag: #p with: aClass comment ]
]

{ #category : #homepage }
EIPackageDocGenerator >> generateClassListIn: html [
	html
		tag: #ul
		do: [ (SystemNavigation default allClassesInPackageNamed: package)
				do: [ :class | 
					| classFileName |
					(class inheritsFrom: TestCase)
						ifFalse: [ self generatePageForClass: class.
							classFileName := WriteStream with: class printString.
							classFileName nextPutAll: '.html'.
							html
								tag: #li
								do: [ html
										tag: #a
										attributes:
											{'href'.
											classFileName contents}
										with: class printString ] ] ] ]
]

{ #category : #'class pages' }
EIPackageDocGenerator >> generateClassMethodsListFor: aClass In: html [
	html
		tag: #ul
		do: [ aClass classSide methods
				do: [ :method | html tag: #li with: method selector ] ]
]

{ #category : #'class pages' }
EIPackageDocGenerator >> generateClassMethodsListForProtocol: protocol inClass: aClass in: html [
	html
		tag: #p
		do: [ html
				tag: #ul
				do: [ (aClass classSide methods
						select: [ :method | method protocol == protocol ])
						do: [ :method | 
							html tag: #li with: method selector asString.
							method numArgs > 0
								ifTrue: [ html
										tag: #details
										do: [ html
												tag: #summary with: 'Arguments';
												tag: #ul
													do: [ method argumentNames do: [ :arg | html tag: #li with: arg ] ] ] ].
							method comment
								ifNotNil: [ html
										tag: #details
										do: [ html
												tag: #summary with: 'Comment';
												tag: #p with: method comment ] ] ] ] ]
]

{ #category : #'class pages' }
EIPackageDocGenerator >> generateClassProtocolsListFor: aClass In: html [
	aClass classSide protocols
		do: [ :protocol | 
			html
				tag: #h4 with: protocol asString;
				tag: #ul
					do: [ self
						generateClassMethodsListForProtocol: protocol
						inClass: aClass
						in: html ] ]
]

{ #category : #homepage }
EIPackageDocGenerator >> generateHomePage [
	| homepageContents |
	homepageContents := ZnHtmlOutputStream
		streamContents: [ :html | 
			html
				page: package
				do: [ self linkToDocumentationHomePageIn: html.
					html
						tag: #h3 with: 'Classes :';
						tag: #p do: [ self generateClassListIn: html ] ] ].
	directory / homepage
		writeStreamDo: [ :stream | stream nextPutAll: homepageContents ]
]

{ #category : #'class pages' }
EIPackageDocGenerator >> generateInstanceProtocolsListFor: aClass In: html [
	aClass protocols
		do: [ :protocol | 
			html
				tag: #h4 with: protocol asString;
				tag: #ul
					do: [ self
						generateMethodsListForProtocol: protocol
						inClass: aClass
						in: html ] ]
]

{ #category : #'class pages' }
EIPackageDocGenerator >> generateMethodsListForProtocol: protocol inClass: aClass in: html [
	html
		tag: #p
		do: [ html
				tag: #ul
				do: [ (aClass methods select: [ :method | method protocol == protocol ])
						do: [ :method | 
							html tag: #li with: method selector asString.
							method numArgs > 0
								ifTrue: [ html
										tag: #details
										do: [ html
												tag: #summary with: 'Arguments';
												tag: #ul
													do: [ method argumentNames do: [ :arg | html tag: #li with: arg ] ] ] ].
							method comment
								ifNotNil: [ html
										tag: #details
										do: [ html
												tag: #summary with: 'Comment';
												tag: #p with: method comment ] ] ] ] ]
]

{ #category : #'class pages' }
EIPackageDocGenerator >> generatePageForClass: aClass [
	| classPageContents classFile |
	classPageContents := ZnHtmlOutputStream
		streamContents: [ :html | 
			html
				page: aClass printString
				do: [ self
						linkToDocumentationHomePageIn: html;
						linkToPackageHomepageIn: html;
						superClassOf: aClass In: html;
						commentOfClass: aClass In: html.
					html
						tag: #h3 with: 'Class methods :';
						tag: #p
							do: [ self generateClassProtocolsListFor: aClass In: html ];
						tag: #h3 with: 'Instance methods :';
						tag: #p
							do: [ self generateInstanceProtocolsListFor: aClass In: html ] ] ].
	classFile := aClass printString , '.html'.
	directory / classFile
		writeStreamDo: [ :stream | stream nextPutAll: classPageContents ]
]

{ #category : #initialization }
EIPackageDocGenerator >> initialize [
	super initialize.
	self checkPackageExistence.
	directory := FileSystem disk workingDirectory / 'Documentation'
		/ package.
	directory ensureCreateDirectory.
	homepage := 'Package_' , package , '.html'.
	self generateHomePage
]

{ #category : #'private - utilities' }
EIPackageDocGenerator >> linkToDocumentationHomePageIn: html [
	html
		tag: #p
		do: [ html
				tag: #a
				attributes:
					{'href'.
					EIDocumentationGenerator homepage fullName}
				with: 'Back to Documentation homepage' ]
]

{ #category : #'private - utilities' }
EIPackageDocGenerator >> linkToPackageHomepageIn: html [
	html
		tag: #p
		do: [ html
				tag: #a
				attributes:
					{'href'.
					homepage}
				with: 'Back to package homepage' ]
]

{ #category : #accessing }
EIPackageDocGenerator >> package [
	^ package
]

{ #category : #accessing }
EIPackageDocGenerator >> package: aString [
	package := aString
]

{ #category : #'class pages' }
EIPackageDocGenerator >> superClassOf: aClass In: html [
	aClass superclass category == package
		ifTrue:
			[ html tag: #h4 with: 'Superclass : ' , aClass superclass printString ]
]
